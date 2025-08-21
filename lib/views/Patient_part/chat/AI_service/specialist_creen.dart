// ignore: file_names
import 'package:flutter/material.dart';

class SpecialistScreen extends StatefulWidget {
  const SpecialistScreen({super.key});

  @override
  State<SpecialistScreen> createState() => _SpecialistScreenState();
}

class _SpecialistScreenState extends State<SpecialistScreen> {
  final List<String> _categories = [
    'All',
    'Cardiology',
    'Neurology',
    'Pediatrics',
    'More',
  ];
  String selectedCategory = 'All';

  final List<Map<String, dynamic>> _doctors = [
    {
      'name': 'Dr. Sarah Johnson',
      'specialty': 'Cardiology',
      'rating': 4.9,
      'reviews': 120,
      'color': Colors.green[100],
    },
    {
      'name': 'Dr. Michael Chen',
      'specialty': 'Neurology',
      'rating': 4.8,
      'reviews': 95,
      'color': Colors.blue[100],
    },
    {
      'name': 'Dr. Emily Rodriguez',
      'specialty': 'Pediatrics',
      'rating': 4.6,
      'reviews': 80,
      'color': Colors.orange[100],
    },
    {
      'name': 'Dr. James Wilson',
      'specialty': 'General',
      'rating': 4.7,
      'reviews': 110,
      'color': Colors.purple[100],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Our Specialists"),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search doctors or specialties...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children:
                  _categories.map((category) {
                    final bool isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        selectedColor: Colors.green[100],
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color:
                              isSelected ? Colors.green[800] : Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // Doctors Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                itemCount: _doctors.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final doctor = _doctors[index];
                  return _buildDoctorCard(doctor);
                },
              ),
            ),
          ),
        ],
      ),

      // Floating Filter Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          // Show bottom filter modal, etc.
        },
        child: const Icon(Icons.tune),
      ),
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: doctor['color'],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Center(
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.grey[700], size: 30),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            doctor['name'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              doctor['specialty'],
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star, size: 14, color: Colors.orange),
              const SizedBox(width: 4),
              Text('${doctor['rating']} (${doctor['reviews']}+)'),
            ],
          ),
        ],
      ),
    );
  }
}
