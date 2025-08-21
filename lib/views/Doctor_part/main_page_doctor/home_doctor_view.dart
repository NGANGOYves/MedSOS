// import 'package:flutter/material.dart';
// import 'package:medsos/model/usermodel.dart';
// import 'package:medsos/views/Doctor_part/main_page_doctor/patien_detail.dart';
// import 'package:provider/provider.dart';
// import '../../../../service/user_provider.dart';

// class HomeDoctorView extends StatefulWidget {
//   const HomeDoctorView({super.key});

//   @override
//   State<HomeDoctorView> createState() => _HomeDoctorViewState();
// }

// class _HomeDoctorViewState extends State<HomeDoctorView> {
//   final List<UserModel> patientsUnderDoctor = [
//     UserModel(
//       fullName: 'Patient One',
//       phone: '670000001',
//       email: 'patient1@email.com',
//       role: 'patient',
//       photoUrl: null,
//       occupation: 'Student',
//     ),
//     UserModel(
//       fullName: 'Patient Two',
//       phone: '670000002',
//       email: 'patient2@email.com',
//       role: 'patient',
//       photoUrl: null,
//       occupation: 'Engineer',
//     ),
//     UserModel(
//       fullName: 'Patient Three',
//       phone: '670000003',
//       email: 'patient3@email.com',
//       role: 'patient',
//       photoUrl: 'https://i.pravatar.cc/150?img=3',
//       occupation: 'Trader',
//     ),
//   ];

//   String searchQuery = "";

//   @override
//   Widget build(BuildContext context) {
//     final doctor = Provider.of<UserProvider>(context).user;

//     final filteredPatients =
//         patientsUnderDoctor
//             .where(
//               (p) =>
//                   p.fullName.toLowerCase().contains(searchQuery.toLowerCase()),
//             )
//             .toList();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F8FF),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header Greeting
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 24,
//                     backgroundColor: Colors.green.shade100,
//                     child: const Icon(Icons.person, color: Colors.green),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Welcome Doctor 👋",
//                           style: TextStyle(fontSize: 12, color: Colors.black87),
//                         ),
//                         Text(
//                           doctor?.fullName ?? "Doctor",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),

//               // Search Bar
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.green.shade100,
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   onChanged: (value) {
//                     setState(() => searchQuery = value);
//                   },
//                   decoration: const InputDecoration(
//                     hintText: "Search patient...",
//                     prefixIcon: Icon(Icons.search),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.all(14),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),

//               const Text(
//                 "Recently Contacted Patient",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 12),

//               // Patients List
//               Expanded(
//                 child:
//                     filteredPatients.isEmpty
//                         ? Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(
//                               Icons.people_outline,
//                               size: 64,
//                               color: Colors.grey,
//                             ),
//                             const SizedBox(height: 8),
//                             const Text(
//                               "No patients found",
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           ],
//                         )
//                         : ListView.builder(
//                           itemCount: filteredPatients.length,
//                           itemBuilder: (context, index) {
//                             final patient = filteredPatients[index];
//                             return GestureDetector(
//                               onTap: () {
//                                 Navigator.of(
//                                   context,
//                                   rootNavigator: true,
//                                 ).pushReplacement(
//                                   MaterialPageRoute(
//                                     builder:
//                                         (context) =>
//                                             PatientDetailPage(patient: patient),
//                                   ),
//                                 );
//                               },
//                               child: GestureDetector(
//                                 onTap: () {
//                                   Navigator.of(
//                                     context,
//                                     rootNavigator: true,
//                                   ).push(
//                                     MaterialPageRoute(
//                                       builder:
//                                           (context) => PatientDetailPage(
//                                             patient: patient,
//                                           ),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                   margin: const EdgeInsets.only(bottom: 16),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20),
//                                     color: Colors.white,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.green.withOpacity(0.1),
//                                         blurRadius: 12,
//                                         offset: const Offset(0, 4),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       // Gradient strip on left
//                                       Container(
//                                         width: 6,
//                                         height: 100,
//                                         decoration: BoxDecoration(
//                                           borderRadius: const BorderRadius.only(
//                                             topLeft: Radius.circular(20),
//                                             bottomLeft: Radius.circular(20),
//                                           ),
//                                           gradient: LinearGradient(
//                                             colors: [
//                                               Colors.green.shade400,
//                                               Colors.green.shade700,
//                                             ],
//                                             begin: Alignment.topCenter,
//                                             end: Alignment.bottomCenter,
//                                           ),
//                                         ),
//                                       ),

//                                       // Main content
//                                       Expanded(
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 16,
//                                             vertical: 12,
//                                           ),
//                                           child: Row(
//                                             children: [
//                                               Stack(
//                                                 children: [
//                                                   CircleAvatar(
//                                                     radius: 30,
//                                                     backgroundImage:
//                                                         patient.photoUrl != null
//                                                             ? NetworkImage(
//                                                               patient.photoUrl!,
//                                                             )
//                                                             : null,
//                                                     backgroundColor:
//                                                         Colors.green.shade200,
//                                                     child:
//                                                         patient.photoUrl == null
//                                                             ? const Icon(
//                                                               Icons.person,
//                                                               color:
//                                                                   Colors.white,
//                                                             )
//                                                             : null,
//                                                   ),
//                                                   // Optional online dot
//                                                   Positioned(
//                                                     bottom: 0,
//                                                     right: 0,
//                                                     child: Container(
//                                                       height: 12,
//                                                       width: 12,
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.green,
//                                                         shape: BoxShape.circle,
//                                                         border: Border.all(
//                                                           color: Colors.white,
//                                                           width: 2,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               const SizedBox(width: 16),
//                                               Expanded(
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       patient.fullName,
//                                                       style: const TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                         fontSize: 16,
//                                                         color: Colors.black87,
//                                                       ),
//                                                     ),
//                                                     const SizedBox(height: 4),
//                                                     Row(
//                                                       children: [
//                                                         const Icon(
//                                                           Icons.phone,
//                                                           size: 14,
//                                                           color: Colors.grey,
//                                                         ),
//                                                         const SizedBox(
//                                                           width: 6,
//                                                         ),
//                                                         Text(
//                                                           patient.phone,
//                                                           style: const TextStyle(
//                                                             fontSize: 13,
//                                                             color:
//                                                                 Colors.black54,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     if (patient.occupation !=
//                                                         null)
//                                                       Padding(
//                                                         padding:
//                                                             const EdgeInsets.only(
//                                                               top: 2,
//                                                             ),
//                                                         child: Row(
//                                                           children: [
//                                                             const Icon(
//                                                               Icons
//                                                                   .badge_outlined,
//                                                               size: 14,
//                                                               color:
//                                                                   Colors.grey,
//                                                             ),
//                                                             const SizedBox(
//                                                               width: 6,
//                                                             ),
//                                                             Text(
//                                                               patient
//                                                                   .occupation!,
//                                                               style: const TextStyle(
//                                                                 fontSize: 13,
//                                                                 color:
//                                                                     Colors
//                                                                         .black54,
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               const Icon(
//                                                 Icons.arrow_forward_ios,
//                                                 size: 16,
//                                                 color: Colors.grey,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medsos/model/usermodel.dart';
import 'package:medsos/service/user_provider.dart';
import 'package:medsos/views/Doctor_part/main_page_doctor/patien_detail.dart';
import 'package:provider/provider.dart';

class HomeDoctorView extends StatefulWidget {
  const HomeDoctorView({super.key});

  @override
  State<HomeDoctorView> createState() => _HomeDoctorViewState();
}

class _HomeDoctorViewState extends State<HomeDoctorView> {
  List<UserModel> contactedPatients = [];
  String searchQuery = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchContactedPatients();
  }

  Future<void> _fetchContactedPatients() async {
    final doctor = context.read<UserProvider>().user;

    if (doctor == null) return;

    final query =
        await FirebaseFirestore.instance
            .collection('call_sessions')
            .where('calleeName', isEqualTo: doctor.fullName)
            .get();

    final Set<String> callerNames = {};

    for (var doc in query.docs) {
      final caller = doc.data()['caller'];
      if (caller != null) callerNames.add(caller);
    }

    final List<UserModel> fetchedPatients = [];

    for (var name in callerNames) {
      final snap =
          await FirebaseFirestore.instance
              .collection('user')
              .where('fullName', isEqualTo: name)
              .limit(1)
              .get();

      if (snap.docs.isNotEmpty) {
        final data = snap.docs.first.data();
        fetchedPatients.add(UserModel.fromMap(data));
      }
    }

    setState(() {
      contactedPatients = fetchedPatients;
      _isLoading = false;
    });
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Exit App"),
            content: const Text("Do you want to quit the app?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Yes"),
              ),
            ],
          ),
    );

    if (shouldExit == true) {
      SystemNavigator.pop(); // Quits the app
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final doctor = Provider.of<UserProvider>(context).user;

    final filteredPatients =
        contactedPatients
            .where(
              (p) =>
                  p.fullName.toLowerCase().contains(searchQuery.toLowerCase()),
            )
            .toList();

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F8FF),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.green.shade100,
                      child: const Icon(Icons.person, color: Colors.green),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Welcome Doctor 👋",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            doctor?.fullName ?? "Doctor",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.shade100,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() => searchQuery = value);
                    },
                    decoration: const InputDecoration(
                      hintText: "Search patient...",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(14),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  "Recently Contacted Patient",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                      child:
                          filteredPatients.isEmpty
                              ? const Center(
                                child: Text(
                                  "No patients found.",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                              : ListView.builder(
                                itemCount: filteredPatients.length,
                                itemBuilder: (context, index) {
                                  final patient = filteredPatients[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).push(
                                        MaterialPageRoute(
                                          builder:
                                              (_) => PatientDetailPage(
                                                patient: patient,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.green.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                      20,
                                                    ),
                                                    bottomLeft: Radius.circular(
                                                      20,
                                                    ),
                                                  ),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.green.shade400,
                                                  Colors.green.shade700,
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 12,
                                                  ),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage:
                                                        patient.photoUrl != null
                                                            ? NetworkImage(
                                                              patient.photoUrl!,
                                                            )
                                                            : null,
                                                    backgroundColor:
                                                        Colors.green.shade200,
                                                    child:
                                                        patient.photoUrl == null
                                                            ? const Icon(
                                                              Icons.person,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                            : null,
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          patient.fullName,
                                                          style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                              Icons.phone,
                                                              size: 14,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            const SizedBox(
                                                              width: 6,
                                                            ),
                                                            Text(
                                                              patient.phone,
                                                              style: const TextStyle(
                                                                fontSize: 13,
                                                                color:
                                                                    Colors
                                                                        .black54,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        if (patient
                                                                .occupation !=
                                                            null)
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  top: 2,
                                                                ),
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .badge_outlined,
                                                                  size: 14,
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                ),
                                                                const SizedBox(
                                                                  width: 6,
                                                                ),
                                                                Text(
                                                                  patient
                                                                      .occupation!,
                                                                  style: const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color:
                                                                        Colors
                                                                            .black54,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 16,
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
