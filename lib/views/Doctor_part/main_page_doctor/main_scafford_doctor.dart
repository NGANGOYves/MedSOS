import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_botton_navigation/animated_botton_navigation.dart';
import 'package:medsos/service/call_service.dart';
import 'package:medsos/service/user_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class MainScaffoldDoctor extends StatefulWidget {
  final Widget child;
  const MainScaffoldDoctor({super.key, required this.child});

  @override
  State<MainScaffoldDoctor> createState() => _MainScaffoldDoctorState();
}

class _MainScaffoldDoctorState extends State<MainScaffoldDoctor> {
  int _currentIndex = 0;
  final List<_TabItem> _tabs = const [
    _TabItem(icon: Icons.home, route: '/home-doctor', label: 'Home'),
    _TabItem(icon: Icons.work, route: '/Activity-page', label: 'Activity'),
    _TabItem(icon: Icons.settings, route: '/setting-doctor', label: 'Setting'),
  ];

  @override
  void initState() {
    super.initState();

    // Démarrer le service d'écoute d'appels
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final doctor = context.read<UserProvider>().user;
      if (doctor != null) {
        DoctorCallListenerService().start(doctorName: doctor.fullName);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = GoRouterState.of(context).uri.toString();
    final index = _tabs.indexWhere((tab) => location.startsWith(tab.route));
    if (index != -1 && index != _currentIndex) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: AnimatedBottomNavigation(
        height: 65,
        indicatorSpaceBotton: 20,
        currentIndex: _currentIndex,
        onTapChange: (index) {
          if (_tabs[index].route != GoRouterState.of(context).uri.toString()) {
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
    );
  }
}

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
