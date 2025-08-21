import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medsos/widgets/backwrapper.dart';

class EmergencyHelpInfoScreen extends StatelessWidget {
  const EmergencyHelpInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackRedirectWrapper(
      targetRoute: '/emergency',
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: const Text('Emergency Help Guide'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Section 1: Call a Doctor
              const Text(
                'Call a Doctor Instantly',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(child: _imageBox('assets/images/call1.png')),
                  const SizedBox(width: 10),
                  Expanded(child: _imageBox('assets/images/call2.png')),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Need immediate help? After subscribing, you unlock access to a full month of unlimited medical support. '
                'Just tap and hold the red emergency button to instantly connect with a licensed doctor via live audio or video call. '
                'It’s fast, secure, and available whenever you need expert advice or urgent care.',
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),

              const SizedBox(height: 30),
              const Divider(color: Colors.green),
              const SizedBox(height: 15),
              // 🔹 Section 2: First Aid
              const Text(
                'Learn First Aid',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(child: _imageBox('assets/images/aid1.png')),
                  const SizedBox(width: 10),
                  Expanded(child: _imageBox('assets/images/aid2.png')),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Before help arrives, basic first aid can be life-saving. Tap the “Access First Aid” button to view essential steps '
                'for treating injuries, bleeding, fainting, and more. With clear illustrations and tips, you’ll be ready for any situation.',
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),

              const SizedBox(height: 30),

              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.go('/emergency');
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Go Back"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 📦 Helper to build an image with rounded borders
  Widget _imageBox(String assetPath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.asset(assetPath, height: 150, fit: BoxFit.cover),
    );
  }
}
