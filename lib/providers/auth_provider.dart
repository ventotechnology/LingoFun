import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  static const String _userKey = 'lingo_auth_user_v1';

  AuthUser? _currentUser;
  bool _isInitialized = false;

  AuthProvider() {
    _loadUserFromStorage();
  }

  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => _currentUser != null && _currentUser!.authMethod != 'guest';
  bool get isOnboardingCompleted => isAuthenticated;
  AuthUser? get currentUser => _currentUser;
  String get targetCourseId => _currentUser?.targetCourseId ?? 'bangla_to_english';
  String get nativeLanguage => _currentUser?.nativeLanguage ?? 'bn';

  Future<void> _loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_userKey);
      if (jsonString != null) {
        final map = jsonDecode(jsonString) as Map<String, dynamic>;
        final loadedUser = AuthUser.fromJson(map);
        // Wipe legacy mock or guest users
        if (loadedUser.authMethod == 'guest' ||
            loadedUser.email == 'learner.google@lingofun.app' ||
            loadedUser.name == 'Google Learner' ||
            loadedUser.name == 'Explorer Guest' ||
            loadedUser.name == 'Polyglot Master') {
          await prefs.remove(_userKey);
          _currentUser = null;
        } else {
          _currentUser = loadedUser;
        }
      }
    } catch (e) {
      debugPrint('Error loading auth user: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _saveUserToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_currentUser != null && _currentUser!.authMethod != 'guest') {
        await prefs.setString(_userKey, jsonEncode(_currentUser!.toJson()));
      } else {
        await prefs.remove(_userKey);
      }
    } catch (e) {
      debugPrint('Error saving auth user: $e');
    }
  }

  /// Real 1-Tap Google Sign-In
  Future<bool> signInWithGoogle({
    String? avatarUrl,
    String? nativeLanguage,
    String? targetCourseId,
    int? dailyGoalMinutes,
    String? learningReason,
  }) async {
    try {
      final cred = await AuthService().signInWithGoogle();
      if (cred == null) {
        // User closed or cancelled account picker
        return false;
      }
      final user = cred.user;
      if (user == null) {
        throw Exception('Google Sign-In completed but no account data was returned.');
      }

      final String effectiveId = user.uid;
      final String effectiveName = (user.displayName != null && user.displayName!.trim().isNotEmpty)
          ? user.displayName!.trim()
          : (user.email != null && user.email!.contains('@')
              ? user.email!.split('@').first
              : 'Learner');
      final String effectiveEmail = user.email ?? '';
      final String effectiveAvatar = (user.photoURL != null && user.photoURL!.isNotEmpty)
          ? user.photoURL!
          : (avatarUrl ?? '🦜');

      _currentUser = AuthUser(
        id: effectiveId,
        name: effectiveName,
        email: effectiveEmail,
        avatarUrl: effectiveAvatar,
        authMethod: 'google',
        nativeLanguage: nativeLanguage ?? _currentUser?.nativeLanguage ?? 'bn',
        targetCourseId: targetCourseId ?? _currentUser?.targetCourseId ?? 'bangla_to_english',
        dailyGoalMinutes: dailyGoalMinutes ?? _currentUser?.dailyGoalMinutes ?? 10,
        learningReason: learningReason ?? _currentUser?.learningReason ?? 'career',
        createdAt: DateTime.now(),
      );

      await _saveUserToStorage();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Live Google Auth error: $e');
      rethrow;
    }
  }

  /// Email & Password Sign-Up
  Future<bool> signupWithEmail({
    required String name,
    required String email,
    required String password,
    String? avatarUrl,
    String? nativeLanguage,
    String? targetCourseId,
    int? dailyGoalMinutes,
    String? learningReason,
  }) async {
    final cred = await AuthService().signupWithEmail(
      email: email,
      password: password,
      displayName: name,
    );

    final user = cred.user;
    if (user == null) {
      throw Exception('Account creation failed. Please check your credentials.');
    }

    _currentUser = AuthUser(
      id: user.uid,
      name: name.trim().isEmpty ? (user.displayName ?? 'Learner') : name.trim(),
      email: user.email ?? email.trim(),
      avatarUrl: (avatarUrl != null && avatarUrl.isNotEmpty) ? avatarUrl : '🦜',
      authMethod: 'email',
      nativeLanguage: nativeLanguage ?? 'bn',
      targetCourseId: targetCourseId ?? 'bangla_to_english',
      dailyGoalMinutes: dailyGoalMinutes ?? 10,
      learningReason: learningReason ?? 'career',
      createdAt: DateTime.now(),
    );

    await _saveUserToStorage();
    notifyListeners();
    return true;
  }

  /// Email & Password Log-In
  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final cred = await AuthService().loginWithEmail(
      email: email,
      password: password,
    );

    final user = cred.user;
    if (user == null) {
      throw Exception('Login failed. Please verify your email and password.');
    }

    String formattedName = (user.displayName != null && user.displayName!.isNotEmpty)
        ? user.displayName!
        : email.split('@').first;
    if (formattedName.isNotEmpty) {
      formattedName = formattedName[0].toUpperCase() + formattedName.substring(1);
    } else {
      formattedName = 'Learner';
    }

    _currentUser = AuthUser(
      id: user.uid,
      name: formattedName,
      email: user.email ?? email.trim(),
      avatarUrl: _currentUser?.avatarUrl ?? '🦜',
      authMethod: 'email',
      nativeLanguage: _currentUser?.nativeLanguage ?? 'bn',
      targetCourseId: _currentUser?.targetCourseId ?? 'bangla_to_english',
      dailyGoalMinutes: _currentUser?.dailyGoalMinutes ?? 10,
      learningReason: _currentUser?.learningReason ?? 'career',
      createdAt: DateTime.now(),
    );

    await _saveUserToStorage();
    notifyListeners();
    return true;
  }

  /// Update language and goal preferences
  Future<void> updatePreferences({
    String? nativeLanguage,
    String? targetCourseId,
    int? dailyGoalMinutes,
    String? learningReason,
  }) async {
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(
      nativeLanguage: nativeLanguage,
      targetCourseId: targetCourseId,
      dailyGoalMinutes: dailyGoalMinutes,
      learningReason: learningReason,
    );

    await _saveUserToStorage();
    notifyListeners();
  }

  /// Sign out & reset to onboarding
  Future<void> signOut() async {
    try {
      await AuthService().signOut();
    } catch (e) {
      debugPrint('AuthService signOut warning: $e');
    }
    _currentUser = null;
    await _saveUserToStorage();
    notifyListeners();
  }

  @visibleForTesting
  void setUserForTesting(AuthUser? user) {
    _currentUser = user;
    notifyListeners();
  }
}
