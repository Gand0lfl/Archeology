import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<AuthResult> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(success: true, user: userCredential.user, errorMessage: '');
    } catch (e) {
      String errorMessage = 'Произошла ошибка входа';
      if (e is FirebaseAuthException) {
        errorMessage = e.message!;
      }
      return AuthResult(success: false, errorMessage: errorMessage);
    }
  }

  Future<AuthResult> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(success: true, user: userCredential.user, errorMessage: '');
    } catch (e) {
      String errorMessage = 'Произошла ошибка регистрации';
      if (e is FirebaseAuthException) {
        errorMessage = e.message!;
      }
      return AuthResult(success: false, errorMessage: errorMessage);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

class AuthResult {
  final bool success;
  final User? user;
  final String errorMessage;

  AuthResult({required this.success, this.user, required this.errorMessage});
}
