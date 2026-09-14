import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_user.dart';

class AuthProvider extends ChangeNotifier {
  static const String _userKey = 'lingo_auth_user_v1';

  AuthUser? _currentUser;
  bool _isInitialized = false;

  AuthProvider() {
    _loadUserFromStorage();
  }

  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => _currentUser != null;
  bool get isOnboardingCompleted => _currentUser != null;
  AuthUser? get currentUser => _currentUser;
  String get targetCourseId => _currentUser?.targetCourseId ?? 'spanish';
  String get nativeLanguage => _currentUser?.nativeLanguage ?? 'en';

  Future<void> _loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_userKey);
      if (jsonString != null) {
        final map = jsonDecode(jsonString) as Map<String, dynamic>;
        _currentUser = AuthUser.fromJson(map);
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
      if (_currentUser != null) {
        await prefs.setString(_userKey, jsonEncode(_currentUser!.toJson()));
      } else {
        await prefs.remove(_userKey);
      }
    } catch (e) {
      debugPrint('Error saving auth user: $e');
    }
  }

  /// 1-Tap Google Sign-In (Simulated realistic auth)
  Future<bool> signInWithGoogle({
    String? name,
    String? email,
    String? nativeLanguage,
    String? targetCourseId,
    int? dailyGoalMinutes,
    String? learningReason,
  }) async {
    final effectiveName = name ?? 'Google Learner';
    final effectiveEmail = email ?? 'learner.google@lingofun.app';

    _currentUser = AuthUser(
      id: 'g_${DateTime.now().millisecondsSinceEpoch}',
      name: effectiveName,
      email: effectiveEmail,
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      authMethod: 'google',
      nativeLanguage: nativeLanguage ?? 'en',
      targetCourseId: targetCourseId ?? 'spanish',
      dailyGoalMinutes: dailyGoalMinutes ?? 10,
      learningReason: learningReason ?? 'career',
      createdAt: DateTime.now(),
    );

    await _saveUserToStorage();
    notifyListeners();
    return true;
  }

  /// Email & Password Sign-Up
  Future<bool> signupWithEmail({
    required String name,
    required String email,
    required String password,
    String? nativeLanguage,
    String? targetCourseId,
    int? dailyGoalMinutes,
    String? learningReason,
  }) async {
    _currentUser = AuthUser(
      id: 'email_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim().isEmpty ? 'Lingo Learner' : name.trim(),
      email: email.trim(),
      authMethod: 'email',
      nativeLanguage: nativeLanguage ?? 'en',
      targetCourseId: targetCourseId ?? 'spanish',
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
    final displayName = email.split('@').first;
    final formattedName = displayName.isNotEmpty
        ? displayName[0].toUpperCase() + displayName.substring(1)
        : 'Learner';

    _currentUser = AuthUser(
      id: 'email_${DateTime.now().millisecondsSinceEpoch}',
      name: formattedName,
      email: email.trim(),
      authMethod: 'email',
      nativeLanguage: _currentUser?.nativeLanguage ?? 'en',
      targetCourseId: _currentUser?.targetCourseId ?? 'spanish',
      dailyGoalMinutes: _currentUser?.dailyGoalMinutes ?? 10,
      learningReason: _currentUser?.learningReason ?? 'career',
      createdAt: DateTime.now(),
    );

    await _saveUserToStorage();
    notifyListeners();
    return true;
  }

  /// Instant Guest Learner Mode
  Future<bool> continueAsGuest({
    String? nativeLanguage,
    String? targetCourseId,
    int? dailyGoalMinutes,
    String? learningReason,
  }) async {
    _currentUser = AuthUser(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Explorer Guest',
      authMethod: 'guest',
      nativeLanguage: nativeLanguage ?? 'en',
      targetCourseId: targetCourseId ?? 'spanish',
      dailyGoalMinutes: dailyGoalMinutes ?? 10,
      learningReason: learningReason ?? 'fun',
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
    _currentUser = null;
    await _saveUserToStorage();
    notifyListeners();
  }
}
