import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SavedCall extends StatelessWidget {
  final String username;

  const SavedCall({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('call_sessions')
        .where(
          Filter.or(
            Filter('caller', isEqualTo: username),
            Filter('calleeName', isEqualTo: username),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Call History'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No calls found."));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final caller = data['caller'] ?? 'Unknown';
              final callee = data['calleeName'] ?? 'Not answered';
              final status = data['status'] ?? 'Unknown';
              final type = data['type'] ?? 'video';
              final createdAtStr = data['createdAt'] ?? '';
              final amount = type == 'voice' ? 1000 : 1500;

              DateTime? date;
              try {
                date = DateTime.parse(createdAtStr);
              } catch (_) {}

              final icon = type == 'voice' ? Icons.call : Icons.videocam;
              final isAnswered = status == 'answered';

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            icon,
                            color: isAnswered ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            type == 'voice' ? "Voice Call" : "Video Call",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isAnswered
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isAnswered ? "Answered" : "Missed",
                              style: TextStyle(
                                color: isAnswered ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text("Caller: $caller"),
                      Text("Callee: Dr. $callee"),
                      const SizedBox(height: 8),
                      Text(
                        "Amount: ${amount.toString()} FCFA",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (date != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          "Date: ${DateFormat('dd MMM yyyy – HH:mm').format(date)}",
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
