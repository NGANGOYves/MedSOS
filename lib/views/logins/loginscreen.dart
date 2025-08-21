import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:medsos/views/logins/otpverification.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  bool isChecked = false;
  String phoneNumber = '';
  int selectedIndex = 0; // 0 = Patient, 1 = Doctor

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => Center(
            child: CircularProgressIndicator(color: Colors.green[600]),
          ),
    );
  }

  void hideLoadingDialog() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🌿 Header
          Container(
            padding: const EdgeInsets.only(top: 80, bottom: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    'assets/images/pharmacy_Icon-1.png',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 130),
                    const Text(
                      'MedSOS',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 🔄 Toggle Patient / Doctor
                // ToggleButtons(
                //   isSelected: [selectedIndex == 0, selectedIndex == 1],
                //   onPressed: (index) {
                //     setState(() {
                //       selectedIndex = index;
                //     });
                //   },
                //   borderRadius: BorderRadius.circular(10),
                //   fillColor: Colors.white,
                //   selectedColor: Colors.green[700],
                //   color: Colors.white,
                //   constraints: const BoxConstraints(
                //     minHeight: 40,
                //     minWidth: 130,
                //   ),
                //   children: const [
                //     Text(
                //       "Patient",
                //       style: TextStyle(fontWeight: FontWeight.bold),
                //     ),
                //     Text(
                //       "Doctor",
                //       style: TextStyle(fontWeight: FontWeight.bold),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),

          // 📱 Phone Input & Terms
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Enter your phone number',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  IntlPhoneField(
                    decoration: const InputDecoration(
                      hintText: '6 XX XX XX XX',
                      border: OutlineInputBorder(),
                    ),
                    initialCountryCode: 'CM',
                    onChanged: (phone) {
                      phoneNumber = phone.completeNumber;
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "We'll send a verification code to this number.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: isChecked,
                        activeColor: Colors.green,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(text: 'I agree to the '),
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ✅ Continue Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed:
                          isChecked
                              ? () async {
                                if (phoneNumber.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please enter your phone number.",
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                showLoadingDialog();

                                try {
                                  await FirebaseAuth.instance.verifyPhoneNumber(
                                    phoneNumber: phoneNumber,
                                    verificationCompleted: (
                                      PhoneAuthCredential credential,
                                    ) async {
                                      await FirebaseAuth.instance
                                          .signInWithCredential(credential);
                                    },
                                    verificationFailed: (
                                      FirebaseAuthException e,
                                    ) {
                                      hideLoadingDialog();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Verification failed: ${e.message}",
                                          ),
                                        ),
                                      );
                                    },
                                    codeSent: (
                                      String verificationId,
                                      int? resendToken,
                                    ) {
                                      hideLoadingDialog();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => OTPVerificationScreen(
                                                phone: phoneNumber,
                                                verificationId: verificationId,
                                              ),
                                        ),
                                      );
                                    },
                                    codeAutoRetrievalTimeout: (
                                      String verificationId,
                                    ) {
                                      hideLoadingDialog();
                                    },
                                    timeout: const Duration(seconds: 60),
                                  );
                                } catch (e) {
                                  hideLoadingDialog();
                                  debugPrint("Error sending OTP: $e");
                                }
                              }
                              : null,
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  Row(
                    children: const [
                      Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('OR'),
                      ),
                      Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Not yet supported")),
                        );
                      },
                      child: const Text(
                        'Sign in with Email',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
