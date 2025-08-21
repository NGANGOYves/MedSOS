// // ignore_for_file: depend_on_referenced_packages

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:medsos/service/user_provider.dart';
// import 'package:provider/provider.dart';

// class SettingsScreenDoctor extends StatefulWidget {
//   const SettingsScreenDoctor({super.key});

//   @override
//   State<SettingsScreenDoctor> createState() => _SettingsScreenDoctorState();
// }

// class _SettingsScreenDoctorState extends State<SettingsScreenDoctor> {
//   bool darkMode = false;
//   bool callNotifications = true;
//   bool availabilityStatus = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4FDF7),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: BackButton(
//           color: Colors.green[700],
//           onPressed: () => context.go('/home-doctor'),
//         ),
//         title: const Text(
//           'Doctor Settings',
//           style: TextStyle(color: Colors.black87),
//         ),
//         centerTitle: false,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Profile section
//             Card(
//               color: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               elevation: 1,
//               child: ListTile(
//                 leading: const CircleAvatar(
//                   backgroundColor: Color(0xFFDFF0E3),
//                   child: Icon(Icons.person, color: Colors.green),
//                 ),
//                 title: const Text(
//                   'Dr. Alex Johnson',
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 subtitle: const Text('alex.johnson@medsos.cm'),
//                 trailing: TextButton(
//                   onPressed: () {}, // TODO: Implement Edit Profile
//                   child: const Text('Edit'),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Availability
//             _buildSectionCard(
//               title: 'Availability',
//               children: [
//                 _buildSwitchTile(
//                   'Show as Available',
//                   availabilityStatus,
//                   (val) => setState(() => availabilityStatus = val),
//                 ),
//               ],
//             ),

//             // Preferences
//             _buildSectionCard(
//               title: 'Preferences',
//               children: [
//                 _buildSwitchTile(
//                   'Dark Mode',
//                   darkMode,
//                   (val) => setState(() => darkMode = val),
//                 ),
//                 _buildSwitchTile(
//                   'Call Notifications',
//                   callNotifications,
//                   (val) => setState(() => callNotifications = val),
//                 ),
//               ],
//             ),

//             // Info & Help
//             _buildSectionCard(
//               title: 'App Information',
//               children: [
//                 _buildInfoTile('App Version', '2.4.1'),
//                 _buildNavigationTile('Help & Support'),
//                 _buildNavigationTile('Terms & Conditions'),
//               ],
//             ),

//             const SizedBox(height: 24),

//             // Logout Button
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   foregroundColor: Colors.red,
//                   minimumSize: const Size.fromHeight(50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(32),
//                   ),
//                 ),
//                 onPressed: () async {
//                   final confirmed = await showDialog<bool>(
//                     context: context,
//                     builder:
//                         (context) => AlertDialog(
//                           title: const Text('Logout'),
//                           content: const Text(
//                             'Are you sure you want to logout?',
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.pop(context, false),
//                               child: const Text('Cancel'),
//                             ),
//                             TextButton(
//                               onPressed: () => Navigator.pop(context, true),
//                               child: const Text('Logout'),
//                             ),
//                           ],
//                         ),
//                   );
//                   if (confirmed ?? false) {
//                     await context.read<UserProvider>().logout();
//                     if (context.mounted) context.go('/login');
//                   }
//                 },
//                 icon: const Icon(Icons.logout),
//                 label: const Text('Log Out'),
//               ),
//             ),
//             const SizedBox(height: 32),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionCard({
//     required String title,
//     required List<Widget> children,
//   }) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       color: Colors.white,
//       elevation: 1,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green,
//               ),
//             ),
//             const SizedBox(height: 8),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSwitchTile(String label, bool value, Function(bool) onChanged) {
//     return SwitchListTile(
//       contentPadding: const EdgeInsets.symmetric(horizontal: 8),
//       title: Text(label),
//       value: value,
//       onChanged: onChanged,
//       activeColor: Colors.green,
//     );
//   }

//   Widget _buildInfoTile(String title, String value) {
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(horizontal: 8),
//       title: Text(title),
//       trailing: Text(
//         value,
//         style: const TextStyle(fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   Widget _buildNavigationTile(String title) {
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(horizontal: 8),
//       title: Text(title),
//       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//       onTap: () {}, // TODO: Implement navigation
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medsos/service/user_provider.dart';
import 'package:medsos/widgets/backwrapper.dart';
import 'package:medsos/widgets/terms_support.dart';
import 'package:provider/provider.dart';

class SettingsScreenDoctor extends StatefulWidget {
  const SettingsScreenDoctor({super.key});

  @override
  State<SettingsScreenDoctor> createState() => _SettingsScreenDoctorState();
}

class _SettingsScreenDoctorState extends State<SettingsScreenDoctor> {
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
    super.initState();
    getUserData();
  }

  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return BackRedirectWrapper(
      targetRoute: '/home-doctor',
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Settings',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.green),
          centerTitle: true,
        ),
        backgroundColor: const Color(0xFFF6F6F6),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// Profile Card
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
                              userPhotoUrl.isNotEmpty
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
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          context.push('/edit-profile-doctor');
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

              /// Display Settings
              _buildSectionCard(
                title: 'Display Settings',
                children: [
                  SwitchListTile(
                    title: const Text('Notifications'),
                    value: isDarkMode,
                    onChanged: (val) => setState(() => isDarkMode = val),
                    activeColor: Colors.green,
                  ),
                ],
              ),

              /// About Section
              _buildSectionCard(
                title: 'About',
                children: [
                  _buildInfoTile('App Version', '1.0.0'),
                  _buildNavigationTile('Help & Support'),
                ],
              ),

              /// Logout Button
              const SizedBox(height: 24),
              ElevatedButton.icon(
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
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// UI Helpers
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
      onTap:
          () => Navigator.of(
            context,
            rootNavigator: true,
          ).push(MaterialPageRoute(builder: (_) => HelpSupportPage())),
    );
  }
}
