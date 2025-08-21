// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medsos/service/user_provider.dart';
import 'package:medsos/views/subscription/confirm.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});
  //fonction dappel
  Future<String> createCallSession({
    required String callerName,
    required String callerPhone,
  }) async {
    final roomCode = _generateRoomCode(); // You already have this

    await FirebaseFirestore.instance.collection('call_sessions').add({
      'callerName': callerName,
      'callerPhone': callerPhone,
      'calleeName': null,
      'calleePhone': null,
      'roomCode': roomCode,
      'status': 'pending',
      'timestamp': Timestamp.now(),
    });

    return roomCode;
  }

  String _generateRoomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Row
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 50),
                    GestureDetector(
                      onTap: () => context.go('/help'),
                      child: const CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 247, 116, 116),
                        radius: 18,
                        child: Icon(
                          Icons.info_outline,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Emergency help\nneeded?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Just press the button to call',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),

              /// BIG RED BUTTON (No logic yet)
              GestureDetector(
                onTap: () {
                  final userProvider = context.read<UserProvider>();
                  final user = userProvider.user;

                  if (user == null) return;

                  // 🔁 Directly navigate to confirmation page (voice or video)
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder:
                          (_) =>
                              ConfirmCallPage(), // Pass the user to use phone/name
                    ),
                  );
                },

                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade400, width: 4),
                    color: Colors.red,
                  ),
                  child: const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.emergency, color: Colors.white, size: 50),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // const Text(
              //   'Not sure what to do?',
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 4),
              // const Text(
              //   'Pick the subject to chat',
              //   style: TextStyle(color: Colors.grey),
              // ),
              // const SizedBox(height: 16),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 12),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       GestureDetector(
              //         onTap:
              //             () => context.go(
              //               '/ai-assistant',
              //               extra: {'initialText': 'Hello Doctor!'},
              //             ),
              //         child: _chatOptionButton(
              //           'I have an\ninjury',
              //           Icons.arrow_right_alt,
              //         ),
              //       ),
              //       _chatOptionButton('I\'m feeling\nbad', Icons.remove),
              //       _chatOptionButton(
              //         'I have a\nquestion',
              //         Icons.arrow_right_alt,
              //       ),
              //     ],
              //   ),
              // ),
              const Text(
                'Not sure what to do? Get a look on our FirstAid',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              //firstAid button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () => context.go('/first-aid'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.green.shade200,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Replace with your image
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/firstaid.png',
                              ), // <-- your image here
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Access First Aid',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Learn essential steps to handle emergencies before help arrives.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
