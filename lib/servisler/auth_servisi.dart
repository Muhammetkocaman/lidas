import 'package:firebase_auth/firebase_auth.dart';

class AuthHatasi {
  final String kod;
  final String mesaj;

  AuthHatasi(this.kod, this.mesaj);

  @override
  String toString() => mesaj;
}

class AuthServisi {
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Kullanıcı durumu takibi için getter'lar
  User? get mevcutKullanici => _auth.currentUser;
  Stream<User?> get durumTakipcisi => _auth.authStateChanges();

  // Email/Şifre ile kayıt işlemi
  Future<User?> mailIleKayit(String email, String sifre) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: sifre,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw AuthHatasi(e.code, 'Bu e-posta adresi zaten kullanımda.');
        case 'invalid-email':
          throw AuthHatasi(e.code, 'Geçerli bir e-posta adresi girin.');
        case 'operation-not-allowed':
          throw AuthHatasi(e.code, 'E-posta/şifre girişi devre dışı.');
        case 'weak-password':
          throw AuthHatasi(e.code, 'Daha güçlü bir şifre seçin.');
        default:
          throw AuthHatasi(e.code, 'Bir hata oluştu: ${e.message}');
      }
    } catch (e) {
      throw AuthHatasi('unknown', 'Beklenmeyen bir hata oluştu.');
    }
  }

  // Email/Şifre ile giriş işlemi
  Future<bool> mailIleGiris(String email, String sifre) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: sifre,
      );
      return userCredential.user != null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw AuthHatasi(e.code, 'Bu e-posta ile kayıtlı kullanıcı bulunamadı.');
        case 'wrong-password':
          throw AuthHatasi(e.code, 'Hatalı şifre girdiniz.');
        case 'invalid-email':
          throw AuthHatasi(e.code, 'Geçerli bir e-posta adresi girin.');
        case 'user-disabled':
          throw AuthHatasi(e.code, 'Bu hesap devre dışı bırakılmış.');
        default:
          throw AuthHatasi(e.code, 'Giriş yapılamadı: ${e.message}');
      }
    } catch (e) {
      throw AuthHatasi('unknown', 'Giriş sırasında bir hata oluştu.');
    }
  }

  // Çıkış yapma
  Future<void> cikisYap() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Çıkış hatası: $e');
      throw 'Çıkış yapılırken bir hata oluştu.';
    }
  }
} 