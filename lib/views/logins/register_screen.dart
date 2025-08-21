// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medsos/service/user_provider.dart';
import 'package:provider/provider.dart';

import 'package:medsos/service/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/usermodel.dart';

class RegisterScreen extends StatefulWidget {
  final String phone;

  const RegisterScreen({super.key, required this.phone});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();

  bool agreeToTerms = false;
  bool isNewUser = true;
  bool isLoading = true;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneController.text = widget.phone;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final existing = await _firebaseService.getUserByPhone(widget.phone);
    if (!mounted) return;
    if (existing != null) {
      isNewUser = false;
      fullNameController.text = existing.fullName;
      emailController.text = existing.email;
      usernameController.text = existing.occupation ?? '';
    }
    setState(() => isLoading = false);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        (isNewUser ? agreeToTerms : true)) {
      final firebaseUser = _firebaseService.currentUser;
      if (firebaseUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User is not authenticated.')),
        );
        return;
      }

      final userProvider = context.read<UserProvider>();

      if (!isNewUser) {
        // User exists, récupère document
        final existing = await _firebaseService.getUserByPhone(widget.phone);
        if (existing != null) {
          await userProvider.setUser(existing);

          // Save info localement
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', existing.fullName);
          await prefs.setString('email', existing.email);

          // Redirection selon rôle
          if (context.mounted) {
            if (existing.role == 'patient') {
              context.go('/home-patient');
            } else if (existing.role == 'doctor') {
              context.go('/home-doctor');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Unknown user role.')),
              );
            }
          }
        } else {
          // Cas improbable si isNewUser == false mais pas de doc
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User document not found.')),
          );
        }
      } else {
        // Nouveau user → rôle patient par défaut
        final newUser = UserModel(
          fullName: fullNameController.text.trim(),
          phone: widget.phone,
          email: emailController.text.trim(),
          role: 'patient',
          occupation: usernameController.text.trim(),
        );

        await _firebaseService.saveUserProfile(newUser);
        await userProvider.setUser(newUser);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', newUser.fullName);
        await prefs.setString('email', newUser.email);

        if (context.mounted) {
          context.go('/home-patient');
        }
      }
    } else if (!agreeToTerms && isNewUser) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the Terms of Service.')),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf9f9f9),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Image.asset('assets/images/pharmacy_Icon-1.png'),
                    const SizedBox(height: 10),
                    const Text(
                      "MedSOS",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "Complete Your Registration",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Please provide your details to complete your account setup",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: phoneController,
                            enabled: false,
                            decoration: const InputDecoration(
                              labelText: "Phone Number",
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: fullNameController,
                            enabled: isNewUser,
                            decoration: const InputDecoration(
                              labelText: "Full Name",
                              filled: true,
                            ),
                            validator:
                                (value) => value!.isEmpty ? "Required" : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: emailController,
                            enabled: isNewUser,
                            decoration: const InputDecoration(
                              labelText: "Email Address",
                              filled: true,
                            ),
                            validator:
                                (value) =>
                                    value == null || !value.contains('@')
                                        ? "Enter a valid email"
                                        : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: usernameController,
                            decoration: const InputDecoration(
                              labelText: "Occupation",
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (isNewUser)
                            Row(
                              children: [
                                Checkbox(
                                  value: agreeToTerms,
                                  onChanged:
                                      (val) =>
                                          setState(() => agreeToTerms = val!),
                                  activeColor: Colors.green,
                                ),
                                const Expanded(
                                  child: Text(
                                    "I agree to the Terms of Service and Privacy Policy",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text(
                                "Complete Registration",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
