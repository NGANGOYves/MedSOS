// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// // ignore: depend_on_referenced_packages
// import 'package:provider/provider.dart';
// import '../providers/chat_provider.dart';
// import '../widgets/bottom_chat_field.dart';
// import '../widgets/chat_messages.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients &&
//           _scrollController.position.maxScrollExtent > 0.0) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ChatProvider>(
//       builder: (context, chatProvider, child) {
//         if (chatProvider.inChatMessages.isNotEmpty) {
//           _scrollToBottom();
//         }

//         chatProvider.addListener(() {
//           if (chatProvider.inChatMessages.isNotEmpty) {
//             _scrollToBottom();
//           }
//         });

//         return Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.white,
//             elevation: 0,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.black),
//               onPressed: () => context.go('/home'),
//             ),
//             title: Row(
//               children: [
//                 const CircleAvatar(
//                   backgroundColor: Color(0xFFE8F5E9),
//                   child: Icon(Icons.smart_toy, color: Colors.green),
//                 ),
//                 const SizedBox(width: 10),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text(
//                       'MedSOS Assistant',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'Always available',
//                       style: TextStyle(color: Colors.grey, fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           body: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   Expanded(
//                     child:
//                         chatProvider.inChatMessages.isEmpty
//                             ? _buildWelcomeScreen(context)
//                             : ChatMessages(
//                               scrollController: _scrollController,
//                               chatProvider: chatProvider,
//                             ),
//                   ),
//                   BottomChatField(chatProvider: chatProvider),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildWelcomeScreen(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           const SizedBox(height: 40),
//           const CircleAvatar(
//             radius: 40,
//             backgroundColor: Color(0xFFE8F5E9),
//             child: Icon(Icons.smart_toy, color: Colors.green, size: 40),
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'Your AI Health Assistant',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             child: Text(
//               "I'm here to answer your health questions, provide medical information, and help you navigate your healthcare journey. What can I help you with today?",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 14),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Wrap(
//             spacing: 10,
//             runSpacing: 10,
//             alignment: WrapAlignment.center,
//             children: const [
//               _InfoChip(label: "Medication information"),
//               _InfoChip(label: "Symptom assessment"),
//               _InfoChip(label: "Health tips"),
//               _InfoChip(label: "Medical terminology"),
//             ],
//           ),
//           const SizedBox(height: 30),
//           Container(
//             padding: const EdgeInsets.all(12),
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             decoration: BoxDecoration(
//               color: Colors.yellow[100],
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Text(
//               "This AI assistant provides general information only and is not a substitute for professional medical advice.",
//               style: TextStyle(fontSize: 12),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _InfoChip extends StatelessWidget {
//   final String label;
//   const _InfoChip({required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Chip(
//       label: Text(label),
//       backgroundColor: const Color(0xFFF1F8E9),
//       labelStyle: const TextStyle(color: Colors.black87),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../hive/boxes.dart';
import '../hive/chat_history.dart';
import '../providers/chat_provider.dart';
import '../widgets/bottom_chat_field.dart';
import '../widgets/chat_messages.dart';
import '../widgets/chat_history_widget.dart';
import '../widgets/empty_history_widget.dart';

class ChatScreen extends StatefulWidget {
  final String? initialText;
  const ChatScreen({super.key, this.initialText});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent > 0.0) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildWelcomeScreen(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          const CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xFFE8F5E9),
            child: Icon(Icons.smart_toy, color: Colors.green, size: 40),
          ),
          const SizedBox(height: 20),
          const Text(
            'Your MEDSOS Health Assistant',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              "I'm here to answer your health questions, provide medical information, and help you navigate your healthcare journey. What can I help you with today?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: const [
              _InfoChip(label: "Medication information"),
              _InfoChip(label: "Symptom assessment"),
              _InfoChip(label: "Health tips"),
              _InfoChip(label: "Medical terminology"),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.yellow[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "This AI assistant provides general information only and is not a substitute for professional medical advice.",
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        if (chatProvider.inChatMessages.isNotEmpty) {
          _scrollToBottom();
        }

        return Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            width: 300,
            backgroundColor: const Color(0xFFF9FBE7),
            child: SafeArea(
              child: ValueListenableBuilder<Box<ChatHistory>>(
                valueListenable: Boxes.getChatHistory().listenable(),
                builder: (context, box, _) {
                  final chatHistory =
                      box.values.toList().cast<ChatHistory>().reversed.toList();
                  return chatHistory.isEmpty
                      ? const EmptyHistoryWidget()
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: chatHistory.length,
                        itemBuilder: (context, index) {
                          final chat = chatHistory[index];
                          return GestureDetector(
                            onTap: () {
                              chatProvider.loadMessagesFromDB(
                                chatId: chat.chatId,
                              );
                              Navigator.pop(context); // close drawer
                            },
                            onLongPress: () async {
                              await Boxes.getChatHistory().delete(chat.key);
                            },
                            child: ChatHistoryWidget(chat: chat),
                          );
                        },
                      );
                },
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            title: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFE8F5E9),
                  child: Icon(Icons.smart_toy, color: Colors.green),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'MedSOS Assistant',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Always available',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child:
                        chatProvider.inChatMessages.isEmpty
                            ? _buildWelcomeScreen(context)
                            : ChatMessages(
                              scrollController: _scrollController,
                              chatProvider: chatProvider,
                            ),
                  ),
                  BottomChatField(
                    chatProvider: chatProvider,
                    initialText: widget.initialText,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: const Color(0xFFF1F8E9),
      labelStyle: const TextStyle(color: Colors.black87),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
