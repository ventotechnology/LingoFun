import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _googleSignInInitialized = false;

  Future<void> initialize() async {
    if (!kIsWeb && !_googleSignInInitialized) {
      try {
        await GoogleSignIn.instance.initialize(
          serverClientId: '614665764814-oacbs4g4f97rcsah3gos83d2ps060gpr.apps.googleusercontent.com',
          clientId: defaultTargetPlatform == TargetPlatform.iOS
              ? '614665764814-sc8qhoub32tsrs5fo0euouj5513eh85m.apps.googleusercontent.com'
              : null,
        );
        _googleSignInInitialized = true;
      } catch (e) {
        debugPrint('GoogleSignIn.initialize warning: $e');
      }
    }
  }

  FirebaseAuth get auth => _auth;
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Real Google Sign-In supporting iOS, Android, and Web
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web uses popup to prevent blank screen / redirect issues
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        return await _auth.signInWithPopup(googleProvider);
      } else {
        await initialize();
        final googleUser = await GoogleSignIn.instance.authenticate();
        final googleAuth = googleUser.authentication;
        final String? idToken = googleAuth.idToken;
        if (idToken == null || idToken.isEmpty) {
          throw Exception('Unable to acquire Google ID Token. Please check account permissions.');
        }
        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: idToken,
        );

        return await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      debugPrint('Error during Google Sign-In: $e');
      rethrow;
    }
  }

  /// Real Email & Password Registration
  Future<UserCredential> signupWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (displayName != null && displayName.isNotEmpty && cred.user != null) {
      await cred.user!.updateDisplayName(displayName);
    }
    return cred;
  }

  /// Real Email & Password Login
  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Complete Sign Out across Google & Firebase
  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await GoogleSignIn.instance.signOut();
      }
    } catch (e) {
      debugPrint('GoogleSignIn signOut warning: $e');
    }
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('FirebaseAuth signOut warning: $e');
    }
  }
}
