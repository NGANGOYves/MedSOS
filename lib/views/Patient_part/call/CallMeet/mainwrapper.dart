// import 'package:flutter/material.dart';
// import 'package:medsos/views/Patient_part/call/CallMeet/home_call.dart';
// import 'package:medsos/views/Patient_part/call/CallMeet/savedcall.dart';

// class Mainwrapper extends StatefulWidget {
//   const Mainwrapper({super.key});

//   @override
//   State<Mainwrapper> createState() => _MainwrapperState();
// }

// class _MainwrapperState extends State<Mainwrapper> {
//   int _currenIndex = 0;
//   final List<Widget> _screens = [Callpage(), const Savedcall()];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_currenIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.history),
//             label: 'Saved Calls',
//           ),
//         ],
//         currentIndex: _currenIndex,
//         onTap: (value) {
//           setState(() {
//             _currenIndex = value;
//           });
//         },
//       ),
//     );
//   }
// }
