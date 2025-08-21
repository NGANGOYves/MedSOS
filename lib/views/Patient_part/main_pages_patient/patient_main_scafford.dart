import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_botton_navigation/animated_botton_navigation.dart';

class PatientMainScaffold extends StatefulWidget {
  final Widget child;
  const PatientMainScaffold({super.key, required this.child});

  @override
  State<PatientMainScaffold> createState() => _PatientMainScaffoldState();
}

class _PatientMainScaffoldState extends State<PatientMainScaffold> {
  int _currentIndex = 0;

  final List<_TabItem> _tabs = const [
    _TabItem(icon: Icons.home, route: '/home-patient', label: 'Home'),
    _TabItem(icon: Icons.local_hospital, route: '/emergency', label: 'SOS'),
    _TabItem(icon: Icons.smart_toy, route: '/ai-assistant', label: 'Assistant'),
    _TabItem(icon: Icons.settings, route: '/setting-patient', label: 'Setting'),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = GoRouterState.of(context).uri.toString();
    final index = _tabs.indexWhere((tab) => location.startsWith(tab.route));
    if (index != -1 && index != _currentIndex) {
      setState(() => _currentIndex = index);
    }
  }

  Future<bool> _onWillPop() async {
    final location = GoRouterState.of(context).uri.toString();
    final isOnHome = location.startsWith('/home-patient');

    if (!isOnHome) {
      // If not on home page, navigate to home page instead of exiting
      setState(() => _currentIndex = 0);
      context.go(_tabs[0].route);
      return false; // prevent default back pop
    } else {
      // If already on home page, ask if user wants to exit
      final shouldExit = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Do you want to leave the app?'),
              actions: [
                TextButton(
                  onPressed:
                      () => Navigator.of(context).pop(false), // don't exit
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true), // exit
                  child: const Text('Yes'),
                ),
              ],
            ),
      );
      return shouldExit ?? false; // exit if yes, else no
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: AnimatedBottomNavigation(
          height: 65,
          indicatorSpaceBotton: 20,
          currentIndex: _currentIndex,
          onTapChange: (index) {
            if (_tabs[index].route !=
                GoRouterState.of(context).uri.toString()) {
              setState(() => _currentIndex = index);
              context.go(_tabs[index].route);
            }
          },
          icons: _tabs.map((e) => e.icon).toList(),
          iconSize: 28,
          selectedColor: Colors.green,
          unselectedColor: Colors.grey.shade400,
          backgroundColor: Colors.white,
          animationDuration: const Duration(milliseconds: 400),
          animationIconCurve: Curves.easeInOut,
          animationIndicatorCurve: Curves.easeInOut,
          indicatorDecoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}

/// Small private class to simplify tabs
class _TabItem {
  final IconData icon;
  final String route;
  final String label;

  const _TabItem({
    required this.icon,
    required this.route,
    required this.label,
  });
}
