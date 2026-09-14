class UserProgress {
  final int hearts;
  final int gems;
  final int streak;
  final int totalXp;
  final Set<String> completedLessonIds;
  final int streakFreezeCount;
  final DateTime? lastActiveDate;
  final List<String> unlockedOutfitIds;
  final String equippedOutfitId;
  final Set<String> mistakeExerciseIds;
  final Set<String> completedStoryIds;

  static const int maxHearts = 5;

  const UserProgress({
    this.hearts = 5,
    this.gems = 120,
    this.streak = 1,
    this.totalXp = 0,
    this.completedLessonIds = const {},
    this.streakFreezeCount = 1,
    this.lastActiveDate,
    this.unlockedOutfitIds = const ['classic'],
    this.equippedOutfitId = 'classic',
    this.mistakeExerciseIds = const {},
    this.completedStoryIds = const {},
  });

  UserProgress copyWith({
    int? hearts,
    int? gems,
    int? streak,
    int? totalXp,
    Set<String>? completedLessonIds,
    int? streakFreezeCount,
    DateTime? lastActiveDate,
    List<String>? unlockedOutfitIds,
    String? equippedOutfitId,
    Set<String>? mistakeExerciseIds,
    Set<String>? completedStoryIds,
  }) {
    return UserProgress(
      hearts: hearts ?? this.hearts,
      gems: gems ?? this.gems,
      streak: streak ?? this.streak,
      totalXp: totalXp ?? this.totalXp,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      streakFreezeCount: streakFreezeCount ?? this.streakFreezeCount,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      unlockedOutfitIds: unlockedOutfitIds ?? this.unlockedOutfitIds,
      equippedOutfitId: equippedOutfitId ?? this.equippedOutfitId,
      mistakeExerciseIds: mistakeExerciseIds ?? this.mistakeExerciseIds,
      completedStoryIds: completedStoryIds ?? this.completedStoryIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hearts': hearts,
      'gems': gems,
      'streak': streak,
      'totalXp': totalXp,
      'completedLessonIds': completedLessonIds.toList(),
      'streakFreezeCount': streakFreezeCount,
      'lastActiveDate': lastActiveDate?.toIso8601String(),
      'unlockedOutfitIds': unlockedOutfitIds,
      'equippedOutfitId': equippedOutfitId,
      'mistakeExerciseIds': mistakeExerciseIds.toList(),
      'completedStoryIds': completedStoryIds.toList(),
    };
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      hearts: json['hearts'] as int? ?? 5,
      gems: json['gems'] as int? ?? 120,
      streak: json['streak'] as int? ?? 1,
      totalXp: json['totalXp'] as int? ?? 0,
      completedLessonIds: (json['completedLessonIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toSet() ??
          {},
      streakFreezeCount: json['streakFreezeCount'] as int? ?? 1,
      lastActiveDate: json['lastActiveDate'] != null
          ? DateTime.tryParse(json['lastActiveDate'] as String)
          : null,
      unlockedOutfitIds: (json['unlockedOutfitIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['classic'],
      equippedOutfitId: json['equippedOutfitId'] as String? ?? 'classic',
      mistakeExerciseIds: (json['mistakeExerciseIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toSet() ??
          {},
      completedStoryIds: (json['completedStoryIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toSet() ??
          {},
    );
  }
}
