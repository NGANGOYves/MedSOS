// import 'dart:math';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:medsos/service/user_provider.dart';
// import 'package:medsos/views/Patient_part/call/CallMeet/call.dart';
// import 'package:medsos/views/messagerie/chat_list.dart';
// import 'package:medsos/widgets/slider.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../../model/doctor.dart';
// import '../../../../widgets/doctor_card.dart';
// import '../../../../widgets/specialty_filter.dart';

// class PatientHomwView extends StatefulWidget {
//   const PatientHomwView({super.key});

//   @override
//   State<PatientHomwView> createState() => _PatientHomwViewState();
// }

// class _PatientHomwViewState extends State<PatientHomwView> {
//   final TextEditingController _searchController = TextEditingController();
//   bool _isSearching = false;
//   bool _isLoading = false;
//   List<Doctor> _searchResults = [];

//   final List<Doctor> doctors = [
//     Doctor(
//       name: "JEFF HERDSON",
//       specialty: "Brain specialist",
//       years: 6,
//       price: 1500,
//       rating: 4.9,
//       reviews: 320,
//       isFeatured: true,
//     ),
//     Doctor(
//       name: "Dr. Thomas Mitchell",
//       specialty: "Brain, Spinal Specialist",
//       years: 6,
//       price: 1300,
//       rating: 4.8,
//       reviews: 543,
//     ),
//     Doctor(
//       name: "Dr. Marcus Thomas",
//       specialty: "Neurologic",
//       years: 5,
//       price: 1400,
//       rating: 4.7,
//       reviews: 687,
//     ),
//     Doctor(
//       name: "Dr. Kate Mwangi",
//       specialty: "General",
//       years: 4,
//       price: 1200,
//       rating: 4.6,
//       reviews: 234,
//     ),
//     Doctor(
//       name: "Dr. Nina Jackson",
//       specialty: "Dermatology",
//       years: 8,
//       price: 1600,
//       rating: 4.9,
//       reviews: 410,
//     ),
//     Doctor(
//       name: "Dr. Abdoulaye Camara",
//       specialty: "Cardiology",
//       years: 7,
//       price: 1800,
//       rating: 4.7,
//       reviews: 305,
//     ),
//   ];

//   final List<String> specialties = [
//     'All',
//     'General',
//     'Neurologic',
//     'Cardiology',
//     'Dermatology',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final user = Provider.of<UserProvider>(context, listen: false).user;
//       if (user != null) {
//         // CallListenerService().startListening(currentUsername: user.fullName);
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('username', user.fullName);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged(String query) async {
//     if (query.isEmpty) {
//       setState(() {
//         _isSearching = false;
//         _isLoading = false;
//         _searchResults.clear();
//       });
//       return;
//     }

//     setState(() {
//       _isSearching = true;
//       _isLoading = true;
//     });

//     await Future.delayed(const Duration(milliseconds: 800)); // simulate loading

//     final lower = query.toLowerCase();
//     final results =
//         doctors.where((d) {
//           return d.name.toLowerCase().contains(lower) ||
//               d.specialty.toLowerCase().contains(lower);
//         }).toList();

//     setState(() {
//       _searchResults = results;
//       _isLoading = false;
//     });
//   }

//   Future<void> startCallToUser(
//     BuildContext context,
//     String callerUsername,
//     String calleeUsername,
//   ) async {
//     final db = FirebaseDatabase.instance.ref();
//     if (callerUsername.isEmpty || calleeUsername.isEmpty) return;

//     final roomCode = _generateRandomCode();
//     final timestamp = DateTime.now().millisecondsSinceEpoch;

//     await db.child("call_sessions").child(roomCode).set({
//       "roomCode": roomCode,
//       "caller": callerUsername,
//       "callee": calleeUsername,
//       "timestamp": timestamp,
//     });

//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => Call(callID: roomCode)),
//     );
//   }

//   String _generateRandomCode({int length = 6}) {
//     const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
//     final rand = Random();
//     return List.generate(
//       length,
//       (index) => chars[rand.nextInt(chars.length)],
//     ).join();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<UserProvider>(context).user;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F8FF),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               Row(
//                 children: [
//                   const CircleAvatar(
//                     backgroundColor: Colors.grey,
//                     radius: 20,
//                     child: Icon(Icons.person, color: Colors.white),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Welcome Back",
//                           style: TextStyle(fontSize: 12),
//                         ),
//                         Text(
//                           user!.fullName,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(
//                       Icons.notifications_none,
//                       color: Colors.green,
//                     ),
//                     onPressed: () => context.go('/notif'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // Search bar
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _searchController,
//                       onChanged: _onSearchChanged,
//                       decoration: InputDecoration(
//                         hintText: "Search doctor or anything...",
//                         prefixIcon: const Icon(Icons.search),
//                         fillColor: Colors.white,
//                         filled: true,
//                         contentPadding: const EdgeInsets.symmetric(vertical: 0),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: IconButton(
//                       icon: const Icon(Icons.message, color: Colors.grey),
//                       onPressed:
//                           () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder:
//                                   (_) => ChatListPage(
//                                     currentUserId: user.fullName,
//                                   ),
//                             ),
//                           ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // Search results or main content
//               if (_isSearching)
//                 _isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : _searchResults.isEmpty
//                     ? const Center(child: Text("No doctors found"))
//                     : Column(
//                       children:
//                           _searchResults.map((doc) {
//                             return Padding(
//                               padding: const EdgeInsets.only(bottom: 12),
//                               child: DoctorCard(
//                                 doctor: doc,
//                                 onTap: () => context.go('/doctor-detail'),
//                                 onCall: () {
//                                   final caller =
//                                       Provider.of<UserProvider>(
//                                         context,
//                                         listen: false,
//                                       ).user!;
//                                   startCallToUser(
//                                     context,
//                                     caller.fullName,
//                                     doc.name,
//                                   );
//                                 },
//                               ),
//                             );
//                           }).toList(),
//                     )
//               else ...[
//                 FeatureSlider(),
//                 const SizedBox(height: 24),
//                 const Text(
//                   "Doctor Speciality",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 Wrap(
//                   spacing: 12,
//                   children:
//                       specialties
//                           .map((s) => SpecialtyFilter(label: s))
//                           .toList(),
//                 ),
//                 const SizedBox(height: 24),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: const [
//                     Text(
//                       "Recommendation Doctors",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Icon(Icons.more_vert),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 ...doctors.skip(1).map((doc) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: DoctorCard(
//                       doctor: doc,
//                       onTap: () => context.go('/doctor-detail'),
//                       onCall: () {
//                         final caller =
//                             Provider.of<UserProvider>(
//                               context,
//                               listen: false,
//                             ).user!;
//                         startCallToUser(context, caller.fullName, doc.name);
//                       },
//                     ),
//                   );
//                 }).toList(),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medsos/model/usermodel.dart';
import 'package:medsos/service/user_provider.dart';
import 'package:medsos/views/Patient_part/call/CallMeet/savedcall.dart';
import 'package:medsos/views/Patient_part/main_pages_patient/doctor_profile_screen.dart';
import 'package:medsos/views/messagerie/chat_list.dart';
import 'package:medsos/widgets/slider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/doctor.dart';
import '../../../../widgets/doctor_card.dart';
import '../../../../widgets/specialty_filter.dart';

class PatientHomwView extends StatefulWidget {
  const PatientHomwView({super.key});

  @override
  State<PatientHomwView> createState() => _PatientHomwViewState();
}

class _PatientHomwViewState extends State<PatientHomwView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isLoading = false;
  List<Doctor> _searchResults = [];
  String selectedSpecialty = 'All';
  bool _isFilterLoading = false;
  List<UserModel> _fetchedDoctors = [];
  bool isDoctorLoading = true;

  final List<String> specialties = [
    'All',
    'General',
    'Neurologic',
    'Cardiology',
    'Dermatology',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', user.fullName);
        // Charger l’abonnement
        {
          setState(() {});
        }
      }
      await fetchDoctors();
    });
  }

  Future<void> fetchDoctors() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('user')
            .where('role', isEqualTo: 'doctor')
            .get();

    setState(() {
      _fetchedDoctors =
          snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _isLoading = false;
        _searchResults.clear();
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 500)); // simulate loading

    final lower = query.toLowerCase();
    final results =
        _fetchedDoctors.where((user) {
          final name = user.fullName.toLowerCase();
          final speciality = user.speciality?.toLowerCase() ?? '';
          return name.contains(lower) || speciality.contains(lower);
        }).toList();

    setState(() {
      _searchResults = results.cast<Doctor>();
      _isLoading = false;
    });
  }

  Future<int> _countUnreadAcrossChats(
    List<QueryDocumentSnapshot> chats,
    String currentUserId,
  ) async {
    int totalUnread = 0;

    for (var chat in chats) {
      final chatId = chat.id;

      final unread =
          await FirebaseFirestore.instance
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .where('read', isEqualTo: false)
              .where('senderId', isNotEqualTo: currentUserId)
              .get();

      totalUnread += unread.docs.length;
    }

    return totalUnread;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/setting-patient'),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 20,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome Back",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          user!.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream:
                        FirebaseFirestore.instance
                            .collection('call_sessions')
                            .where('caller', isEqualTo: user.fullName)
                            .where('isNewForUser', isEqualTo: true)
                            .snapshots(),
                    builder: (context, snapshot) {
                      int notifCount = snapshot.data?.docs.length ?? 0;

                      return Stack(
                        children: [
                          IconButton(
                            iconSize: 30,
                            icon: const Icon(
                              Icons.notifications_none,
                              color: Colors.green,
                            ),
                            onPressed: () async {
                              // Optionally, mark notifications as seen
                              final batch = FirebaseFirestore.instance.batch();
                              for (var doc in snapshot.data!.docs) {
                                batch.update(doc.reference, {
                                  'isNewForUser': false,
                                });
                              }
                              await batch.commit();

                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          SavedCall(username: user.fullName),
                                ),
                              );
                            },
                          ),
                          if (notifCount > 0)
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 20,
                                  minHeight: 20,
                                ),
                                child: Text(
                                  '$notifCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: "Search doctor or anything...",
                        prefixIcon: const Icon(Icons.search),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('chats')
                              .where(
                                'participants',
                                arrayContains: user.fullName,
                              )
                              .snapshots(),
                      builder: (context, chatSnapshot) {
                        if (!chatSnapshot.hasData) {
                          return const Icon(Icons.message, color: Colors.green);
                        }

                        final chatDocs = chatSnapshot.data!.docs;

                        return FutureBuilder<int>(
                          future: _countUnreadAcrossChats(
                            chatDocs,
                            user.fullName,
                          ),
                          builder: (context, countSnapshot) {
                            final totalUnread = countSnapshot.data ?? 0;

                            return Stack(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.message,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).push(
                                      MaterialPageRoute(
                                        builder:
                                            (_) => ChatListPage(
                                              currentUserId: user.fullName,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                                if (totalUnread > 0)
                                  Positioned(
                                    right: 4,
                                    top: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 20,
                                        minHeight: 20,
                                      ),
                                      child: Text(
                                        '$totalUnread',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Search results or main content
              if (_isSearching)
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _searchResults.isEmpty
                    ? const Center(child: Text("No doctors found"))
                    : Column(
                      children:
                          _searchResults.map((doc) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: DoctorCard(
                                doctor: doc,
                                onTap: () => context.go('/doctor-detail'),
                              ),
                            );
                          }).toList(),
                    )
              else ...[
                FeatureSlider(),

                // const SizedBox(height: 10),
                // Bannière abonnement
                const Text(
                  "Doctor Speciality",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children:
                      specialties.map((s) {
                        return SpecialtyFilter(
                          label: s,
                          isSelected: selectedSpecialty == s,
                          onTap: () async {
                            setState(() {
                              _isFilterLoading = true;
                              selectedSpecialty = s;
                            });

                            await Future.delayed(
                              const Duration(milliseconds: 500),
                            ); // simulate loading

                            if (mounted) {
                              setState(() {
                                _isFilterLoading = false;
                              });
                            }
                          },
                        );
                      }).toList(),
                ),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Recommended Doctors",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _isFilterLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                      children:
                          _fetchedDoctors
                              .where(
                                (doc) =>
                                    selectedSpecialty == 'All' ||
                                    doc.speciality?.toLowerCase() ==
                                        selectedSpecialty.toLowerCase(),
                              )
                              .map((doc) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: DoctorCard(
                                    doctor: Doctor(
                                      name: doc.fullName,
                                      specialty: doc.speciality ?? 'General',
                                      years: doc.years ?? 0,
                                      rating: doc.rating ?? 0,
                                      reviews: doc.reviews ?? 0,
                                      isFeatured: doc.isFeatured ?? false,
                                    ),
                                    onTap:
                                        () => Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).push(
                                          MaterialPageRoute(
                                            builder:
                                                (
                                                  context,
                                                ) => DoctorProfileScreen(
                                                  doctor: doc,
                                                  // doctorName: doc.fullName,
                                                  // speciality:
                                                  //     doc.speciality ??
                                                  //     'General',
                                                ),
                                          ),
                                        ),
                                  ),
                                );
                              })
                              .toList(),
                    ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
