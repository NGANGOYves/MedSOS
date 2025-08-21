import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medsos/model/usermodel.dart' show UserModel;
import 'package:medsos/service/user_provider.dart';
import 'package:medsos/views/messagerie/chat_page.dart';
import 'package:medsos/widgets/backwrapper.dart';
import 'package:provider/provider.dart';

class PatientDetailPage extends StatelessWidget {
  final UserModel patient;

  const PatientDetailPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final doctor = Provider.of<UserProvider>(context).user;

    return BackRedirectWrapper(
      targetRoute: '/home-doctor',
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('Patient details'),
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back),
          ),
        ),
        backgroundColor: const Color(0xFFF9F9F9),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top section
                Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.green.shade200,
                      backgroundImage:
                          patient.photoUrl != null
                              ? NetworkImage(patient.photoUrl!)
                              : null,
                      child:
                          patient.photoUrl == null
                              ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              )
                              : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patient.fullName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            patient.occupation ?? 'Patient',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Row(
                          //   children: [
                          //     _buildIconButton(Icons.message, Colors.orange),
                          //     _buildIconButton(Icons.call, Colors.green),
                          //     _buildIconButton(Icons.location_on, Colors.blue),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                const Text(
                  "About",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  "${patient.fullName} is registered as a ${patient.role} in our platform. Contact and address information are listed below.",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 24),

                // Contact and address
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoTile(Icons.phone, "Phone", patient.phone),
                          if (patient.email.isNotEmpty)
                            _buildInfoTile(Icons.email, "Email", patient.email),
                          if (patient.address != null)
                            _buildInfoTile(
                              Icons.home,
                              "Address",
                              patient.address!,
                            ),
                        ],
                      ),
                    ),
                    Container(
                      width: 120,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          "Map Here",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const Text(
                  "Medical History",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),
                medicalHistoryCard(
                  title: "Hypertension",
                  date: "2024-12-01",
                  description: "Blood pressure under control with treatment.",
                ),
                medicalHistoryCard(
                  title: "Diabetes Type 2",
                  date: "2023-07-15",
                  description: "Monitoring glucose regularly. Diet-controlled.",
                ),
                medicalHistoryCard(
                  title: "Fracture Recovery",
                  date: "2022-11-10",
                  description: "Left leg fracture healing well post-surgery.",
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActivityButton(
                      icon: Icons.message_outlined,
                      text: "Contact Patient",
                      color: Colors.green,
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder:
                                (_) => ChatPage(
                                  currentUserId:
                                      doctor!
                                          .fullName, // 👈 on utilise fullName
                                  peerId:
                                      patient
                                          .fullName, // 👈 fullName du docteur
                                  peerName: patient.fullName,
                                ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget medicalHistoryCard({
    required String title,
    required String date,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8E9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.medical_services, color: Colors.green, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 6),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
