// // ignore_for_file: depend_on_referenced_packages, file_names

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:medsos/views/messagerie/chat_page.dart';
// import 'package:provider/provider.dart';

// import 'package:medsos/service/user_provider.dart';

// class DoctorActivityPage extends StatefulWidget {
//   const DoctorActivityPage({super.key});

//   @override
//   State<DoctorActivityPage> createState() => _DoctorActivityPageState();
// }

// class _DoctorActivityPageState extends State<DoctorActivityPage>
//     with TickerProviderStateMixin {
//   @override
//   Widget build(BuildContext context) {
//     final userProvider = context.read<UserProvider>();
//     final currentUserId = userProvider.user?.fullName ?? '';

//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F8FF),
//       appBar: AppBar(
//         title: const Text("Doctor Activity"),
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,
//       ),
//       body: Column(
//         children: [
//           // Section Chats Firestore uniquement
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
//             child: Row(
//               children: const [
//                 Icon(Icons.chat_bubble, color: Colors.green),
//                 SizedBox(width: 8),
//                 Text(
//                   "Vos Conversations",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(child: ChatListWidget(currentUserId: currentUserId)),

//           // Divider + Call History (inchangés)
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Divider(
//                     color: Colors.green.shade200,
//                     thickness: 1.2,
//                     endIndent: 12,
//                     indent: 16,
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 14,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.green.shade100,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.green.shade100,
//                         blurRadius: 10,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: const Text(
//                     "Call History",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Divider(
//                     color: Colors.green.shade200,
//                     thickness: 1.2,
//                     indent: 12,
//                     endIndent: 16,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Section Saved Calls (inchangée)
//           Expanded(
//             child: ClipRRect(
//               borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(16),
//               ),
//               child: Container(
//                 color: Colors.white,
//                 padding: const EdgeInsets.only(top: 4),
//                 // child: Savedcall(username:
//                 //      userProvider.user!.fullName,
//                 // ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// Widget ChatList extrait de ta `ChatListPage`, adapté pour ne pas utiliser Scaffold
// class ChatListWidget extends StatelessWidget {
//   final String currentUserId;

//   const ChatListWidget({super.key, required this.currentUserId});

//   Future<Map<String, dynamic>?> getUserByName(String fullName) async {
//     final snap =
//         await FirebaseFirestore.instance
//             .collection('users')
//             .where('fullName', isEqualTo: fullName)
//             .limit(1)
//             .get();

//     if (snap.docs.isEmpty) return null;
//     return snap.docs.first.data();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream:
//           FirebaseFirestore.instance
//               .collection('chats')
//               .where('participants', arrayContains: currentUserId)
//               .orderBy('lastTimestamp', descending: true)
//               .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData)
//           return const Center(child: CircularProgressIndicator());

//         final chats = snapshot.data!.docs;

//         if (chats.isEmpty)
//           return const Center(child: Text("Aucune conversation"));

//         return ListView.builder(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           itemCount: chats.length,
//           itemBuilder: (context, index) {
//             final chat = chats[index];
//             final participants = List<String>.from(chat['participants']);
//             final peerName = participants.firstWhere(
//               (id) => id != currentUserId,
//             );
//             final lastMessage = chat['lastMessage'] ?? '';
//             final lastTime = chat['lastTimestamp'];
//             final displayTime =
//                 lastTime != null
//                     ? DateFormat.Hm().format(DateTime.parse(lastTime))
//                     : '';

//             return FutureBuilder<Map<String, dynamic>?>(
//               future: getUserByName(peerName),
//               builder: (context, userSnapshot) {
//                 final userData = userSnapshot.data;
//                 final avatarUrl = userData?['photoUrl'];
//                 final displayName = userData?['fullName'] ?? peerName;

//                 return ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: Colors.green,
//                     backgroundImage:
//                         avatarUrl != null ? NetworkImage(avatarUrl) : null,
//                     child:
//                         avatarUrl == null
//                             ? const Icon(Icons.person, color: Colors.white)
//                             : null,
//                   ),
//                   title: Text(displayName),
//                   subtitle: Text(
//                     lastMessage,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   trailing: Text(
//                     displayTime,
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder:
//                             (_) => ChatPage(
//                               currentUserId: currentUserId,
//                               peerId: peerName,
//                               peerName: displayName,
//                             ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }

// /// Message item structure (inchangé)
// class MessageItem {
//   final String name;
//   final String message;
//   final String time;
//   final String imageUrl;
//   final bool unread;

//   MessageItem({
//     required this.name,
//     required this.message,
//     required this.time,
//     required this.imageUrl,
//     this.unread = false,
//   });
// }

// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:medsos/views/Doctor_part/main_page_doctor/profile/callhistory.dart';
import 'package:medsos/views/messagerie/chat_list_d.dart';
import 'package:provider/provider.dart';
import 'package:medsos/service/user_provider.dart';

class DoctorActivityPage extends StatelessWidget {
  const DoctorActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final currentUserId = userProvider.user?.fullName ?? '';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F8FF),
        appBar: AppBar(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          title: const Text("Doctor Activity"),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [Tab(text: "Messages"), Tab(text: "Call History")],
          ),
        ),
        body: TabBarView(
          children: [
            ChatListPageDoc(currentUserId: currentUserId),
            callHistory(username: userProvider.user!.fullName),
          ],
        ),
      ),
    );
  }
}
