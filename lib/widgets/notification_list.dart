import 'package:flutter/material.dart';
import 'package:medsos/widgets/backwrapper.dart';

class NotificationList extends StatelessWidget {
  final String type;

  const NotificationList({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> sampleNotifications = [
      {
        'title': 'New Appointment Scheduled',
        'subtitle': 'You have an appointment with Dr. Sarah tomorrow at 10 AM',
        'type': 'Appointments',
      },
      {
        'title': 'Message from Dr. Emily',
        'subtitle': 'Please check your latest test result.',
        'type': 'Messages',
      },
      {
        'title': 'Lab Results Ready',
        'subtitle': 'Your lab results are now available.',
        'type': 'All',
      },
    ];

    final filtered =
        type == 'All'
            ? sampleNotifications
            : sampleNotifications.where((n) => n['type'] == type).toList();

    return BackRedirectWrapper(
      targetRoute: '/home-patient',
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final notif = filtered[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.notifications_active,
                color: Colors.green,
              ),
              title: Text(
                notif['title'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(notif['subtitle'] ?? ''),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to detail or relevant screen
              },
            ),
          );
        },
      ),
    );
  }
}
