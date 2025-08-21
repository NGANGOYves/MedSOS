// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:medsos/service/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      setState(() {
        _progress += 0.05;
      });

      if (_progress >= 1.0) {
        timer.cancel();

        final userProvider = context.read<UserProvider>();
        await userProvider.loadUser();

        if (!mounted) return;

        if (userProvider.isLoggedIn) {
          final role = userProvider.user?.role;
          if (role == 'patient') {
            context.go('/home-patient');
          } else if (role == 'doctor') {
            context.go('/home-doctor');
          } else {
            // fallback
            context.go('/login');
          }
        } else {
          context.go('/login');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Logo
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/images/pharmacy_Icon-1.png',
                height: 100,
                width: 100,
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'MedSOS',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your Health, Our Priority',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: LinearProgressIndicator(
                value: _progress,
                color: Colors.green,
                backgroundColor: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Loading your health companion...',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            const Text(
              'Version 2.4.1',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
