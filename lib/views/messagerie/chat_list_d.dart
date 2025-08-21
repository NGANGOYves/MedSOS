import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medsos/widgets/backwrapper.dart';
import 'chat_page.dart';

class ChatListPageDoc extends StatelessWidget {
  final String currentUserId;

  const ChatListPageDoc({super.key, required this.currentUserId});

  Future<Map<String, dynamic>?> getUserByName(String fullName) async {
    final snap =
        await FirebaseFirestore.instance
            .collection('user')
            .where('fullName', isEqualTo: fullName)
            .limit(1)
            .get();

    if (snap.docs.isEmpty) return null;
    return snap.docs.first.data();
  }

  @override
  Widget build(BuildContext context) {
    return BackRedirectWrapper(
      targetRoute: '/home-doctor',
      child: Scaffold(
        // appBar: AppBar(title: const Text(""), backgroundColor: Colors.green),
        body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('chats')
                  .where('participants', arrayContains: currentUserId)
                  .orderBy('lastTimestamp', descending: true)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final chats = snapshot.data!.docs;

            if (chats.isEmpty) {
              return const Center(child: Text("Aucune conversation"));
            }

            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                final participants = List<String>.from(chat['participants']);
                final peerId = participants.firstWhere(
                  (id) => id != currentUserId,
                );
                final lastMessage = chat['lastMessage'] ?? '';
                final lastTime = chat['lastTimestamp'];
                final displayTime =
                    lastTime != null
                        ? DateFormat.Hm().format(DateTime.parse(lastTime))
                        : '';

                return FutureBuilder<Map<String, dynamic>?>(
                  future: getUserByName(peerId),
                  builder: (context, userSnapshot) {
                    final userData = userSnapshot.data;
                    final avatarUrl = userData?['photoUrl'];
                    final displayName = userData?['fullName'] ?? peerId;

                    return StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('chats')
                              .doc(chat.id)
                              .collection('messages')
                              .where('read', isEqualTo: false)
                              .where('senderId', isEqualTo: peerId)
                              .snapshots(),
                      builder: (context, unreadSnapshot) {
                        final unreadCount =
                            unreadSnapshot.hasData
                                ? unreadSnapshot.data!.docs.length
                                : 0;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green,
                            backgroundImage:
                                avatarUrl != null
                                    ? NetworkImage(avatarUrl)
                                    : null,
                            child:
                                avatarUrl == null
                                    ? const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    )
                                    : null,
                          ),
                          title: Text(displayName),
                          subtitle: Text(
                            lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                displayTime,
                                style: const TextStyle(fontSize: 12),
                              ),
                              if (unreadCount > 0) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    unreadCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ChatPage(
                                      currentUserId: currentUserId,
                                      peerId: peerId,
                                      peerName: displayName,
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
