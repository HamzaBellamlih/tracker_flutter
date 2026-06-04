import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final authNotifierProvider = Provider<AuthNotifier>((ref) {
  return AuthNotifier(ref.watch(firebaseAuthProvider));
});

class AuthNotifier {
  final FirebaseAuth _auth;
  AuthNotifier(this._auth);

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> register(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  String? get currentUserId => _auth.currentUser?.uid;
}
