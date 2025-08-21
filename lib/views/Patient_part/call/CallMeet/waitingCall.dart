// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:medsos/views/Patient_part/call/CallMeet/call.dart';

// class WaitingForDoctorPage extends StatefulWidget {
//   final String roomCode;
//   final String? phone; // ✅ Optionnel

//   const WaitingForDoctorPage({
//     super.key,
//     required this.roomCode,
//     this.phone, // ✅ Peut être ignoré
//   });

//   @override
//   State<WaitingForDoctorPage> createState() => _WaitingForDoctorPageState();
// }

// class _WaitingForDoctorPageState extends State<WaitingForDoctorPage> {
//   late DatabaseReference callRef;
//   late Stream<DatabaseEvent> callStream;

//   @override
//   void initState() {
//     super.initState();
//     callRef = FirebaseDatabase.instance.ref("call_sessions");
//     callStream = callRef.onValue;

//     callStream.listen((event) {
//       final calls = event.snapshot.value as Map<dynamic, dynamic>?;

//       if (calls != null) {
//         calls.forEach((key, value) {
//           if (value["roomCode"] == widget.roomCode &&
//               value["status"] == "accepted") {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder:
//                     (_) => Call(
//                       callID: widget.roomCode,
//                       phone: widget.phone, // ✅ transmis si fourni
//                     ),
//               ),
//             );
//           }
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6FAF7),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             CircularProgressIndicator(color: Colors.green),
//             SizedBox(height: 20),
//             Text("Waiting for a doctor to accept the call..."),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medsos/views/Patient_part/call/CallMeet/call.dart';

class WaitingForDoctorPage extends StatefulWidget {
  final String roomCode;
  final String? phone;
  final String type;

  const WaitingForDoctorPage({
    super.key,
    required this.roomCode,
    this.phone,
    required this.type,
  });

  @override
  State<WaitingForDoctorPage> createState() => _WaitingForDoctorPageState();
}

class _WaitingForDoctorPageState extends State<WaitingForDoctorPage> {
  Stream<DocumentSnapshot>? _callStream;
  bool _navigated = false;
  Timer? _timeoutTimer;
  String? _callDocId;

  @override
  void initState() {
    super.initState();
    _initStream();
    _timeoutTimer?.cancel();
  }

  void _initStream() async {
    final query =
        await FirebaseFirestore.instance
            .collection('call_sessions')
            .where('roomCode', isEqualTo: widget.roomCode)
            .limit(1)
            .get();

    if (query.docs.isEmpty) {
      print("Call session not found");
      return;
    }

    final docId = query.docs.first.id;
    _callDocId = docId;

    _timeoutTimer = Timer(const Duration(seconds: 20), () async {
      if (!_navigated) {
        await FirebaseFirestore.instance
            .collection('call_sessions')
            .doc(docId)
            .update({'status': 'timeout'});

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("⛔ No doctor responded in time."),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });

    _callStream =
        FirebaseFirestore.instance
            .collection('call_sessions')
            .doc(docId)
            .snapshots();

    _callStream!.listen((docSnapshot) {
      if (!docSnapshot.exists) return;

      final data = docSnapshot.data() as Map<String, dynamic>;
      final status = data['status'];

      if (status == 'answered' && !_navigated) {
        _navigated = true;

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder:
                (_) => Call(
                  callID: widget.roomCode,
                  phone: widget.phone,
                  type: widget.type,
                ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.green),
            const SizedBox(height: 20),
            const Text("⏳ Waiting for a doctor..."),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () async {
                _timeoutTimer?.cancel();

                if (_callDocId != null) {
                  await FirebaseFirestore.instance
                      .collection('call_sessions')
                      .doc(_callDocId)
                      .update({'status': 'cancelled'});
                }

                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              icon: const Icon(Icons.cancel),
              label: const Text("Cancel the call"),
            ),
          ],
        ),
      ),
    );
  }
}
