import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medsos/model/firstaid.dart';
import 'package:medsos/views/Doctor_part/main_page_doctor/profile/edit_profile_doctor.dart';
import 'package:medsos/views/Doctor_part/main_page_doctor/profile/settings_screen.dart';
import 'package:medsos/views/Patient_part/chat/AI_service/ai_chat.dart';
import 'package:medsos/main.dart';
// import 'package:medsos/views/Patient_part/call/CallMeet/home_call.dart';
import 'package:medsos/views/Patient_part/main_pages_patient/first_aid/first_aid_screen.dart';
import 'package:medsos/views/Patient_part/main_pages_patient/first_aid/help.dart';
import 'package:medsos/views/Patient_part/main_pages_patient/patient_settings.dart';
import 'package:medsos/views/Patient_part/main_pages_patient/profile/edit_profile.dart';
import 'package:medsos/views/Patient_part/main_pages_patient/profile/notification_screen.dart';
import 'package:medsos/views/logins/loginscreen.dart';
import 'package:medsos/views/Doctor_part/main_page_doctor/doctorActivityPage.dart';
import 'package:medsos/views/Doctor_part/main_page_doctor/home_doctor_view.dart';
import 'package:medsos/views/Doctor_part/main_page_doctor/main_scafford_doctor.dart';
import 'package:medsos/views/Patient_part/main_pages_patient/patient_home_view.dart';
import 'package:medsos/views/Patient_part/main_pages_patient/patient_main_scafford.dart';
import '../splashscreen.dart';
import '../views/Patient_part/main_pages_patient/emergency_screen.dart';
import '../views/Patient_part/main_pages_patient/first_aid/first_aid_detail_screen.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/splash',
  routes: [
    //Patient Main Pages
    ShellRoute(
      builder: (context, state, child) => PatientMainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/home-patient',
          pageBuilder:
              (context, state) =>
                  _buildSlidePage(state, PatientHomwView(), fromRight: true),
        ),
        GoRoute(
          path: '/setting-patient',
          pageBuilder:
              (context, state) =>
                  _buildSlidePage(state, PatientParameter(), fromRight: false),
        ),
        GoRoute(
          path: '/emergency',
          pageBuilder:
              (context, state) => _buildSlidePage(
                state,
                const EmergencyScreen(),
                fromRight: true,
              ),
        ),
        GoRoute(
          path: '/ai-assistant',
          pageBuilder:
              (context, state) =>
                  _buildSlidePage(state, const ChatScreen(), fromRight: false),
          builder: (context, state) {
            final initialText = state.extra as String?;
            return ChatScreen(initialText: initialText);
          },
        ),
      ],
    ),

    //Doctors main Pages
    ShellRoute(
      builder: (context, state, child) => MainScaffoldDoctor(child: child),
      routes: [
        GoRoute(
          path: '/home-doctor',
          pageBuilder:
              (context, state) =>
                  _buildSlidePage(state, HomeDoctorView(), fromRight: true),
        ),
        GoRoute(
          path: '/Activity-page',
          pageBuilder:
              (context, state) =>
                  _buildSlidePage(state, DoctorActivityPage(), fromRight: true),
        ),
        GoRoute(
          path: '/setting-doctor',
          pageBuilder:
              (context, state) => _buildSlidePage(
                state,
                SettingsScreenDoctor(),
                fromRight: true,
              ),
        ),
      ],
    ),

    /// 🧠 Routes avec arguments (hors Scaffold)
    GoRoute(
      path: '/first-aid',
      name: 'firstAidList',
      builder: (context, state) => const FirstAidScreen(),
    ),
    GoRoute(
      path: '/first-aid-detail',
      name: 'firstAidDetail',
      builder: (context, state) {
        final aid = state.extra as FirstAid;
        return FirstAidDetailScreen(firstAid: aid);
      },
    ),

    /// 📦 Autres routes hors Shell (pleines pages)
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfilePage(),
    ),
    GoRoute(
      path: '/edit-profile-doctor',
      builder: (context, state) => const EditProfileDoctorPage(),
    ),

    GoRoute(
      path: '/first-aid',
      builder: (context, state) => const FirstAidScreen(),
    ),

    GoRoute(
      path: '/notif',
      builder: (context, state) => const NotificationScreen(),
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) => const PhoneLoginScreen(),
    ),
    // GoRoute(path: '/wrapper', builder: (context, state) => const Mainwrapper()),
    // GoRoute(
    //   path: '/setting',
    //   builder: (context, state) => const PatientSettingsScreen(),
    // ),
    // GoRoute(path: '/callpage', builder: (context, state) => Callpage()),

    // GoRoute(
    //   path: '/doctor-profile',
    //   builder: (context, state) => const DoctorProfileScreen(),
    // ),
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),

    // GoRoute(
    //   path: '/doctor-detail',
    //   builder: (context, state) => const DoctorProfileScreen(),
    // ),
    GoRoute(
      path: '/help',
      builder: (context, state) => const EmergencyHelpInfoScreen(),
    ),
    GoRoute(
      path: '/home-doctor',
      builder: (context, state) => const HomeDoctorView(),
    ),
  ],
);

/// 📦 Transition personnalisée
CustomTransitionPage _buildSlidePage(
  GoRouterState state,
  Widget child, {
  bool fromRight = true,
}) {
  final beginOffset = fromRight ? const Offset(1, 0) : const Offset(-1, 0);
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(
        begin: beginOffset,
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeInOut));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
