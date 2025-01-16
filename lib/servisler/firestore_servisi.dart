import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreServisi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Favori coinleri getir
  Stream<List<String>> favorileriDinle() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('kullanicilar')
        .doc(userId)
        .collection('favoriler')
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return [];
      return List<String>.from(snapshot.docs.first.data()['coinler'] ?? []);
    });
  }

  // Favori ekle/çıkar
  Future<void> favoriGuncelle(String coinId, bool ekle) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final docRef = _firestore
        .collection('kullanicilar')
        .doc(userId)
        .collection('favoriler')
        .doc('coins');

    if (ekle) {
      await docRef.set({
        'coinler': FieldValue.arrayUnion([coinId]),
        'guncellenmeTarihi': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } else {
      await docRef.set({
        'coinler': FieldValue.arrayRemove([coinId]),
        'guncellenmeTarihi': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }
} 