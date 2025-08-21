import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../model/usermodel.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  bool get isLoggedIn => _user != null;

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_model');
    if (userJson != null) {
      final data = jsonDecode(userJson);
      _user = UserModel.fromJson(data);
      notifyListeners();
    }
  }

  Future<void> setUser(UserModel user) async {
    _user = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_model', jsonEncode(user.toJson()));
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    notifyListeners();

    // Déconnexion Firebase
    await FirebaseAuth.instance.signOut();

    // Nettoyage de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('user_model'); // Si tu l’as utilisé ailleurs

    // Nettoyage du service Zego
    ZegoUIKitPrebuiltCallInvitationService().uninit();
  }
}
