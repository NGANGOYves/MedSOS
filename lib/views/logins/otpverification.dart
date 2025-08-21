// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:medsos/views/logins/register_screen.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

// class OTPVerificationScreen extends StatefulWidget {
//   final String phone;
//   final String verificationId;

//   const OTPVerificationScreen({
//     super.key,
//     required this.phone,
//     required this.verificationId,
//   });

//   @override
//   State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
// }

// class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
//   final TextEditingController otpController = TextEditingController();
//   // int countdown = 300;
//   Timer? timer;
//   bool _isLoading = false;
//   String? currentVerificationId;
//   // bool codeExpired = false;

//   @override
//   void initState() {
//     super.initState();
//     currentVerificationId = widget.verificationId;
//     // startCountdown(); // disabled for now
//   }

//   Future<void> _verifyOTP() async {
//     setState(() => _isLoading = true);
//     try {
//       final smsCode = otpController.text.trim();
//       final credential = PhoneAuthProvider.credential(
//         verificationId: currentVerificationId!,
//         smsCode: smsCode,
//       );

//       await FirebaseAuth.instance.signInWithCredential(credential);

//       if (!mounted) return; // <== This check is very important here

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Login successful")));

//       if (!mounted) return; // And before navigation too

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => RegisterScreen(phone: widget.phone),
//         ),
//       ); // Prefer context.go to Navigator.pushReplacement
//     } catch (e) {
//       if (!mounted) return; // <== Before using context

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Invalid OTP: $e")));
//     } finally {
//       if (!mounted) return; // <== Before calling setState

//       setState(() => _isLoading = false);
//     }
//   }

//   void _resendOTP() async {
//     setState(() => _isLoading = true);
//     try {
//       await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: widget.phone,
//         verificationCompleted: (PhoneAuthCredential credential) {},
//         verificationFailed: (FirebaseAuthException e) {
//           if (!mounted) return;
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Verification failed: ${e.message}")),
//           );
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           if (!mounted) return;
//           otpController.text = '';
//           setState(() {
//             currentVerificationId = verificationId;

//             // startCountdown(); // Disabled
//           });

//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(const SnackBar(content: Text("Code resent")));
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           if (!mounted) return;
//           setState(() => currentVerificationId = verificationId);
//         },
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(
//         // ignore: use_build_context_synchronously
//         context,
//       ).showSnackBar(SnackBar(content: Text("Resend failed: $e")));
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     otpController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         onTap: () {}, // disable auto pop
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Container(
//                 padding: const EdgeInsets.only(top: 60.0, bottom: 24.0),
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     Align(
//                       alignment: Alignment.topLeft,
//                       child: IconButton(
//                         icon: const Icon(Icons.arrow_back, color: Colors.white),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                     ),
//                     CircleAvatar(
//                       radius: 32,
//                       backgroundColor: Colors.white,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Image.asset('assets/images/logo.jpg'),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'MedSOS',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'Verify Your Phone',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "We've sent a 6-digit verification code to",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       widget.phone,
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text('Enter verification code'),
//                     const SizedBox(height: 12),
//                     AbsorbPointer(
//                       // absorbing: codeExpired,
//                       absorbing: false,
//                       child: PinCodeTextField(
//                         appContext: context,
//                         length: 6,
//                         controller: otpController,
//                         autoFocus: true,
//                         animationType: AnimationType.fade,
//                         pinTheme: PinTheme(
//                           shape: PinCodeFieldShape.box,
//                           borderRadius: BorderRadius.circular(8),
//                           fieldHeight: 50,
//                           fieldWidth: 40,
//                           activeColor: Colors.green,
//                           selectedColor: Colors.green,
//                           inactiveColor: Colors.grey,
//                         ),
//                         onChanged: (value) {},
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       '', // No expiration text for now
//                       style: TextStyle(color: Colors.red),
//                     ),
//                     const SizedBox(height: 12),
//                     TextButton.icon(
//                       // onPressed: _isLoading || !codeExpired ? null : _resendOTP,
//                       onPressed: _isLoading ? null : _resendOTP,
//                       icon: const Icon(Icons.refresh),
//                       label: const Text("Resend Code"),
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       // onPressed: (_isLoading || codeExpired) ? null : _verifyOTP,
//                       onPressed: _isLoading ? null : _verifyOTP,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         minimumSize: const Size(double.infinity, 50),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child:
//                           _isLoading
//                               ? const CircularProgressIndicator(
//                                 color: Colors.white,
//                               )
//                               : const Text('Verify'),
//                     ),
//                     const SizedBox(height: 24),
//                     const Divider(),
//                     const SizedBox(height: 8),
//                     OutlinedButton.icon(
//                       onPressed: () => Navigator.pop(context),
//                       icon: const Icon(Icons.phone, color: Colors.black),
//                       label: const Text('Change Phone Number'),
//                       style: OutlinedButton.styleFrom(
//                         side: const BorderSide(color: Colors.grey),
//                         minimumSize: const Size(double.infinity, 50),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     OutlinedButton.icon(
//                       onPressed: () {},
//                       icon: const Icon(Icons.help_outline, color: Colors.black),
//                       label: const Text('Contact Support'),
//                       style: OutlinedButton.styleFrom(
//                         side: const BorderSide(color: Colors.grey),
//                         minimumSize: const Size(double.infinity, 50),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade100,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         children: const [
//                           Icon(
//                             Icons.verified_user_outlined,
//                             color: Colors.green,
//                           ),
//                           SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               'Your phone number is secure and will only be used for verification purposes.',
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medsos/views/logins/register_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phone;
  final String verificationId;

  const OTPVerificationScreen({
    super.key,
    required this.phone,
    required this.verificationId,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  Timer? timer;
  bool _isLoading = false;
  String? currentVerificationId;
  String enteredOTP = "";
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    currentVerificationId = widget.verificationId;
  }

  Future<void> _verifyOTP() async {
    if (_isDisposed || enteredOTP.length < 6) return;

    setState(() => _isLoading = true);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: currentVerificationId!,
        smsCode: enteredOTP,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login successful")));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterScreen(phone: widget.phone),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid OTP: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _resendOTP() async {
    if (_isDisposed) return;
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phone,
        verificationCompleted: (_) {},
        verificationFailed: (FirebaseAuthException e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Verification failed: ${e.message}")),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          if (!mounted) return;
          setState(() {
            currentVerificationId = verificationId;
            enteredOTP = ""; // reset entered code
          });

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Code resent")));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (!mounted) return;
          setState(() => currentVerificationId = verificationId);
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Resend failed: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {},
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 60.0, bottom: 24.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/images/logo.jpg'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'MedSOS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Verify Your Phone',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "We've sent a 6-digit verification code to",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.phone,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text('Enter verification code'),
                    const SizedBox(height: 12),
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      autoFocus: true,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeColor: Colors.green,
                        selectedColor: Colors.green,
                        inactiveColor: Colors.grey,
                      ),
                      onChanged: (value) => enteredOTP = value,
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _isLoading ? null : _resendOTP,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Resend Code"),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _verifyOTP,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text('Verify'),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.phone, color: Colors.black),
                      label: const Text('Change Phone Number'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.help_outline, color: Colors.black),
                      label: const Text('Contact Support'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.verified_user_outlined,
                            color: Colors.green,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Your phone number is secure and will only be used for verification purposes.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
