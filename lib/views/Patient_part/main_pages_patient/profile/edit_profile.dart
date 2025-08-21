import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medsos/model/usermodel.dart';
import 'package:medsos/service/user_provider.dart';
import 'package:medsos/widgets/backwrapper.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController occupationController;
  late TextEditingController phoneController;

  File? imageFile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user!;
    fullNameController = TextEditingController(text: user.fullName);
    emailController = TextEditingController(text: user.email);
    occupationController = TextEditingController(text: user.occupation ?? '');
    phoneController = TextEditingController(text: user.phone);
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => imageFile = File(picked.path));
    }
  }

  Future<String?> uploadProfileImage(String phone) async {
    if (imageFile == null) return null;
    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child('$phone.jpg');
    await ref.putFile(imageFile!);
    return await ref.getDownloadURL();
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final userProvider = context.read<UserProvider>();
    final currentUser = userProvider.user!;
    final phone = currentUser.phone;

    try {
      // Upload image if changed
      String? newPhotoUrl = await uploadProfileImage(phone);

      // Create new user model with updated data
      final updatedUser = UserModel(
        fullName: fullNameController.text.trim(),
        phone: phone, // immutable
        email: emailController.text.trim(),
        role: currentUser.role,
        photoUrl: newPhotoUrl ?? currentUser.photoUrl,
        address: currentUser.address,
        occupation: occupationController.text.trim(),
      );

      final userDocRef = FirebaseFirestore.instance
          .collection('user')
          .doc(phone);

      // Mise à jour uniquement des champs existants (pas de création d'un nouveau document)
      await userDocRef.set(updatedUser.toMap(), SetOptions(merge: true));

      // Mise à jour dans le provider/shared preferences
      await userProvider.setUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      }
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        // Le document n'existe pas : on peut choisir d'afficher un message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User document not found. Please try again later.'),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile: ${e.message}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Unexpected error: $e')));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user!;
    return BackRedirectWrapper(
      targetRoute: '/setting-patient',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  imageFile != null
                                      ? FileImage(imageFile!)
                                      : (user.photoUrl != null &&
                                          user.photoUrl!.isNotEmpty)
                                      ? NetworkImage(user.photoUrl!)
                                          as ImageProvider
                                      : const AssetImage(
                                        'assets/images/default_avatar.png',
                                      ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: pickImage,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: fullNameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                          ),
                          enabled:
                              false, // <-- Add this line to make it unmodifiable
                          validator:
                              (val) =>
                                  val!.isEmpty
                                      ? 'Please enter your name'
                                      : null,
                        ),

                        const SizedBox(height: 10),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator:
                              (val) =>
                                  val!.isEmpty
                                      ? 'Please enter your email'
                                      : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: occupationController,
                          decoration: const InputDecoration(
                            labelText: 'Occupation',
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                          ),
                          enabled: false,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.save),
                          label: const Text('Save Changes'),
                          onPressed: saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
