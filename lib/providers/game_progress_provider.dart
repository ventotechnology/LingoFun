import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mascot_outfit.dart';
import '../models/user_progress.dart';
import '../services/audio_feedback_service.dart';
import '../services/curriculum_data.dart';

class GameProgressProvider extends ChangeNotifier {
  static const String _prefsKey = 'lingo_user_progress_v1';

  UserProgress _progress = const UserProgress();
  bool _isLoaded = false;
  String _activeCourseId = 'spanish';

  GameProgressProvider() {
    _loadFromStorage();
  }

  bool get isLoaded => _isLoaded;
  int get hearts => _progress.hearts;
  int get gems => _progress.gems;
  String get activeCourseId => _activeCourseId;

  int get streak => _progress.streak;
  int get totalXp => _progress.totalXp;
  Set<String> get completedLessonIds => _progress.completedLessonIds;
  int get streakFreezeCount => _progress.streakFreezeCount;

  List<String> get unlockedOutfitIds => _progress.unlockedOutfitIds;
  String get equippedOutfitId => _progress.equippedOutfitId;
  Set<String> get mistakeExerciseIds => _progress.mistakeExerciseIds;
  Set<String> get completedStoryIds => _progress.completedStoryIds;

  bool get isSoundEnabled => AudioFeedbackService.isSoundEnabled;

  void toggleSound() {
    AudioFeedbackService.isSoundEnabled = !AudioFeedbackService.isSoundEnabled;
    notifyListeners();
  }

  void switchCourse(String courseId) {
    if (CurriculumData.courses.containsKey(courseId)) {
      _activeCourseId = courseId;
      notifyListeners();
    }
  }

  bool isStoryCompleted(String storyId) {
    return _progress.completedStoryIds.contains(storyId);
  }

  void completeStory(String storyId, int xpReward, int gemReward) {
    final updated = Set<String>.from(_progress.completedStoryIds)..add(storyId);
    _progress = _progress.copyWith(
      completedStoryIds: updated,
      totalXp: _progress.totalXp + xpReward,
      gems: _progress.gems + gemReward,
    );
    _saveToStorage();
    notifyListeners();
  }

  bool isLessonCompleted(String lessonId) {
    return _progress.completedLessonIds.contains(lessonId);
  }

  bool isLessonUnlocked(String lessonId) {
    // First lesson of current course is always unlocked
    final allLessons = CurriculumData.getUnitsForCourse(_activeCourseId).expand((u) => u.lessons).toList();
    if (allLessons.isEmpty) return false;
    if (allLessons.first.id == lessonId) return true;

    final index = allLessons.indexWhere((l) => l.id == lessonId);
    if (index <= 0) return true;

    // A lesson is unlocked if the previous lesson was completed
    final previousLesson = allLessons[index - 1];
    return isLessonCompleted(previousLesson.id);
  }

  void gainGems(int amount) {
    _progress = _progress.copyWith(gems: _progress.gems + amount);
    _saveToStorage();
    notifyListeners();
  }

  void loseHeart() {
    if (_progress.hearts > 0) {
      _progress = _progress.copyWith(hearts: _progress.hearts - 1);
      _saveToStorage();
      notifyListeners();
    }
  }

  void addHeart() {
    if (_progress.hearts < UserProgress.maxHearts) {
      _progress = _progress.copyWith(hearts: _progress.hearts + 1);
      _saveToStorage();
      notifyListeners();
    }
  }

  void refillHearts() {
    _progress = _progress.copyWith(hearts: UserProgress.maxHearts);
    _saveToStorage();
    notifyListeners();
  }

  bool buyHeartRefill() {
    const cost = 100;
    if (_progress.gems >= cost && _progress.hearts < UserProgress.maxHearts) {
      _progress = _progress.copyWith(
        gems: _progress.gems - cost,
        hearts: UserProgress.maxHearts,
      );
      _saveToStorage();
      notifyListeners();
      return true;
    }
    return false;
  }

  bool buyStreakFreeze() {
    const cost = 150;
    if (_progress.gems >= cost) {
      _progress = _progress.copyWith(
        gems: _progress.gems - cost,
        streakFreezeCount: _progress.streakFreezeCount + 1,
      );
      _saveToStorage();
      notifyListeners();
      return true;
    }
    return false;
  }

  // --- Mascot Wardrobe ---

  bool isOutfitUnlocked(String outfitId) {
    return _progress.unlockedOutfitIds.contains(outfitId);
  }

  bool buyOutfit(MascotOutfit outfit) {
    if (isOutfitUnlocked(outfit.id)) return false;
    if (_progress.gems >= outfit.costGems) {
      final updatedOutfits = List<String>.from(_progress.unlockedOutfitIds)..add(outfit.id);
      _progress = _progress.copyWith(
        gems: _progress.gems - outfit.costGems,
        unlockedOutfitIds: updatedOutfits,
        equippedOutfitId: outfit.id,
      );
      _saveToStorage();
      notifyListeners();
      return true;
    }
    return false;
  }

  void equipOutfit(String outfitId) {
    if (_progress.unlockedOutfitIds.contains(outfitId)) {
      _progress = _progress.copyWith(equippedOutfitId: outfitId);
      _saveToStorage();
      notifyListeners();
    }
  }

  // --- Mistakes Notebook ---

  void recordMistake(String exerciseId) {
    final updated = Set<String>.from(_progress.mistakeExerciseIds)..add(exerciseId);
    _progress = _progress.copyWith(mistakeExerciseIds: updated);
    _saveToStorage();
    notifyListeners();
  }

  void resolveMistake(String exerciseId) {
    final updated = Set<String>.from(_progress.mistakeExerciseIds)..remove(exerciseId);
    final newHearts = (_progress.hearts < UserProgress.maxHearts)
        ? _progress.hearts + 1
        : _progress.hearts;
    _progress = _progress.copyWith(
      mistakeExerciseIds: updated,
      hearts: newHearts,
      gems: _progress.gems + 5,
    );
    _saveToStorage();
    notifyListeners();
  }

  void completeLesson(String lessonId, int xpReward) {
    final updatedCompleted = Set<String>.from(_progress.completedLessonIds)
      ..add(lessonId);

    final now = DateTime.now();
    int newStreak = _progress.streak;

    if (_progress.lastActiveDate != null) {
      final diffDays = now.difference(_progress.lastActiveDate!).inDays;
      if (diffDays == 1) {
        newStreak += 1;
      } else if (diffDays > 1) {
        if (_progress.streakFreezeCount > 0) {
          // Use streak freeze
          _progress = _progress.copyWith(
            streakFreezeCount: _progress.streakFreezeCount - 1,
          );
        } else {
          newStreak = 1;
        }
      }
    } else {
      newStreak = 1;
    }

    _progress = _progress.copyWith(
      completedLessonIds: updatedCompleted,
      totalXp: _progress.totalXp + xpReward,
      gems: _progress.gems + 15, // reward 15 gems per lesson
      streak: newStreak,
      lastActiveDate: now,
    );

    _saveToStorage();
    notifyListeners();
  }

  void skipAheadToUnit(int targetUnitIndex) {
    final allUnits = CurriculumData.getUnitsForCourse(_activeCourseId);
    if (targetUnitIndex <= 0 || targetUnitIndex >= allUnits.length) return;

    final updatedCompleted = Set<String>.from(_progress.completedLessonIds);
    for (int i = 0; i < targetUnitIndex; i++) {
      for (final lesson in allUnits[i].lessons) {
        updatedCompleted.add(lesson.id);
      }
    }
    
    // Give them some XP for skipping ahead
    final xpReward = targetUnitIndex * 50;
    
    _progress = _progress.copyWith(
      completedLessonIds: updatedCompleted,
      totalXp: _progress.totalXp + xpReward,
    );
    _saveToStorage();
    notifyListeners();
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_prefsKey);
      if (jsonString != null) {
        final map = jsonDecode(jsonString) as Map<String, dynamic>;
        _progress = UserProgress.fromJson(map);
      }
    } catch (e) {
      debugPrint('Error loading progress: $e');
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, jsonEncode(_progress.toJson()));
    } catch (e) {
      debugPrint('Error saving progress: $e');
    }
  }

  void resetAllProgress() {
    _progress = const UserProgress();
    _saveToStorage();
    notifyListeners();
  }
}
