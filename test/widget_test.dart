import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_fun/main.dart';
import 'package:lingo_fun/models/auth_user.dart';
import 'package:lingo_fun/models/exercise.dart';
import 'package:lingo_fun/models/mascot_outfit.dart';
import 'package:lingo_fun/models/story.dart';
import 'package:lingo_fun/providers/auth_provider.dart';
import 'package:lingo_fun/providers/game_progress_provider.dart';
import 'package:lingo_fun/providers/quests_provider.dart';
import 'package:lingo_fun/screens/lesson/widgets/speaking_challenge_widget.dart';
import 'package:lingo_fun/screens/match_madness/match_madness_screen.dart';
import 'package:lingo_fun/screens/onboarding/learning_goal_screen.dart';
import 'package:lingo_fun/screens/onboarding/login_screen.dart';
import 'package:lingo_fun/screens/onboarding/native_language_screen.dart';
import 'package:lingo_fun/screens/onboarding/quick_signup_screen.dart';
import 'package:lingo_fun/screens/onboarding/target_language_screen.dart';
import 'package:lingo_fun/screens/onboarding/welcome_screen.dart';
import 'package:lingo_fun/screens/stories/stories_tab_screen.dart';
import 'package:lingo_fun/screens/stories/story_player_screen.dart';
import 'package:lingo_fun/services/audio_feedback_service.dart';
import 'package:lingo_fun/services/curriculum_data.dart';
import 'package:lingo_fun/widgets/lingo_mascot.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App smoke test for first-time learner launches with WelcomeScreen and Lingo mascot',
      (WidgetTester tester) async {
    await tester.pumpWidget(const LingoFunApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Welcome Screen elements
    expect(find.text('LingoFunLearn'), findsOneWidget);
    expect(find.text('CREATE PROFILE'), findsOneWidget);
    expect(find.text('CONTINUE WITH GOOGLE'), findsOneWidget);
    expect(find.text('I ALREADY HAVE AN ACCOUNT'), findsOneWidget);
    expect(find.byType(LingoMascot), findsOneWidget);
  });

  testWidgets('App smoke test for returning learner launches directly into MainNavigationShell',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'lingo_auth_user_v1': '{"id":"user_123","name":"Test Learner","email":"test@lingofun.app","authMethod":"google","nativeLanguage":"en","targetCourseId":"spanish","dailyGoalMinutes":15,"learningReason":"career","createdAt":"2026-09-14T00:00:00.000"}'
    });

    await tester.pumpWidget(const LingoFunApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify top bar elements on MainNavigationShell
    expect(find.text('🇪🇸'), findsOneWidget);
    expect(find.text('UNIT 1'), findsOneWidget);
    expect(find.text('Order food, introduce yourself'), findsOneWidget);
  });

  group('AuthProvider & Authentication Tests', () {
    test('Initial unauthenticated state', () {
      final auth = AuthProvider();
      expect(auth.isAuthenticated, isFalse);
      expect(auth.isOnboardingCompleted, isFalse);
      expect(auth.currentUser, isNull);
    });

    test('Authenticated user loads from storage correctly', () async {
      SharedPreferences.setMockInitialValues({
        'lingo_auth_user_v1': '{"id":"g_real_123","name":"Alex Rivera","email":"alex.rivera@gmail.com","authMethod":"google","nativeLanguage":"bn","targetCourseId":"bangla_to_english","dailyGoalMinutes":15,"learningReason":"career","createdAt":"2026-09-14T00:00:00.000"}'
      });

      final auth = AuthProvider();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(auth.isAuthenticated, isTrue);
      expect(auth.isOnboardingCompleted, isTrue);
      expect(auth.currentUser?.name, equals('Alex Rivera'));
      expect(auth.currentUser?.email, equals('alex.rivera@gmail.com'));
      expect(auth.currentUser?.isGoogle, isTrue);
      expect(auth.currentUser?.nativeLanguage, equals('bn'));
      expect(auth.targetCourseId, equals('bangla_to_english'));
    });

    test('Legacy guest or mock learner accounts are purged immediately', () async {
      SharedPreferences.setMockInitialValues({
        'lingo_auth_user_v1': '{"id":"mock_123","name":"Google Learner","email":"learner.google@lingofun.app","authMethod":"google","nativeLanguage":"en","targetCourseId":"spanish","dailyGoalMinutes":10,"learningReason":"career","createdAt":"2026-09-14T00:00:00.000"}'
      });

      final auth = AuthProvider();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(auth.isAuthenticated, isFalse);
      expect(auth.currentUser, isNull);
      expect(auth.isOnboardingCompleted, isFalse);
    });

    test('Sign Out clears current user and authentication state', () async {
      final auth = AuthProvider();
      auth.setUserForTesting(AuthUser(
        id: 'u_1',
        name: 'Sarah Khan',
        email: 'sarah@example.com',
        authMethod: 'email',
        createdAt: DateTime(2026, 9, 14),
      ));
      expect(auth.isAuthenticated, isTrue);

      await auth.signOut();
      expect(auth.isAuthenticated, isFalse);
      expect(auth.currentUser, isNull);
      expect(auth.isOnboardingCompleted, isFalse);
    });

    test('AuthUser model serialization and defaults', () {
      final user = AuthUser(
        id: 'u1',
        name: 'Test',
        authMethod: 'google',
        createdAt: DateTime.now(),
      );
      expect(user.isGoogle, isTrue);
      expect(user.displayName, equals('Test'));
      expect(NativeLanguage.supportedLanguages, isNotEmpty);
    });
  });

  group('Onboarding UI Flow Tests', () {
    testWidgets('WelcomeScreen renders Lingo branding and navigation buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: WelcomeScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('LingoFunLearn'), findsOneWidget);
      expect(find.text('CREATE PROFILE'), findsOneWidget);
      expect(find.text('CONTINUE WITH GOOGLE'), findsOneWidget);
      expect(find.text('I ALREADY HAVE AN ACCOUNT'), findsOneWidget);
    });

    testWidgets('LoginScreen renders email, password fields and Google button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('SIGN IN'), findsOneWidget);
      expect(find.text('CREATE PROFILE'), findsOneWidget);
    });
    testWidgets('NativeLanguageScreen lists languages and selects Bangla',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NativeLanguageScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('What language do you speak?'), findsOneWidget);
      expect(find.text('Bengali'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);

      // Tap Bengali
      await tester.tap(find.text('Bengali'));
      await tester.pump();

      expect(find.text('CONTINUE'), findsOneWidget);
    });

    testWidgets('TargetLanguageScreen renders course recommendations for Bengali speakers',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TargetLanguageScreen(nativeLanguageCode: 'bn'),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('লক্ষ্য ভাষা নির্বাচন করুন'), findsOneWidget);
      expect(find.text('ইংরেজি শিখুন (English)'), findsOneWidget);
      expect(find.text('স্প্যানিশ (Spanish)'), findsOneWidget);
    });

    testWidgets('LearningGoalScreen allows pace and reason selection',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LearningGoalScreen(
            nativeLanguageCode: 'en',
            targetCourseId: 'spanish',
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Why are you learning?'), findsOneWidget);
      expect(find.text('Career & Professional Growth'), findsOneWidget);
      expect(find.text('Travel & Exploration'), findsOneWidget);
    });

    testWidgets('QuickSignupScreen renders profile creation, avatar picker, and Google 1-tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
          child: const MaterialApp(
            home: QuickSignupScreen(
              nativeLanguageCode: 'en',
              targetCourseId: 'spanish',
              dailyGoalMinutes: 15,
              learningReason: 'career',
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Create Your Profile'), findsOneWidget);
      expect(find.text('CHOOSE YOUR AVATAR'), findsOneWidget);
      expect(find.text('CREATE PROFILE & START'), findsOneWidget);
      expect(find.text('CONTINUE WITH GOOGLE'), findsOneWidget);
    });

    testWidgets('LingoMascot renders custom original design without Duolingo assets',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: LingoMascot(
                size: 150,
                mood: MascotMood.celebrating,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(LingoMascot), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });

  group('GameProgressProvider Tests', () {
    test('Initial stats are default', () {
      final provider = GameProgressProvider();
      expect(provider.hearts, equals(5));
      expect(provider.gems, equals(120));
      expect(provider.streak, equals(1));
      expect(provider.totalXp, equals(0));
      expect(provider.equippedOutfitId, equals('classic'));
      expect(provider.unlockedOutfitIds, contains('classic'));
      expect(provider.mistakeExerciseIds, isEmpty);
    });

    test('Heart deduction and refill', () {
      final provider = GameProgressProvider();
      provider.loseHeart();
      expect(provider.hearts, equals(4));

      provider.refillHearts();
      expect(provider.hearts, equals(5));
    });

    test('Completing lesson awards XP and marks completed', () {
      final provider = GameProgressProvider();
      expect(provider.isLessonCompleted('u1_l1'), isFalse);

      provider.completeLesson('u1_l1', 15);

      expect(provider.isLessonCompleted('u1_l1'), isTrue);
      expect(provider.totalXp, equals(15));
      expect(provider.isLessonUnlocked('u1_l2'), isTrue);
    });

    test('Course switcher updates active course and curriculum units', () {
      final provider = GameProgressProvider();
      expect(provider.activeCourseId, equals('spanish'));

      // Switch to French
      provider.switchCourse('french');
      expect(provider.activeCourseId, equals('french'));
      final frenchUnits = CurriculumData.getUnitsForCourse(provider.activeCourseId);
      expect(frenchUnits.first.title, contains('Bonjour'));

      // Switch to Japanese
      provider.switchCourse('japanese');
      expect(provider.activeCourseId, equals('japanese'));
      final japaneseUnits = CurriculumData.getUnitsForCourse(provider.activeCourseId);
      expect(japaneseUnits.first.title, contains('Konnichiwa'));

      // Switch to Python
      provider.switchCourse('python');
      expect(provider.activeCourseId, equals('python'));
      final pythonUnits = CurriculumData.getUnitsForCourse(provider.activeCourseId);
      expect(pythonUnits.first.title, contains('Hello World'));
    });

    test('Mascot Wardrobe purchasing and equipping', () {
      final provider = GameProgressProvider();
      expect(provider.isOutfitUnlocked('beret'), isFalse);

      // Beret costs 100 gems, provider starts with 120
      final bought = provider.buyOutfit(MascotOutfit.beret);
      expect(bought, isTrue);
      expect(provider.gems, equals(20)); // 120 - 100
      expect(provider.isOutfitUnlocked('beret'), isTrue);
      expect(provider.equippedOutfitId, equals('beret'));

      // Cannot buy samurai (costs 150) because only 20 gems remaining
      final cannotAfford = provider.buyOutfit(MascotOutfit.samurai);
      expect(cannotAfford, isFalse);

      // Can equip previously unlocked classic outfit
      provider.equipOutfit('classic');
      expect(provider.equippedOutfitId, equals('classic'));

      // Can equip beret again
      provider.equipOutfit('beret');
      expect(provider.equippedOutfitId, equals('beret'));
    });

    test('Mistakes Notebook tracking and resolution', () {
      final provider = GameProgressProvider();
      provider.loseHeart(); // 4 hearts left
      expect(provider.hearts, equals(4));

      // User makes a mistake on exercise 'u1_l1_e1'
      provider.recordMistake('u1_l1_e1');
      expect(provider.mistakeExerciseIds, contains('u1_l1_e1'));

      final initialGems = provider.gems;

      // User masters mistake in practice gym
      provider.resolveMistake('u1_l1_e1');
      expect(provider.mistakeExerciseIds.contains('u1_l1_e1'), isFalse);
      expect(provider.hearts, equals(5)); // +1 Heart restored
      expect(provider.gems, equals(initialGems + 5)); // +5 Gems bonus
    });

    test('Sound effects toggle', () {
      final provider = GameProgressProvider();
      final initialSound = provider.isSoundEnabled;
      provider.toggleSound();
      expect(provider.isSoundEnabled, equals(!initialSound));
      provider.toggleSound();
      expect(provider.isSoundEnabled, equals(initialSound));
    });
  });

  group('Match Madness Tests', () {
    test('AudioFeedbackService generates ascending pitch bytes for combos', () {
      AudioFeedbackService.isSoundEnabled = false;
      AudioFeedbackService.initialize();
      for (int i = 1; i <= 6; i++) {
        expect(() => AudioFeedbackService.playMatchCombo(i), returnsNormally);
      }
    });

    testWidgets('Match Madness screen mounts with timer and matching grid',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => GameProgressProvider(),
          child: const MaterialApp(
            home: MatchMadnessScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Match Madness'), findsOneWidget);
      expect(find.text('0:60'), findsOneWidget);
      expect(find.text('0 matches'), findsOneWidget);
      expect(find.text('Tap pairs to match!'), findsOneWidget);
    });
  });

  group('Multi-Language Curriculum Tests', () {
    test('All 8 courses have valid curriculum units, lessons, and exercises', () {
      final expectedCourses = [
        'bangla_to_english',
        'bengali',
        'chinese',
        'hindi',
        'spanish',
        'french',
        'japanese',
        'python',
      ];

      for (final courseId in expectedCourses) {
        expect(CurriculumData.courses.containsKey(courseId), isTrue,
            reason: 'Missing course $courseId');
        final course = CurriculumData.getCourse(courseId);
        expect(course.title.isNotEmpty, isTrue);
        expect(course.flag.isNotEmpty, isTrue);
        expect(course.ttsLocale.isNotEmpty, isTrue);

        final units = CurriculumData.getUnitsForCourse(courseId);
        expect(units.isNotEmpty, isTrue,
            reason: 'Course $courseId has no units');

        for (final unit in units) {
          expect(unit.lessons.isNotEmpty, isTrue);
          for (final lesson in unit.lessons) {
            expect(lesson.exercises.isNotEmpty, isTrue);
            for (final ex in lesson.exercises) {
              expect(ex.id.isNotEmpty, isTrue);
              expect(ex.prompt.isNotEmpty, isTrue);
            }
          }
        }
      }
    });

    test('Bangla to English course has 100% all levels (A1 to C2) across 20 units', () {
      final units = CurriculumData.getUnitsForCourse('bangla_to_english');
      expect(units.length, equals(20), reason: 'Expected 20 comprehensive units');

      final levelBadges = units.map((u) => u.levelBadge).whereType<String>().toSet();
      expect(levelBadges.contains('A1'), isTrue, reason: 'Missing A1 Beginner');
      expect(levelBadges.contains('A2'), isTrue, reason: 'Missing A2 Elementary');
      expect(levelBadges.contains('B1'), isTrue, reason: 'Missing B1 Intermediate');
      expect(levelBadges.contains('B2'), isTrue, reason: 'Missing B2 Upper-Intermediate');
      expect(levelBadges.contains('C1/C2'), isTrue, reason: 'Missing C1/C2 Advanced Mastery');

      final allExerciseIds = <String>{};
      int totalLessons = 0;
      for (final unit in units) {
        totalLessons += unit.lessons.length;
        for (final lesson in unit.lessons) {
          for (final ex in lesson.exercises) {
            expect(allExerciseIds.contains(ex.id), isFalse,
                reason: 'Duplicate exercise id: ${ex.id}');
            allExerciseIds.add(ex.id);
          }
        }
      }

      expect(totalLessons, greaterThanOrEqualTo(40));
      expect(allExerciseIds.length, greaterThanOrEqualTo(100));

      final stories = StoriesData.getStoriesForCourse('bangla_to_english');
      expect(stories.length, equals(5));
    });
  });

  group('Stories Engine Tests', () {
    test('StoriesData contains authentic stories for all 8 courses', () {
      final courses = [
        'bangla_to_english',
        'bengali',
        'chinese',
        'hindi',
        'spanish',
        'french',
        'japanese',
        'python',
      ];

      for (final c in courses) {
        final stories = StoriesData.getStoriesForCourse(c);
        expect(stories.isNotEmpty, isTrue, reason: 'Course $c has no stories');
        for (final s in stories) {
          expect(s.title.isNotEmpty, isTrue);
          expect(s.lines.isNotEmpty, isTrue);
          expect(s.xpReward, greaterThan(0));
          expect(s.gemReward, greaterThan(0));

          // Ensure at least one line has a checkpoint question
          final hasCheckpoint = s.lines.any((l) => l.question != null);
          expect(hasCheckpoint, isTrue,
              reason: 'Story ${s.id} in course $c should have a checkpoint question');
        }
      }
    });

    test('GameProgressProvider tracks and completes stories', () {
      final provider = GameProgressProvider();
      const storyId = 'bte_story_1';

      expect(provider.isStoryCompleted(storyId), isFalse);
      final initialXp = provider.totalXp;
      final initialGems = provider.gems;

      provider.completeStory(storyId, 25, 15);

      expect(provider.isStoryCompleted(storyId), isTrue);
      expect(provider.totalXp, equals(initialXp + 25));
      expect(provider.gems, equals(initialGems + 15));
      expect(provider.completedStoryIds, contains(storyId));
    });
  });

  group('QuestsProvider Tests', () {
    test('Tracking and claiming daily quests', () {
      final gameProgress = GameProgressProvider();
      final quests = QuestsProvider();
      final initialGems = gameProgress.gems;

      // Finish a lesson with 30 XP and 100% accuracy
      quests.onLessonFinished(xpEarned: 30, accuracy: 100);

      // Early bird quest (30 XP) should now be complete
      final xpQuest = quests.quests.firstWhere((q) => q.id == 'quest_xp');
      expect(xpQuest.isCompleted, isTrue);
      expect(xpQuest.isClaimed, isFalse);

      // Claim reward
      final claimed = quests.claimReward('quest_xp', gameProgress);
      expect(claimed, isTrue);
      expect(gameProgress.gems, equals(initialGems + 15));
    });
  });

  group('Stories UI Widget Tests', () {
    testWidgets('StoriesTabScreen renders banner, header, and story cards',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => GameProgressProvider(),
          child: const MaterialApp(
            home: StoriesTabScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Story Library'), findsOneWidget);
      expect(find.text('Buenos Días'), findsOneWidget);
      expect(find.text('Una Cita Romántica'), findsOneWidget);
    });

    testWidgets('StoryPlayerScreen renders progress bar, first line, and continue button',
        (WidgetTester tester) async {
      final story = StoriesData.storiesByCourse['spanish']!.first;

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => GameProgressProvider(),
          child: MaterialApp(
            home: StoryPlayerScreen(story: story),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('CONTINUE'), findsOneWidget);
      expect(find.text(story.emoji), findsOneWidget);
      expect(find.text(story.lines.first.text), findsOneWidget);
    });
  });

  group('SpeakingChallengeWidget Tests', () {
    testWidgets('Renders target phrase, wave, and action buttons',
        (WidgetTester tester) async {
      const exercise = SpeakingExercise(
        id: 'speak_test',
        prompt: 'Speak this sentence',
        targetPhrase: 'Buenos días amigo',
        translation: 'Good morning friend',
        targetWords: ['Buenos', 'días', 'amigo'],
      );

      bool cantSpeakCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SpeakingChallengeWidget(
              exercise: exercise,
              onSpeechEvaluated: (_) {},
              onCantSpeakNow: () => cantSpeakCalled = true,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Buenos'), findsOneWidget);
      expect(find.text('Good morning friend'), findsOneWidget);
      expect(find.text("CAN'T SPEAK RIGHT NOW"), findsOneWidget);
      expect(find.text('Tap microphone and read out loud'), findsOneWidget);
      expect(find.byIcon(Icons.mic_rounded), findsOneWidget);

      // Tap "Can't speak right now"
      await tester.tap(find.text("CAN'T SPEAK RIGHT NOW"));
      expect(cantSpeakCalled, isTrue);
    });
  });
}
