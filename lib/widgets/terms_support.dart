import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medsos/widgets/backwrapper.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackRedirectWrapper(
      targetRoute: '/setting-doctor',
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back),
          ),
          title: const Text('Help & Support'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle('🔐 Privacy Policy'),
              sectionCard([
                sectionText('Last updated: Friday, July 12, 2025'),
                sectionSubtitle('1. Data Collection'),
                bulletText('Phone number (used for SMS authentication)'),
                bulletText(
                  'Personal info (name, surname, address, etc.) during registration',
                ),
                bulletText('Messages with doctors or AI assistant'),
                bulletText('Transaction data (consultation fees)'),
                bulletText('Technical data (device model, app version, logs)'),

                sectionSubtitle('2. Data Usage'),
                bulletText('Secure access to teleconsultation services'),
                bulletText('Communication between patients and doctors'),
                bulletText('Manage payments and consultations'),
                bulletText('Improve app performance'),

                sectionSubtitle('3. Data Sharing'),
                bulletText('With doctors you consult'),
                bulletText('If required by law or health authority'),
                bulletText('With Mobile Money operators for payments'),

                sectionSubtitle('4. Data Security'),
                sectionText(
                  'We use encryption and secure databases (Firebase/Appwrite). '
                  'Only authorized users (admins and doctors) have access.',
                ),

                sectionSubtitle('5. Data Retention'),
                sectionText(
                  'Your data is kept as long as needed for service delivery and legal compliance. '
                  'You can request deletion anytime.',
                ),

                sectionSubtitle('6. Your Rights'),
                bulletText('Access your personal data'),
                bulletText('Modify or delete your information'),
                bulletText('Request usage limits'),
                bulletText('Withdraw consent'),
              ]),

              const SizedBox(height: 24),
              sectionTitle('🛠 Help & Support'),
              sectionCard([
                sectionText(
                  'Need help using the app or facing an issue? We’re here to support you.',
                ),
                sectionSubtitle('How to Contact Us'),
                bulletText(
                  '• In-app Messaging: Tap "Contact Support" in this section',
                ),
                bulletText('• Email: support_medsos@gmail.com'),
                bulletText('• Phone: +237 681 206 862 (Mon–Fri, 9AM–5PM)'),
                bulletText(
                  '• WhatsApp: +237 655 802 769 (chat with our assistant)',
                ),
              ]),

              const SizedBox(height: 24),
              sectionTitle('⚠️ Common Issues'),
              sectionCard([
                bulletText(
                  '• SMS not received: Ensure your number is correct and you have signal.',
                ),
                bulletText(
                  '• Payment failed: Make sure your Mobile Money account has funds or try another method.',
                ),
                bulletText(
                  '• No doctor available: Try again in a few minutes or contact support.',
                ),
              ]),

              const SizedBox(height: 24),
              sectionTitle('❓ Frequently Asked Questions (FAQ)'),
              sectionCard([
                bulletText(
                  '• Can I cancel a consultation? Yes, as long as the doctor hasn’t answered.',
                ),
                bulletText(
                  '• Refund if no doctor answers? Yes, you’ll be automatically refunded after 5 minutes.',
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget sectionSubtitle(String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(
        subtitle,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget sectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  Widget bulletText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  Widget sectionCard(List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
