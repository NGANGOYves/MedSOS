import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../widgets/bottom_chat_field.dart';
import '../widgets/chat_messages.dart';

class DoctorChatScreen extends StatefulWidget {
  const DoctorChatScreen({super.key});

  @override
  State<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController textController = TextEditingController();
  final FocusNode textFieldFocus = FocusNode();

  final List<String> _starterMessages = [
    "👋 Hello, Doctor",
    "I need medical advice",
    "How does this work?",
    "Can we schedule a call?",
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    textController.dispose();
    textFieldFocus.dispose();
    super.dispose();
  }

  // Future<void> sendChatMessage({
  //   required String message,
  //   required ChatProvider chatProvider,
  //   required bool isTextOnly,
  // }) async {
  //   try {
  //     await chatProvider.sentMessage(message: message, isTextOnly: isTextOnly);
  //   } catch (e) {
  //     debugPrint('error : $e');
  //   } finally {
  //     textController.clear();
  //     widget.chatProvider.setImagesFileList(listValue: []);
  //     textFieldFocus.unfocus();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dr. Anonymous",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Online",
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
            actions: const [
              Icon(Icons.phone, color: Colors.black),
              SizedBox(width: 10),
              Icon(Icons.video_call, color: Colors.black),
              SizedBox(width: 10),
              Icon(Icons.more_vert, color: Colors.black),
              SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child:
                      chatProvider.inChatMessages.isEmpty
                          ? _buildStartConsultation()
                          : ChatMessages(
                            scrollController: _scrollController,
                            chatProvider: chatProvider,
                          ),
                ),
                BottomChatField(chatProvider: chatProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStartConsultation() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(
            Icons.chat_bubble_outline,
            size: 60,
            color: Colors.grey,
          ), // Placeholder icon
          const SizedBox(height: 20),
          const Text(
            "Start Your Consultation",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Send a message to begin your secure chat with Dr. Anonymous. All communications are private and protected.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children:
                _starterMessages.map((label) {
                  return ActionChip(
                    label: Text(label),
                    backgroundColor: const Color(0xFFF1F8E9),
                    labelStyle: const TextStyle(color: Colors.black87),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () {
                      // final provider =
                      //     Provider.of<ChatProvider>(context, listen: false);
                      // sendChatMessage(
                      //   message: label,
                      //   chatProvider: provider,
                      //   isTextOnly: true,
                      // );
                    },
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
