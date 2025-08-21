import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionService {
  /// Vérifie l’abonnement d’un utilisateur
  /// Retourne `null` si tout est OK
  /// Sinon retourne un message d’erreur
  static Future<String?> checkSubscription(String phone) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('subscriptions')
              .doc(phone)
              .get();

      if (!doc.exists) {
        return "Aucun abonnement trouvé.";
      }

      final data = doc.data()!;
      final endDate = DateTime.parse(data['end_date']);
      final now = DateTime.now();

      if (endDate.isBefore(now)) {
        return "Votre abonnement a expiré.";
      }

      if (data['calls_remaining'] <= 0) {
        return "Vous avez épuisé tous vos appels.";
      }

      return null; // ✅ tout est bon
    } catch (e) {
      return "Erreur lors de la vérification : ${e.toString()}";
    }
  }

  static Future<void> decrementCall(String phone) async {
    final docRef = FirebaseFirestore.instance
        .collection('subscriptions')
        .doc(phone);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception("Aucun abonnement trouvé pour le numéro $phone.");
      }

      final data = snapshot.data();
      final currentCalls = data?['calls_remaining'] ?? 0;

      if (currentCalls <= 0) {
        throw Exception("Plus aucun appel restant.");
      }

      transaction.update(docRef, {'calls_remaining': currentCalls - 1});
    });
  }
}
