// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// class Call extends StatelessWidget {
//   final String callID;
//   final String? phone; // ✅ Optionnel maintenant
//   final String type; // 👈 add this

//   const Call({super.key, required this.callID, this.phone, required this.type});

//   @override
//   Widget build(BuildContext context) {
//     final userId =
//         phone ?? 'anonymous_${DateTime.now().millisecondsSinceEpoch}';

//     // 👇 Choose config based on type
//     final callConfig =
//         type == "voice"
//             ? ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
//             : ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall();

//     return ZegoUIKitPrebuiltCall(
//       appID: 161301344,
//       appSign:
//           'd08ec3526554dbc6a6d064ec267f6ad95fe0f67a812fdb16bec528a0e1215e12',
//       userID: userId,
//       userName: 'user $userId',
//       callID: callID,
//       config: callConfig, // 👈 dynamic config
//       events: ZegoUIKitPrebuiltCallEvents(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medsos/views/Patient_part/call/CallMeet/CallRatingDialog.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:provider/provider.dart';
import 'package:medsos/service/user_provider.dart';

class Call extends StatelessWidget {
  final String callID;
  final String? phone;
  final String type;

  const Call({super.key, required this.callID, this.phone, required this.type});

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;
    final userId =
        phone ?? 'anonymous_${DateTime.now().millisecondsSinceEpoch}';

    final callConfig =
        ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          ..turnOnCameraWhenJoining = false;
    // 👈 allows toggling video later

    return ZegoUIKitPrebuiltCall(
      appID: 161301344,
      appSign:
          'd08ec3526554dbc6a6d064ec267f6ad95fe0f67a812fdb16bec528a0e1215e12',
      userID: userId,
      userName: 'user $userId',
      callID: callID,
      config: callConfig,
      events: ZegoUIKitPrebuiltCallEvents(
        onCallEnd: (event, defaultAction) async {
          if (user?.role == 'patient') {
            try {
              final snapshot =
                  await FirebaseFirestore.instance
                      .collection('call_sessions')
                      .doc(callID)
                      .get();

              final data = snapshot.data();
              final doctorName = data?['calleeName'] ?? 'Docteur';

              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => CallRatingPage(
                          doctorName: doctorName,
                          callId: callID,
                        ),
                  ),
                );
              }
            } catch (e) {
              print("Error fetching doctor name: $e");
            }
          } else {
            // Doctor: Just pop or go to home
            if (context.mounted) {
              Navigator.pop(context); // or use context.go('/doctor-home');
            }
          }
        },
      ),
    );
  }
}
