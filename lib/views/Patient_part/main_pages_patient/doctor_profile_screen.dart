// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medsos/service/user_provider.dart';
import 'package:medsos/views/messagerie/chat_page.dart';
import 'package:medsos/widgets/backwrapper.dart';
import 'package:provider/provider.dart';

import '../../../model/usermodel.dart';

class DoctorProfileScreen extends StatelessWidget {
  final UserModel doctor;

  const DoctorProfileScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return BackRedirectWrapper(
      targetRoute: '/home-patient',
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(gradient: gradient),
                child: Stack(
                  children: [
                    Positioned(
                      left: 16,
                      top: 40,
                      child: Row(
                        children: [
                          BackButton(
                            color: Colors.white,
                            onPressed: () => context.pop(),
                          ),
                          const Text(
                            "Doctor Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            doctor.photoUrl != null
                                ? NetworkImage(doctor.photoUrl!)
                                : null,
                        child:
                            doctor.photoUrl == null
                                ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey,
                                )
                                : null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    Text(
                      '${doctor.fullName} ',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (doctor.speciality != null)
                      Text(
                        doctor.speciality!,
                        style: const TextStyle(color: Colors.green),
                      ),
                    const SizedBox(height: 8),
                    if (doctor.rating != null && doctor.reviews != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          Text("${doctor.rating} (${doctor.reviews} reviews)"),
                        ],
                      ),
                    const SizedBox(height: 16),

                    const SizedBox(height: 20),
                    AboutSection(doctor: doctor),
                    const SizedBox(height: 20),
                    const SpecializationTags(),
                    const SizedBox(height: 20),
                    const AvailabilitySection(),
                    const SizedBox(height: 20),
                    const LocationCard(),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      icon: const Icon(Icons.message),
                      label: const Text("Contact Now"),
                      onPressed: () {
                        final currentUser = context.read<UserProvider>().user;

                        if (currentUser == null) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ChatPage(
                                  currentUserId: currentUser.fullName,
                                  peerId: doctor.fullName,
                                  peerName: doctor.fullName,
                                ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────── Static Components ─────────────

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.green),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class AboutSection extends StatelessWidget {
  final UserModel doctor;
  const AboutSection({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info, color: Colors.green),
            SizedBox(width: 6),
            Text("About Doctor", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 8),
        Text(
          "Dr. ${doctor.fullName} is a board-certified cardiologist with over ${doctor.years} years of experience in treating ${doctor.speciality} diseases. He specializes in ${doctor.speciality}, heart failure management, and preventive cardiology.",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

class SpecializationTags extends StatelessWidget {
  const SpecializationTags({super.key});

  final List<String> tags = const [
    "Interventional Cardiology",
    "Heart Failure",
    "Preventive Cardiology",
    "Cardiac Imaging",
    "Hypertension",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.medical_services, color: Colors.green),
            SizedBox(width: 6),
            Text(
              "Specializations",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              tags
                  .map(
                    (e) => Chip(
                      label: Text(e),
                      backgroundColor: Colors.green.shade50,
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}

class AvailabilitySection extends StatelessWidget {
  const AvailabilitySection({super.key});

  final Map<String, String> availability = const {
    "Monday": "9:00 AM - 4:00 PM",
    "Tuesday": "9:00 AM - 4:00 PM",
    "Wednesday": "10:00 AM - 2:00 PM",
    "Thursday": "9:00 AM - 4:00 PM",
    "Friday": "9:00 AM - 1:00 PM",
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.schedule, color: Colors.green),
            SizedBox(width: 6),
            Text(
              "Availability Schedule",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          children:
              availability.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  trailing: Text(
                    entry.value,
                    style: const TextStyle(color: Colors.green),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}

class LocationCard extends StatelessWidget {
  const LocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on, color: Colors.green),
            SizedBox(width: 6),
            Text(
              "Practice Location",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 8),
        Card(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "MedSOS Cardiac Center",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "123 Medical Plaza Dr, Suite 456, Boston, MA 02115",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
