class AuthUser {
  final String id;
  final String name;
  final String? email;
  final String? avatarUrl;
  final String authMethod; // 'google', 'email', 'guest'
  final String nativeLanguage; // 'bn', 'en', 'es', 'hi', 'zh', 'fr', 'ja'
  final String targetCourseId;
  final int dailyGoalMinutes; // 5, 10, 15, 20
  final String learningReason; // 'career', 'travel', 'brain', 'school', 'fun'
  final DateTime createdAt;

  const AuthUser({
    required this.id,
    required this.name,
    this.email,
    this.avatarUrl,
    required this.authMethod,
    this.nativeLanguage = 'en',
    this.targetCourseId = 'spanish',
    this.dailyGoalMinutes = 10,
    this.learningReason = 'career',
    required this.createdAt,
  });

  bool get isGuest => authMethod == 'guest';
  bool get isGoogle => authMethod == 'google';
  bool get isEmail => authMethod == 'email';

  String get displayName => name;
  String get nativeLanguageCode => nativeLanguage;

  AuthUser copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? authMethod,
    String? nativeLanguage,
    String? targetCourseId,
    int? dailyGoalMinutes,
    String? learningReason,
    DateTime? createdAt,
  }) {
    return AuthUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      authMethod: authMethod ?? this.authMethod,
      nativeLanguage: nativeLanguage ?? this.nativeLanguage,
      targetCourseId: targetCourseId ?? this.targetCourseId,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      learningReason: learningReason ?? this.learningReason,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'authMethod': authMethod,
      'nativeLanguage': nativeLanguage,
      'targetCourseId': targetCourseId,
      'dailyGoalMinutes': dailyGoalMinutes,
      'learningReason': learningReason,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String? ?? 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: json['name'] as String? ?? 'Learner',
      email: json['email'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      authMethod: json['authMethod'] as String? ?? 'guest',
      nativeLanguage: json['nativeLanguage'] as String? ?? 'en',
      targetCourseId: json['targetCourseId'] as String? ?? 'spanish',
      dailyGoalMinutes: json['dailyGoalMinutes'] as int? ?? 10,
      learningReason: json['learningReason'] as String? ?? 'career',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class NativeLanguage {
  final String code;
  final String flag;
  final String name;
  final String nativeName;

  const NativeLanguage({
    required this.code,
    required this.flag,
    required this.name,
    required this.nativeName,
  });

  static const List<NativeLanguage> supportedLanguages = [
    NativeLanguage(code: 'bn', flag: '🇧🇩', name: 'Bengali', nativeName: 'বাংলা'),
    NativeLanguage(code: 'en', flag: '🇬🇧', name: 'English', nativeName: 'English'),
    NativeLanguage(code: 'es', flag: '🇪🇸', name: 'Spanish', nativeName: 'Español'),
    NativeLanguage(code: 'hi', flag: '🇮🇳', name: 'Hindi', nativeName: 'हिन्दी'),
    NativeLanguage(code: 'zh', flag: '🇨🇳', name: 'Chinese', nativeName: '中文'),
    NativeLanguage(code: 'fr', flag: '🇫🇷', name: 'French', nativeName: 'Français'),
    NativeLanguage(code: 'ja', flag: '🇯🇵', name: 'Japanese', nativeName: '日本語'),
  ];
}
