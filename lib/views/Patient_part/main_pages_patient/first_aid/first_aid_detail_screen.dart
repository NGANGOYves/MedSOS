// import 'package:flutter/material.dart';
// import 'package:medsos/model/firstaid.dart';

// // import 'aid_condition.dart';

// // class FirstAidDetailScreen extends StatelessWidget {
// //   final AidCondition condition;

// //   const FirstAidDetailScreen({super.key, required this.condition});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(condition.title),
// //         backgroundColor: condition.textColor,
// //         foregroundColor: Colors.white,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(20),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Center(
// //               child: Icon(condition.icon, color: condition.textColor, size: 60),
// //             ),
// //             const SizedBox(height: 20),
// //             Text(
// //               condition.description,
// //               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 16),
// //             Text(
// //               'Steps to follow:',
// //               style: TextStyle(
// //                 fontSize: 16,
// //                 color: condition.textColor,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Expanded(
// //               child: ListView.builder(
// //                 itemCount: condition.detailedSteps.length,
// //                 itemBuilder: (context, index) {
// //                   return Padding(
// //                     padding: const EdgeInsets.symmetric(vertical: 6),
// //                     child: Row(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         const Text("• ", style: TextStyle(fontSize: 16)),
// //                         Expanded(
// //                           child: Text(
// //                             condition.detailedSteps[index],
// //                             style: const TextStyle(fontSize: 15),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             if (condition.isTutorial)
// //               Center(
// //                 child: ElevatedButton.icon(
// //                   icon: const Icon(Icons.play_arrow),
// //                   label: const Text('Watch Tutorial'),
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: condition.textColor,
// //                   ),
// //                   onPressed: () {
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       SnackBar(content: Text('Tutorial not implemented.')),
// //                     );
// //                   },
// //                 ),
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// class FirstAidDetailScreen extends StatelessWidget {
//   final FirstAid firstAid;

//   const FirstAidDetailScreen({super.key, required this.firstAid});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(firstAid.title),
//         backgroundColor: Colors.green,
//       ),
//       body: ListView.builder(
//         itemCount: firstAid.steps.length,
//         itemBuilder: (_, index) {
//           final step = firstAid.steps[index];
//           return Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   ClipRRect(
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(10),
//                     ),
//                     child: Image.asset(
//                       step.imagePath,
//                       fit: BoxFit.cover,
//                       height: 180,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Text(
//                       step.description,
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:medsos/model/firstaid.dart';

class FirstAidDetailScreen extends StatelessWidget {
  final FirstAid firstAid;

  const FirstAidDetailScreen({super.key, required this.firstAid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: Text(
          firstAid.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Top visual header with icon and title
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.health_and_safety,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  "Follow these important steps:",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Steps content
          Expanded(
            child: ListView.builder(
              itemCount: firstAid.steps.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (_, index) {
                final step = firstAid.steps[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.shade100,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.asset(
                          step.imagePath,
                          fit: BoxFit.cover,
                          height: 180,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          step.description,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Optional tutorial button (bottom)
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 12.0),
          //   child: ElevatedButton.icon(
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.green,
          //       padding: const EdgeInsets.symmetric(
          //         horizontal: 24,
          //         vertical: 12,
          //       ),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(30),
          //       ),
          //     ),
          //     icon: const Icon(Icons.play_circle_fill),
          //     label: const Text(
          //       "Watch Tutorial",
          //       style: TextStyle(fontSize: 16),
          //     ),
          //     onPressed: () {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         const SnackBar(
          //           content: Text("Tutorial video not yet available."),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
