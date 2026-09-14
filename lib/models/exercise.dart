enum ExerciseType {
  multipleChoice,
  sentenceBuilder,
  matchingPairs,
  fillInBlank,
  speaking,
}

abstract class Exercise {
  final String id;
  final ExerciseType type;
  final String prompt;
  final String? speakerText;

  const Exercise({
    required this.id,
    required this.type,
    required this.prompt,
    this.speakerText,
  });
}

class SpeakingExercise extends Exercise {
  final String targetPhrase;
  final String translation;
  final List<String> targetWords;

  const SpeakingExercise({
    required super.id,
    required super.prompt,
    required this.targetPhrase,
    required this.translation,
    required this.targetWords,
    super.speakerText,
  }) : super(type: ExerciseType.speaking);
}

class MultipleChoiceExercise extends Exercise {
  final String question;
  final List<String> options;
  final List<String>? optionIcons;
  final int correctIndex;

  const MultipleChoiceExercise({
    required super.id,
    required super.prompt,
    required this.question,
    required this.options,
    this.optionIcons,
    required this.correctIndex,
    super.speakerText,
  }) : super(type: ExerciseType.multipleChoice);
}

class SentenceBuilderExercise extends Exercise {
  final String sentenceToTranslate;
  final List<String> correctSequence;
  final List<String> tokenBank;

  const SentenceBuilderExercise({
    required super.id,
    required super.prompt,
    required this.sentenceToTranslate,
    required this.correctSequence,
    required this.tokenBank,
    super.speakerText,
  }) : super(type: ExerciseType.sentenceBuilder);
}

class MatchingPairExercise extends Exercise {
  final Map<String, String> pairs; // e.g. {'Hola': 'Hello', 'Agua': 'Water'}

  const MatchingPairExercise({
    required super.id,
    required super.prompt,
    required this.pairs,
  }) : super(type: ExerciseType.matchingPairs);
}

class FillInBlankExercise extends Exercise {
  final String prefix;
  final String blankAnswer;
  final String suffix;
  final List<String> options;

  const FillInBlankExercise({
    required super.id,
    required super.prompt,
    required this.prefix,
    required this.blankAnswer,
    required this.suffix,
    required this.options,
    super.speakerText,
  }) : super(type: ExerciseType.fillInBlank);
}
