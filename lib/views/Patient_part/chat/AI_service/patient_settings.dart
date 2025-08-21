// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medsos/service/user_provider.dart';
import 'package:medsos/views/Patient_part/chat/hive/boxes.dart';
import 'package:medsos/views/Patient_part/chat/hive/settings.dart';
import 'package:medsos/views/Patient_part/chat/providers/settings_provider.dart';
import 'package:medsos/views/Patient_part/chat/widgets/build_display_image.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class PatientSettings extends StatefulWidget {
  const PatientSettings({super.key});

  @override
  State<PatientSettings> createState() => _PatientSettingsState();
}

class _PatientSettingsState extends State<PatientSettings> {
  File? file;
  String userImage = '';
  String userName = 'User';
  final ImagePicker _picker = ImagePicker();

  bool darkMode = false;
  bool messageNotifications = true;
  bool callNotifications = true;
  bool readReceipts = true;
  bool endToEndEncryption = true;
  double fontSize = 1.0;
  String chatBubbleStyle = 'Modern';
  String notificationSound = 'Chime';
  String dataRetention = '30 days';

  void pickImage() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 90,
      );
      if (picked != null) {
        setState(() => file = File(picked.path));
      }
    } catch (e) {
      log('Image Pick Error: $e');
    }
  }

  void getUserData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userBox = Boxes.getUser();
      if (userBox.isNotEmpty) {
        final user = userBox.getAt(0);
        setState(() {
          userImage = user!.name;
          userName = user.image;
        });
      }
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

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
                      child: BuildDisplayImage(
                        file: file,
                        userImage: userImage,
                        onPressed: pickImage,
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
                    const Text(
                      'alex.johnson@example.com',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {},
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
                  title: 'Smart Settings',
                  children: [
                    _buildSwitchTile(
                      'Enable AI Voice',
                      settings?.shouldSpeak ?? false,
                      (val) => context.read<SettingsProvider>().toggleSpeak(
                        value: val,
                      ),
                    ),
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
              title: 'Chat Preferences',
              children: [
                _buildDropdownTile(
                  'Chat Bubble Style',
                  chatBubbleStyle,
                  ['Modern', 'Classic', 'Rounded'],
                  (val) => setState(() => chatBubbleStyle = val),
                ),
                _buildSliderTile('Font Size', fontSize, [
                  'Small',
                  'Medium',
                  'Large',
                ], (val) => setState(() => fontSize = val)),
              ],
            ),
            _buildSectionCard(
              title: 'Notifications',
              children: [
                _buildSwitchTile(
                  'Message Notifications',
                  messageNotifications,
                  (val) => setState(() => messageNotifications = val),
                ),
                _buildSwitchTile(
                  'Call Notifications',
                  callNotifications,
                  (val) => setState(() => callNotifications = val),
                ),
                _buildDropdownTile(
                  'Notification Sound',
                  notificationSound,
                  ['Chime', 'Ding', 'Buzz'],
                  (val) => setState(() => notificationSound = val),
                ),
              ],
            ),
            _buildSectionCard(
              title: 'Privacy & Security',
              children: [
                _buildSwitchTile(
                  'Read Receipts',
                  readReceipts,
                  (val) => setState(() => readReceipts = val),
                ),
                _buildSwitchTile(
                  'End-to-End Encryption',
                  endToEndEncryption,
                  (val) => setState(() => endToEndEncryption = val),
                ),
                _buildDropdownTile(
                  'Data Retention',
                  dataRetention,
                  ['7 days', '30 days', '90 days'],
                  (val) => setState(() => dataRetention = val),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Clear Chat History'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFEEEE),
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _buildSectionCard(
              title: 'About',
              children: [
                _buildInfoTile('App Version', '2.4.1'),
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

  Widget _buildDropdownTile(
    String label,
    String currentValue,
    List<String> options,
    Function(String) onChanged,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(label),
      trailing: DropdownButton<String>(
        value: currentValue,
        onChanged:
            (String? newValue) => newValue != null ? onChanged(newValue) : null,
        items:
            options
                .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                .toList(),
      ),
    );
  }

  Widget _buildSliderTile(
    String label,
    double value,
    List<String> labels,
    Function(double) onChanged,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(label),
      subtitle: Slider(
        value: value,
        onChanged: onChanged,
        min: 0.0,
        max: 2.0,
        divisions: 2,
        label: labels[value.toInt()],
        activeColor: Colors.green,
      ),
      trailing: Text(
        labels[value.toInt()],
        style: const TextStyle(color: Colors.green),
      ),
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
      onTap: () {},
    );
  }
}
