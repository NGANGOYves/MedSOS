import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:medsos/service/user_provider.dart';

class CallRatingPage extends StatefulWidget {
  final String doctorName;
  final String callId;

  const CallRatingPage({
    super.key,
    required this.doctorName,
    required this.callId,
  });

  @override
  State<CallRatingPage> createState() => _CallRatingPageState();
}

class _CallRatingPageState extends State<CallRatingPage> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    if (_rating == 0) return;

    setState(() => _loading = true);

    final user = context.read<UserProvider>().user!;
    final now = DateTime.now();

    await FirebaseFirestore.instance.collection('call_feedback').add({
      'patient': user.fullName,
      'patientPhone': user.phone,
      'doctorName': widget.doctorName,
      'callId': widget.callId,
      'rating': _rating,
      'comment': _commentController.text.trim(),
      'timestamp': now.toIso8601String(),
    });

    setState(() => _loading = false);

    if (!mounted) return;
    context.go('/home-patient');
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Noter la consultation"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Icon(Icons.star_rate, color: Colors.green, size: 80),
                const SizedBox(height: 12),
                const Text(
                  "Comment évalueriez-vous votre consultation avec le docteur ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Wrap(
                    spacing: 8,
                    children: List.generate(5, (index) {
                      final starIndex = index + 1;
                      return GestureDetector(
                        onTap:
                            () =>
                                setState(() => _rating = starIndex.toDouble()),
                        child: Icon(
                          _rating >= starIndex ? Icons.star : Icons.star_border,
                          size: 40,
                          color: Colors.amber,
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Commentaire (optionnel)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _commentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Ajoutez un commentaire ici...",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _rating > 0 && !_loading ? _submit : null,
                    icon: const Icon(Icons.send),
                    label: const Text("Envoyer l’évaluation"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
          if (_loading)
            Container(
              width: size.width,
              height: size.height,
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
