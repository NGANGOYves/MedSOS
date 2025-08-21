// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatPage extends StatefulWidget {
  final String currentUserId;
  final String peerId;
  final String peerName;

  const ChatPage({
    super.key,
    required this.currentUserId,
    required this.peerId,
    required this.peerName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  String get chatId {
    final ids = [widget.currentUserId, widget.peerId]..sort();
    return ids.join("_");
  }

  @override
  void initState() {
    super.initState();
    _markMessagesAsRead();
  }

  // ✅ Marquer les messages comme lus
  void _markMessagesAsRead() async {
    final chatRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages');

    final unreadMessages =
        await chatRef
            .where('senderId', isEqualTo: widget.peerId)
            .where('read', isEqualTo: false)
            .get();

    for (var doc in unreadMessages.docs) {
      await doc.reference.update({'read': true});
    }
  }

  // ✅ Envoi d'une image
  Future<void> _sendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final File imageFile = File(pickedFile.path);
    final fileName = basename(pickedFile.path);

    final ref = FirebaseStorage.instance
        .ref()
        .child('chat_images')
        .child(chatId)
        .child(fileName);

    await ref.putFile(imageFile);
    final imageUrl = await ref.getDownloadURL();

    final message = {
      'text': '',
      'imageUrl': imageUrl,
      'senderId': widget.currentUserId,
      'timestamp': DateTime.now().toIso8601String(),
      'read': false,
    };

    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    await chatRef.collection('messages').add(message);

    await chatRef.set({
      'participants': [widget.currentUserId, widget.peerId],
      'lastMessage': '[Image]',
      'lastTimestamp': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  // ✅ Envoi d’un message texte
  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();

    final message = {
      'text': text,
      'senderId': widget.currentUserId,
      'timestamp': DateTime.now().toIso8601String(),
      'read': false,
    };

    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    await chatRef.collection('messages').add(message);

    await chatRef.set({
      'participants': [widget.currentUserId, widget.peerId],
      'lastMessage': text,
      'lastTimestamp': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  // ✅ Construction UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.peerName),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [Expanded(child: _buildMessages()), _buildMessageInput()],
      ),
    );
  }

  // ✅ Affichage des messages
  Widget _buildMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .orderBy('timestamp', descending: false)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            final data = msg.data() as Map<String, dynamic>;
            final isMe = data['senderId'] == widget.currentUserId;
            final time = DateFormat.Hm().format(
              DateTime.parse(data['timestamp']),
            );

            final hasImage =
                data.containsKey('imageUrl') &&
                data['imageUrl'] != null &&
                data['imageUrl'].toString().isNotEmpty;

            return Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                decoration: BoxDecoration(
                  color: isMe ? Colors.green.shade200 : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft:
                        isMe
                            ? const Radius.circular(16)
                            : const Radius.circular(0),
                    bottomRight:
                        isMe
                            ? const Radius.circular(0)
                            : const Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    hasImage
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            data['imageUrl'],
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                        : Text(
                          data['text'],
                          style: const TextStyle(fontSize: 16),
                        ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          Icon(
                            data['read'] == true ? Icons.done_all : Icons.done,
                            size: 16,
                            color:
                                data['read'] == true
                                    ? Colors.blue
                                    : Colors.grey,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ✅ Barre d’envoi de message
  Widget _buildMessageInput() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.image, color: Colors.grey),
              onPressed: _sendImage,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: Colors.green,
              radius: 24,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
