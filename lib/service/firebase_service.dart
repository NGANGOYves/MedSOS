import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/usermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<void> saveUserProfile(UserModel user) async {
    final userFirebase = _auth.currentUser;
    if (userFirebase == null) {
      print("❌ No user authenticated during saveUserProfile.");
      throw Exception("No user authenticated.");
    }

    final uid = userFirebase.uid;
    print("✅ Current user UID: $uid");

    // Check for existing doc by phone
    final snapshot =
        await _firestore
            .collection('user')
            .where('phone', isEqualTo: user.phone)
            .limit(1)
            .get();

    print("📦 Snapshot from phone search: ${snapshot.docs.length} doc(s)");

    final docId = snapshot.docs.isNotEmpty ? snapshot.docs.first.id : uid;

    print("📝 Will use doc ID: $docId to save user profile");

    await _firestore.collection('user').doc(docId).set(user.toMap());
    print("✅ User profile saved in Firestore.");
  }

  Future<UserModel?> getUserProfile() async {
    final uid = currentUser?.uid;
    if (uid == null) {
      print("❌ No authenticated user in getUserProfile.");
      return null;
    }

    print("🔍 Fetching user profile with UID: $uid");

    final doc = await _firestore.collection('user').doc(uid).get();

    if (!doc.exists) {
      print("❌ No document found for user profile.");
      return null;
    }

    print("✅ User profile document found.");
    return UserModel.fromMap(doc.data()!);
  }

  Future<UserModel?> getUserByPhone(String phone) async {
    print("🔍 Searching for user with phone: $phone");

    final snapshot =
        await _firestore
            .collection('user')
            .where('phone', isEqualTo: phone)
            .limit(1)
            .get();

    if (snapshot.docs.isNotEmpty) {
      print("✅ User found with phone: $phone");
      return UserModel.fromMap(snapshot.docs.first.data());
    }

    print("❌ No user found with phone: $phone");
    return null;
  }

  Future<void> signOut() async {
    print("🔌 Signing out user...");
    await _auth.signOut();
    print("✅ Sign out completed.");
  }

  Future<bool> isProfileComplete() async {
    print("📋 Checking if user profile is complete...");
    final profile = await getUserProfile();
    if (profile == null) {
      print("❌ No profile found.");
      return false;
    }
    final complete = profile.fullName.isNotEmpty && profile.email.isNotEmpty;
    print("✅ Profile complete status: $complete");
    return complete;
  }

  Future<String?> getUserRole() async {
    print("🎭 Getting user role...");
    final profile = await getUserProfile();
    print("✅ Role: ${profile?.role}");
    return profile?.role;
  }

  Future<void> saveUserLocally(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_model', user.toJson());
    print("💾 User profile saved locally.");
  }

  Future<UserModel?> getUserLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_model');
    if (jsonString != null) {
      print("📥 Retrieved user from local storage.");
      return UserModel.fromJson(jsonString);
    }
    print("❌ No local user data found.");
    return null;
  }

  Future<void> clearUserLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_model');
    print("🗑️ Local user data cleared.");
  }

  Future<String?> getDoctorFirestoreIdByName(String doctorName) async {
    print("🔍 Searching for doctor with name: $doctorName");

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('fullName', isEqualTo: doctorName)
            .limit(1)
            .get();

    if (snapshot.docs.isNotEmpty) {
      print("✅ Doctor found, ID: ${snapshot.docs.first.id}");
      return snapshot.docs.first.id;
    } else {
      print("❌ No doctor found with that name.");
      return null;
    }
  }
}
