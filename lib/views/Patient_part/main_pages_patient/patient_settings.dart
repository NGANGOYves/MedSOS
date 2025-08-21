// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medsos/service/user_provider.dart';
import 'package:medsos/views/Patient_part/chat/hive/boxes.dart';
import 'package:medsos/views/Patient_part/chat/hive/settings.dart';
import 'package:medsos/views/Patient_part/chat/providers/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class PatientParameter extends StatefulWidget {
  const PatientParameter({super.key});

  @override
  State<PatientParameter> createState() => _PatientParameterState();
}

class _PatientParameterState extends State<PatientParameter> {
  String userName = '';
  String userEmail = '';
  String userPhotoUrl = '';

  void getUserData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<UserProvider>().user;

      if (user != null) {
        setState(() {
          userName = user.fullName;
          userEmail = user.email;
          userPhotoUrl = user.photoUrl ?? '';
        });
      }
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  bool messageNotifications = true;
  bool callNotifications = true;
  bool readReceipts = true;
  bool endToEndEncryption = true;
  double fontSize = 1.0;
  String chatBubbleStyle = 'Modern';
  String notificationSound = 'Chime';
  String dataRetention = '30 days';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      backgroundColor: const Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 4,
              shadowColor: Colors.green.withOpacity(0.2),
              child: Center(
                child: Column(
                  children: [
                    Hero(
                      tag: 'user-avatar',
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            (userPhotoUrl.isNotEmpty)
                                ? NetworkImage(userPhotoUrl)
                                : const AssetImage(
                                      'assets/images/default_avatar.png',
                                    )
                                    as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(userEmail, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        context.push('/edit-profile');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Edit Profile'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<Box<Settings>>(
              valueListenable: Boxes.getSettings().listenable(),
              builder: (context, box, _) {
                final settings = box.isNotEmpty ? box.getAt(0) : null;
                return _buildSectionCard(
                  title: 'Display Settings',
                  children: [
                    _buildSwitchTile(
                      'Dark Mode',
                      settings?.isDarkTheme ?? false,
                      (val) => context.read<SettingsProvider>().toggleDarkMode(
                        value: val,
                      ),
                    ),
                  ],
                );
              },
            ),

            _buildSectionCard(
              title: 'Notifications',
              children: [
                _buildSwitchTile(
                  'Message Notifications',
                  messageNotifications,
                  (val) => setState(() => messageNotifications = val),
                ),
              ],
            ),
            //
            _buildSectionCard(
              title: 'About',
              children: [
                _buildInfoTile('App Version', '1.0.0'),
                _buildNavigationTile('Terms & Privacy Policy'),
                _buildNavigationTile('Help & Support'),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text(
                            'Are you sure you want to logout?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                  );
                  if (confirmed ?? false) {
                    await context.read<UserProvider>().logout();
                    if (context.mounted) context.go('/login');
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Log Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String label, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.green,
      inactiveTrackColor: Colors.grey.shade300,
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildNavigationTile(String title) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        if (title.contains("Terms")) {
          Navigator.of(
            context,
            rootNavigator: true,
          ).push(MaterialPageRoute(builder: (context) => TermsPrivacyScreen()));
        } else if (title.contains("Help")) {
          Navigator.of(
            context,
            rootNavigator: true,
          ).push(MaterialPageRoute(builder: (context) => HelpSupportView()));
        }
      },
    );
  }
}

class TermsPrivacyScreen extends StatelessWidget {
  const TermsPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Privacy Policy'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Privacy Policy',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 8),
          const Text('Last updated: Friday, July 12, 2025'),
          const SizedBox(height: 16),
          _sectionTitle('1. Data Collection'),
          _bulletPoints([
            'Phone number (used for SMS authentication)',
            'Personal information (name, surname, address, etc.) during registration',
            'Communication data (messages with doctors or AI assistant)',
            'Transaction data (related to consultation payment)',
            'Technical data (device model, app version, login logs)',
          ]),
          _sectionTitle('2. Data Usage'),
          _bulletPoints([
            'To provide secure access to teleconsultation services',
            'To enable communication between patients and doctors',
            'To manage payments and consultations',
            'To improve app performance and user experience',
          ]),
          _sectionTitle('3. Data Sharing'),
          _bulletPoints([
            'With healthcare professionals you choose to consult',
            'If required by law or health regulation',
            'With Mobile Money operators (for secure payment processing)',
          ]),
          _sectionTitle('4. Data Security'),
          const Text(
            'We use encryption and secure databases (Firebase/Appwrite) to protect all your information. Only authorized users (admins and doctors) have strictly controlled access.',
          ),
          const SizedBox(height: 12),
          _sectionTitle('5. Data Retention'),
          const Text(
            'Your data is retained as long as necessary for service delivery and legal obligations. You can request to delete your account at any time.',
          ),
          const SizedBox(height: 12),
          _sectionTitle('6. User Rights'),
          _bulletPoints([
            'Access your personal data',
            'Modify or delete your information',
            'Request usage limitations',
            'Withdraw your consent at any time',
          ]),
          const SizedBox(height: 12),
          const Text(
            '⚠️ Important: Doctors are not required to respond to messages due to their limited availability. Thank you for understanding.',
            style: TextStyle(color: Colors.redAccent),
          ),
          const SizedBox(height: 24),
          const Text(
            'For any questions, please contact us via the Help & Support section of the app.',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 6),
    child: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        fontSize: 16,
      ),
    ),
  );

  Widget _bulletPoints(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          items
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text("• $e"),
                ),
              )
              .toList(),
    );
  }
}

class HelpSupportView extends StatelessWidget {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.green.shade800,
    );
    final sectionPadding = const EdgeInsets.symmetric(vertical: 12);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Need help using the app or experiencing an issue?",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),

            Text("📞 How to contact us", style: titleStyle),
            const SizedBox(height: 8),
            const Text("You can reach us through the following methods:"),
            const SizedBox(height: 4),
            const Text(
              "• In-app messaging: Tap “Contact Support” from this section.",
            ),
            const Text("• Email: support_medsos@gmail.com"),
            const Text("• Phone: +237 681 206 862 (Mon–Fri, 9:00AM – 5:00PM)"),
            const Text(
              "• WhatsApp: Chat with our assistant at +237 655 802 769",
            ),

            Padding(
              padding: sectionPadding,
              child: Text("🔧 Common Issues", style: titleStyle),
            ),
            const Text(
              "• Not receiving login SMS: Ensure your number is correct and you have network.",
            ),
            const Text(
              "• Payment failure: Make sure your Mobile Money account has sufficient funds or try another method.",
            ),
            const Text(
              "• No doctors available: Try again in a few minutes or contact support for manual assistance.",
            ),

            Padding(
              padding: sectionPadding,
              child: Text(
                "❓ Frequently Asked Questions (FAQ)",
                style: titleStyle,
              ),
            ),
            const Text("• Can I cancel a consultation?"),
            const Text(
              "  → Yes, as long as the doctor hasn’t answered the call.",
            ),
            const SizedBox(height: 8),
            const Text("• Will I be refunded if no doctor responds?"),
            const Text(
              "  → Yes. If no doctor responds within 5 minutes, your payment will be refunded automatically.",
            ),
            const SizedBox(height: 8),
            const Text("• Are doctors required to reply to messages?"),
            const Text(
              "  → No. Doctors are not obligated to respond to messages due to limited availability.",
            ),
          ],
        ),
      ),
    );
  }
}
