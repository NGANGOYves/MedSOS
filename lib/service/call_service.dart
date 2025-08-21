// import 'dart:async';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:medsos/main.dart';
// import 'package:medsos/views/Patient_part/call/CallMeet/call.dart';

// class DoctorCallListenerService {
//   static final DoctorCallListenerService _instance =
//       DoctorCallListenerService._internal();
//   factory DoctorCallListenerService() => _instance;
//   DoctorCallListenerService._internal();

//   final _db = FirebaseDatabase.instance;
//   StreamSubscription<DatabaseEvent>? _subscription;
//   OverlayEntry? _overlayEntry;

//   String? _currentDoctorName;

//   void start({required String doctorName}) {
//     _currentDoctorName = doctorName;

//     _subscription?.cancel();

//     final ref = _db.ref('call_sessions');
//     _subscription = ref.onChildAdded.listen((event) {
//       final data = event.snapshot.value as Map?;
//       if (data == null) return;

//       final status = data['status'];
//       final callee = data['callee'];
//       final caller = data['caller'];
//       final roomCode = data['roomCode'];
//       final callId = event.snapshot.key;

//       if (status == 'pending' && (callee == null || callee == '')) {
//         _showIncomingCall(callId!, caller ?? 'Unknown', roomCode ?? '');
//       }
//     });
//   }

//   void _showIncomingCall(String callId, String callerName, String roomCode) {
//     if (_overlayEntry != null) return;

//     final context = navigatorKey.currentContext;
//     if (context == null) return;

//     _overlayEntry = OverlayEntry(
//       builder:
//           (_) => Positioned(
//             top: 40,
//             left: 16,
//             right: 16,
//             child: Material(
//               elevation: 8,
//               borderRadius: BorderRadius.circular(16),
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.green.shade50,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.phone, color: Colors.green),
//                     const SizedBox(width: 12),
//                     Expanded(child: Text("Incoming call from $callerName")),
//                     TextButton(
//                       onPressed: () async {
//                         _removeOverlay();

//                         await _db.ref("call_sessions/$callId").update({
//                           'callee': _currentDoctorName,
//                           'status': 'accepted',
//                         });

//                         navigatorKey.currentState?.push(
//                           MaterialPageRoute(
//                             builder: (_) => Call(callID: roomCode),
//                           ),
//                         );
//                       },
//                       child: const Text("Accept"),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//     );

//     navigatorKey.currentState?.overlay?.insert(_overlayEntry!);
//   }

//   void _removeOverlay() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }

//   void dispose() {
//     _subscription?.cancel();
//     _overlayEntry?.remove();
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:medsos/main.dart';
// import 'package:medsos/views/Patient_part/call/CallMeet/call.dart';
// import 'package:flutter_animate/flutter_animate.dart';

// import 'package:vibration/vibration.dart';

// class DoctorCallListenerService {
//   static final DoctorCallListenerService _instance =
//       DoctorCallListenerService._internal();
//   factory DoctorCallListenerService() => _instance;
//   DoctorCallListenerService._internal();

//   StreamSubscription<QuerySnapshot>? _subscription;
//   OverlayEntry? _overlayEntry;

//   String? _currentDoctorName;

//   void start({required String doctorName}) {
//     _currentDoctorName = doctorName;

//     _subscription?.cancel();

//     _subscription = FirebaseFirestore.instance
//         .collection('call_sessions')
//         .where('status', isEqualTo: 'pending')
//         .snapshots()
//         .listen((snapshot) {
//           for (var doc in snapshot.docs) {
//             final data = doc.data();
//             final callee = data['calleeName'];
//             final callerName = data['caller'];
//             final roomCode = data['roomCode'];
//             final callId = doc.id;
//             final callType = data['type']; // 👈 'voice' or 'video'

//             if (callee == null || callee == '') {
//               _showIncomingCall(
//                 callId,
//                 callerName ?? 'Inconnu',
//                 roomCode ?? '',
//                 callType ?? 'video',
//               );
//             }
//           }
//         });
//   }

//   void _showIncomingCall(
//     String callId,
//     String callerName,
//     String roomCode,
//     String type,
//   ) async {
//     if (_overlayEntry != null) return;

//     final context = navigatorKey.currentContext;
//     if (context == null) return;

//     // Vibrate the phone if possible
//     if (await Vibration.hasVibrator()) {
//       Vibration.vibrate(pattern: [0, 500, 1000, 500], repeat: 0);
//     }

//     _overlayEntry = OverlayEntry(
//       builder:
//           (_) => Positioned(
//             top: 60,
//             left: 20,
//             right: 20,
//             child: Material(
//               elevation: 10,
//               borderRadius: BorderRadius.circular(20),
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: Colors.green, width: 2),
//                 ),
//                 child: Row(
//                   children: [
//                     // Ringing phone animation
//                     Animate(
//                       effects: [
//                         ScaleEffect(
//                           duration: 600.ms,
//                           curve: Curves.easeInOut,
//                           begin: const Offset(1.0, 1.0), // normal size
//                           end: const Offset(1.2, 1.2), // scale to 120%
//                         ),
//                       ],
//                       onPlay: (controller) => controller.repeat(reverse: true),
//                       child: Icon(
//                         Icons.phone_in_talk,
//                         color: Colors.green,
//                         size: 36,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     // Caller name
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             "Appel entrant",
//                             style: TextStyle(
//                               color: Colors.black54,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             callerName,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.green,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Accept button
//                     IconButton(
//                       icon: const Icon(Icons.call, color: Colors.white),
//                       style: IconButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         shape: const CircleBorder(),
//                       ),
//                       onPressed: () async {
//                         _removeOverlay();
//                         Vibration.cancel(); // stop vibration

//                         await FirebaseFirestore.instance
//                             .collection("call_sessions")
//                             .doc(callId)
//                             .update({
//                               'calleeName': _currentDoctorName,
//                               'status': 'answered',
//                             });

//                         navigatorKey.currentState?.push(
//                           MaterialPageRoute(
//                             builder: (_) => Call(callID: roomCode, type: type),
//                           ),
//                         );
//                       },
//                     ),
//                     // Decline button
//                     IconButton(
//                       icon: const Icon(Icons.call_end, color: Colors.white),
//                       style: IconButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         shape: const CircleBorder(),
//                       ),
//                       onPressed: () {
//                         _removeOverlay();
//                         Vibration.cancel(); // stop vibration
//                         FirebaseFirestore.instance
//                             .collection("call_sessions")
//                             .doc(callId)
//                             .update({'status': 'declined'});
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//     );

//     navigatorKey.currentState?.overlay?.insert(_overlayEntry!);
//   }

//   void _removeOverlay() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }

//   void dispose() {
//     _subscription?.cancel();
//     _overlayEntry?.remove();
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medsos/main.dart';
import 'package:medsos/views/Patient_part/call/CallMeet/call.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';

class DoctorCallListenerService {
  static final DoctorCallListenerService _instance =
      DoctorCallListenerService._internal();
  factory DoctorCallListenerService() => _instance;
  DoctorCallListenerService._internal();

  StreamSubscription<QuerySnapshot>? _subscription;
  OverlayEntry? _overlayEntry;

  String? _currentDoctorName;
  String? _activeCallId;

  void start({required String doctorName}) {
    _currentDoctorName = doctorName;
    _subscription?.cancel();

    _subscription = FirebaseFirestore.instance
        .collection('call_sessions')
        .snapshots()
        .listen((snapshot) {
          for (var change in snapshot.docChanges) {
            final doc = change.doc;
            final data = doc.data();
            final callId = doc.id;

            if (data == null) continue;

            final status = data['status'];
            final callee = data['calleeName'];
            final callerName = data['caller'];
            final roomCode = data['roomCode'];
            final callType = data['type'] ?? 'video';

            // Show banner only for new pending call (not already handled)
            if (status == 'pending' && (callee == null || callee == '')) {
              if (_overlayEntry == null) {
                _activeCallId = callId;
                _showIncomingCall(
                  callId,
                  callerName ?? 'Inconnu',
                  roomCode ?? '',
                  callType,
                );
              }
            }

            // Hide the banner if someone accepted the call
            if (_activeCallId == callId && status == 'answered') {
              _removeOverlay();
              _activeCallId = null;
            }

            // If this doctor declined the call (status changed to declined),
            // we already removed the overlay manually in the decline button handler,
            // so no need to force remove it here globally.
          }
        });
  }

  void _showIncomingCall(
    String callId,
    String callerName,
    String roomCode,
    String type,
  ) async {
    if (_overlayEntry != null) return;

    final context = navigatorKey.currentContext;
    if (context == null) return;

    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(pattern: [0, 500, 1000, 500], repeat: 0);
    }

    _overlayEntry = OverlayEntry(
      builder:
          (_) => Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Row(
                  children: [
                    Animate(
                      effects: [
                        ScaleEffect(
                          duration: 600.ms,
                          curve: Curves.easeInOut,
                          begin: const Offset(1.0, 1.0),
                          end: const Offset(1.2, 1.2),
                        ),
                      ],
                      onPlay: (controller) => controller.repeat(reverse: true),
                      child: Icon(
                        Icons.phone_in_talk,
                        color: Colors.green,
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Appel entrant",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            callerName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.call, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: const CircleBorder(),
                      ),
                      onPressed: () async {
                        _removeOverlay();
                        Vibration.cancel();

                        await FirebaseFirestore.instance
                            .collection("call_sessions")
                            .doc(callId)
                            .update({
                              'calleeName': _currentDoctorName,
                              'status': 'answered',
                            });

                        navigatorKey.currentState?.push(
                          MaterialPageRoute(
                            builder: (_) => Call(callID: roomCode, type: type),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.call_end, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: const CircleBorder(),
                      ),
                      onPressed: () {
                        _removeOverlay();
                        Vibration.cancel();
                        FirebaseFirestore.instance
                            .collection("call_sessions")
                            .doc(callId)
                            .update({'status': 'declined'});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    navigatorKey.currentState?.overlay?.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void dispose() {
    _subscription?.cancel();
    _removeOverlay();
    _activeCallId = null;
  }
}
