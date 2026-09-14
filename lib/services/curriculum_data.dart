import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/lesson.dart';
import '../theme/app_colors.dart';

class CurriculumData {
  static final List<Unit> units = [
    // UNIT 1: BASICS
    Unit(
      id: 'unit_1',
      unitNumber: 1,
      title: 'Order food, introduce yourself',
      description: 'Master essential Spanish words for food, greetings & drinks!',
      themeColor: AppColors.green,
      lessons: [
        Lesson(
          id: 'u1_l1',
          title: 'Food & Drinks',
          description: 'Learn bread, water, apple and milk',
          icon: Icons.restaurant_rounded,
          xpReward: 15,
          exercises: [
            const MultipleChoiceExercise(
              id: 'u1_l1_e1',
              prompt: 'Select the right translation for "Bread":',
              question: 'El pan',
              options: ['🍞 Bread', '🍎 Apple', '🥛 Milk'],
              correctIndex: 0,
              speakerText: 'El pan',
            ),
            const SentenceBuilderExercise(
              id: 'u1_l1_e2',
              prompt: 'Translate this sentence into English:',
              sentenceToTranslate: 'Yo como manzana',
              correctSequence: ['I', 'eat', 'an', 'apple'],
              tokenBank: ['I', 'eat', 'an', 'apple', 'bread', 'drinks', 'water'],
              speakerText: 'Yo como manzana',
            ),
            const MatchingPairExercise(
              id: 'u1_l1_e3',
              prompt: 'Tap the matching pairs:',
              pairs: {
                'El agua': 'Water',
                'El pan': 'Bread',
                'La manzana': 'Apple',
                'La leche': 'Milk',
              },
            ),
            const FillInBlankExercise(
              id: 'u1_l1_e4',
              prompt: 'Complete the sentence:',
              prefix: 'Yo bebo ',
              blankAnswer: 'agua',
              suffix: ' todos los días.',
              options: ['agua', 'libro', 'perro'],
              speakerText: 'Yo bebo agua todos los días.',
            ),
          ],
        ),
        Lesson(
          id: 'u1_l2',
          title: 'Greetings & Politeness',
          description: 'Say hello, goodbye, please and thank you',
          icon: Icons.waving_hand_rounded,
          xpReward: 15,
          exercises: [
            const MultipleChoiceExercise(
              id: 'u1_l2_e1',
              prompt: 'How do you say "Thank you" in Spanish?',
              question: 'Thank you',
              options: ['Gracias', 'Hola', 'Por favor'],
              correctIndex: 0,
              speakerText: 'Gracias',
            ),
            const SentenceBuilderExercise(
              id: 'u1_l2_e2',
              prompt: 'Translate this sentence:',
              sentenceToTranslate: 'Hola, buenos días',
              correctSequence: ['Hello,', 'good', 'morning'],
              tokenBank: ['Hello,', 'good', 'morning', 'night', 'please', 'thanks'],
              speakerText: 'Hola, buenos días',
            ),
            const MatchingPairExercise(
              id: 'u1_l2_e3',
              prompt: 'Tap the matching pairs:',
              pairs: {
                'Hola': 'Hello',
                'Gracias': 'Thank you',
                'Adiós': 'Goodbye',
                'Por favor': 'Please',
              },
            ),
            const FillInBlankExercise(
              id: 'u1_l2_e4',
              prompt: 'Complete the polite phrase:',
              prefix: 'Muchas ',
              blankAnswer: 'gracias',
              suffix: ' por tu ayuda.',
              options: ['gracias', 'noche', 'pan'],
              speakerText: 'Muchas gracias por tu ayuda.',
            ),
          ],
        ),
        Lesson(
          id: 'u1_l3',
          title: 'Introductions',
          description: 'Introduce your name and ask how someone is',
          icon: Icons.person_rounded,
          xpReward: 20,
          exercises: [
            const MultipleChoiceExercise(
              id: 'u1_l3_e1',
              prompt: 'What does "¿Cómo estás?" mean?',
              question: '¿Cómo estás?',
              options: ['How are you?', 'What is your name?', 'Where are you from?'],
              correctIndex: 0,
              speakerText: '¿Cómo estás?',
            ),
            const SentenceBuilderExercise(
              id: 'u1_l3_e2',
              prompt: 'Translate into Spanish:',
              sentenceToTranslate: 'My name is Alex',
              correctSequence: ['Me', 'llamo', 'Alex'],
              tokenBank: ['Me', 'llamo', 'Alex', 'Yo', 'estoy', 'bien'],
            ),
            const MatchingPairExercise(
              id: 'u1_l3_e3',
              prompt: 'Match the conversational phrases:',
              pairs: {
                'Muy bien': 'Very well',
                '¿Y tú?': 'And you?',
                'Mucho gusto': 'Nice to meet you',
                'De nada': "You're welcome",
              },
            ),
          ],
        ),
      ],
    ),

    // UNIT 2: AT THE CAFÉ & NUMBERS
    Unit(
      id: 'unit_2',
      unitNumber: 2,
      title: 'Order at a café, count 1 to 5',
      description: 'Ask for coffee, tea, and pay the bill like a local!',
      themeColor: AppColors.blue,
      lessons: [
        Lesson(
          id: 'u2_l1',
          title: 'At the Café',
          description: 'Order coffee and ask for the bill',
          icon: Icons.coffee_rounded,
          xpReward: 15,
          exercises: [
            const MultipleChoiceExercise(
              id: 'u2_l1_e1',
              prompt: 'Translate "A coffee with milk":',
              question: 'Un café con leche',
              options: ['☕ A coffee with milk', '🍵 A green tea', '🥪 A sandwich'],
              correctIndex: 0,
              speakerText: 'Un café con leche',
            ),
            const SentenceBuilderExercise(
              id: 'u2_l1_e2',
              prompt: 'Translate into English:',
              sentenceToTranslate: 'La cuenta, por favor',
              correctSequence: ['The', 'check,', 'please'],
              tokenBank: ['The', 'check,', 'please', 'coffee', 'table', 'menu'],
              speakerText: 'La cuenta, por favor',
            ),
            const MatchingPairExercise(
              id: 'u2_l1_e3',
              prompt: 'Match the café terms:',
              pairs: {
                'El café': 'Coffee',
                'El té': 'Tea',
                'La cuenta': 'The bill/check',
                'El azúcar': 'Sugar',
              },
            ),
          ],
        ),
        Lesson(
          id: 'u2_l2',
          title: 'Numbers 1 to 5',
          description: 'Count items and quantities',
          icon: Icons.pin_outlined,
          xpReward: 15,
          exercises: [
            const MatchingPairExercise(
              id: 'u2_l2_e1',
              prompt: 'Match the Spanish numbers:',
              pairs: {
                'Uno': 'One (1)',
                'Dos': 'Two (2)',
                'Tres': 'Three (3)',
                'Cuatro': 'Four (4)',
                'Cinco': 'Five (5)',
              },
            ),
            const SentenceBuilderExercise(
              id: 'u2_l2_e2',
              prompt: 'Translate into English:',
              sentenceToTranslate: 'Dos cafés, por favor',
              correctSequence: ['Two', 'coffees,', 'please'],
              tokenBank: ['Two', 'coffees,', 'please', 'One', 'tea', 'three'],
              speakerText: 'Dos cafés, por favor',
            ),
          ],
        ),
        Lesson(
          id: 'u2_l3',
          title: 'Unit 2 Trophy Review',
          description: 'Show off what you learned in Unit 2!',
          icon: Icons.emoji_events_rounded,
          xpReward: 25,
          exercises: [
            const FillInBlankExercise(
              id: 'u2_l3_e1',
              prompt: 'Order two coffees:',
              prefix: 'Quiero ',
              blankAnswer: 'dos',
              suffix: ' cafés con leche.',
              options: ['dos', 'adiós', 'pan'],
              speakerText: 'Quiero dos cafés con leche.',
            ),
            const MatchingPairExercise(
              id: 'u2_l3_e2',
              prompt: 'Speed match test:',
              pairs: {
                'Café': 'Coffee',
                'Agua': 'Water',
                'Uno': 'One',
                'Gracias': 'Thanks',
              },
            ),
          ],
        ),
      ],
    ),

    // UNIT 3: ANIMALS & COLORS
    Unit(
      id: 'unit_3',
      unitNumber: 3,
      title: 'Animals and bright colors',
      description: 'Describe playful pets and your favorite colors!',
      themeColor: AppColors.purple,
      lessons: [
        Lesson(
          id: 'u3_l1',
          title: 'Cute Animals',
          description: 'Dog, cat, bird, and horse',
          icon: Icons.pets_rounded,
          xpReward: 15,
          exercises: [
            const MultipleChoiceExercise(
              id: 'u3_l1_e1',
              prompt: 'Which one is "The Cat"?',
              question: 'El gato',
              options: ['🐱 The Cat', '🐶 The Dog', '🐴 The Horse'],
              correctIndex: 0,
              speakerText: 'El gato',
            ),
            const MatchingPairExercise(
              id: 'u3_l1_e2',
              prompt: 'Match the animals:',
              pairs: {
                'El perro': 'Dog',
                'El gato': 'Cat',
                'El pájaro': 'Bird',
                'El caballo': 'Horse',
              },
            ),
            const SentenceBuilderExercise(
              id: 'u3_l1_e3',
              prompt: 'Translate into English:',
              sentenceToTranslate: 'El perro es grande',
              correctSequence: ['The', 'dog', 'is', 'big'],
              tokenBank: ['The', 'dog', 'is', 'big', 'small', 'cat', 'red'],
              speakerText: 'El perro es grande',
            ),
          ],
        ),
        Lesson(
          id: 'u3_l2',
          title: 'Vibrant Colors',
          description: 'Red, blue, green, yellow',
          icon: Icons.palette_rounded,
          xpReward: 15,
          exercises: [
            const MatchingPairExercise(
              id: 'u3_l2_e1',
              prompt: 'Match the colors:',
              pairs: {
                'Rojo': 'Red',
                'Azul': 'Blue',
                'Verde': 'Green',
                'Amarillo': 'Yellow',
              },
            ),
            const MultipleChoiceExercise(
              id: 'u3_l2_e2',
              prompt: 'What color is "Azul"?',
              question: 'Azul',
              options: ['🔵 Blue', '🔴 Red', '🟢 Green'],
              correctIndex: 0,
              speakerText: 'Azul',
            ),
          ],
        ),
        Lesson(
          id: 'u3_l3',
          title: 'Unit 3 Master Challenge',
          description: 'Combine animals, colors & sentences!',
          icon: Icons.military_tech_rounded,
          xpReward: 30,
          exercises: [
            const SentenceBuilderExercise(
              id: 'u3_l3_e1',
              prompt: 'Translate into Spanish:',
              sentenceToTranslate: 'The red bird',
              correctSequence: ['El', 'pájaro', 'rojo'],
              tokenBank: ['El', 'pájaro', 'rojo', 'azul', 'gato', 'es'],
            ),
            const FillInBlankExercise(
              id: 'u3_l3_e2',
              prompt: 'Complete:',
              prefix: 'Mi gato es ',
              blankAnswer: 'negro',
              suffix: ' y blanco.',
              options: ['negro', 'agua', 'pan'],
              speakerText: 'Mi gato es negro y blanco.',
            ),
          ],
        ),
      ],
    ),
  ];

  // FRENCH COURSE
  static final List<Unit> frenchUnits = [
    Unit(
      id: 'fr_unit_1',
      unitNumber: 1,
      title: 'Bonjour! Salutations & Café',
      description: 'Master French greetings, politeness and bakery orders!',
      themeColor: AppColors.blue,
      lessons: [
        Lesson(
          id: 'fr_u1_l1',
          title: 'Greetings & Politeness',
          description: 'Say hello, goodbye, and thank you in French',
          icon: Icons.waving_hand_rounded,
          xpReward: 15,
          exercises: [
            const MultipleChoiceExercise(
              id: 'fr_u1_l1_e1',
              prompt: 'How do you say "Hello" in French?',
              question: 'Bonjour',
              options: ['👋 Hello / Good day', '👋 Goodbye', '🙏 Thank you'],
              correctIndex: 0,
              speakerText: 'Bonjour',
            ),
            const SentenceBuilderExercise(
              id: 'fr_u1_l1_e2',
              prompt: 'Translate into English:',
              sentenceToTranslate: 'Bonjour, comment ça va ?',
              correctSequence: ['Hello,', 'how', 'are', 'you?'],
              tokenBank: ['Hello,', 'how', 'are', 'you?', 'good', 'thanks', 'night'],
              speakerText: 'Bonjour, comment ça va ?',
            ),
            const MatchingPairExercise(
              id: 'fr_u1_l1_e3',
              prompt: 'Tap the matching French pairs:',
              pairs: {
                'Bonjour': 'Hello',
                'Merci': 'Thank you',
                'Au revoir': 'Goodbye',
                'S\'il vous plaît': 'Please',
              },
            ),
            const FillInBlankExercise(
              id: 'fr_u1_l1_e4',
              prompt: 'Complete the polite phrase:',
              prefix: 'Merci ',
              blankAnswer: 'beaucoup',
              suffix: ', mon ami.',
              options: ['beaucoup', 'pain', 'chat'],
              speakerText: 'Merci beaucoup, mon ami.',
            ),
          ],
        ),
        Lesson(
          id: 'fr_u1_l2',
          title: 'At the Boulangerie',
          description: 'Order croissants, baguettes, and coffee',
          icon: Icons.bakery_dining_rounded,
          xpReward: 20,
          exercises: [
            const MultipleChoiceExercise(
              id: 'fr_u1_l2_e1',
              prompt: 'Translate "A croissant, please":',
              question: 'Un croissant, s\'il vous plaît',
              options: ['🥐 A croissant, please', '🥖 A baguette, please', '☕ A coffee, please'],
              correctIndex: 0,
              speakerText: 'Un croissant, s\'il vous plaît',
            ),
            const MatchingPairExercise(
              id: 'fr_u1_l2_e2',
              prompt: 'Match the bakery items:',
              pairs: {
                'Le pain': 'Bread',
                'Le café': 'Coffee',
                'Le croissant': 'Croissant',
                'L\'eau': 'Water',
              },
            ),
            const SentenceBuilderExercise(
              id: 'fr_u1_l2_e3',
              prompt: 'Translate into English:',
              sentenceToTranslate: 'Deux cafés, s\'il vous plaît',
              correctSequence: ['Two', 'coffees,', 'please'],
              tokenBank: ['Two', 'coffees,', 'please', 'One', 'croissant', 'tea'],
              speakerText: 'Deux cafés, s\'il vous plaît',
            ),
          ],
        ),
      ],
    ),
  ];

  // JAPANESE COURSE
  static final List<Unit> japaneseUnits = [
    Unit(
      id: 'jp_unit_1',
      unitNumber: 1,
      title: 'Konnichiwa & Essentials',
      description: 'First Japanese greetings, polite phrases & daily words!',
      themeColor: AppColors.red,
      lessons: [
        Lesson(
          id: 'jp_u1_l1',
          title: 'Greetings & Politeness',
          description: 'Konnichiwa, Arigatou, Sayounara',
          icon: Icons.chat_bubble_outline_rounded,
          xpReward: 15,
          exercises: [
            const MultipleChoiceExercise(
              id: 'jp_u1_l1_e1',
              prompt: 'What does "こんにちは (Konnichiwa)" mean?',
              question: 'こんにちは (Konnichiwa)',
              options: ['👋 Hello / Good day', '👋 Goodbye', '🙏 Thank you'],
              correctIndex: 0,
              speakerText: 'こんにちは',
            ),
            const MatchingPairExercise(
              id: 'jp_u1_l1_e2',
              prompt: 'Match the Japanese words:',
              pairs: {
                'ありがとう': 'Thank you',
                'はい': 'Yes',
                'いいえ': 'No',
                'さようなら': 'Goodbye',
              },
            ),
            const SentenceBuilderExercise(
              id: 'jp_u1_l1_e3',
              prompt: 'Translate into English:',
              sentenceToTranslate: '水 を ください (Mizu o kudasai)',
              correctSequence: ['Water,', 'please'],
              tokenBank: ['Water,', 'please', 'Tea,', 'thanks', 'coffee'],
              speakerText: '水 を ください',
            ),
            const FillInBlankExercise(
              id: 'jp_u1_l1_e4',
              prompt: 'Say thank you very much:',
              prefix: 'どうも ',
              blankAnswer: 'ありがとう',
              suffix: ' (Doumo arigatou)',
              options: ['ありがとう', 'ねこ', 'いぬ'],
              speakerText: 'どうもありがとう',
            ),
          ],
        ),
        Lesson(
          id: 'jp_u1_l2',
          title: 'Cute Animals & Tea',
          description: 'Cat, dog, and green tea',
          icon: Icons.pets_rounded,
          xpReward: 20,
          exercises: [
            const MultipleChoiceExercise(
              id: 'jp_u1_l2_e1',
              prompt: 'Which word means "Cat"?',
              question: '猫 (Neko)',
              options: ['🐱 Cat', '🐶 Dog', '🍵 Green Tea'],
              correctIndex: 0,
              speakerText: '猫',
            ),
            const MatchingPairExercise(
              id: 'jp_u1_l2_e2',
              prompt: 'Match the words:',
              pairs: {
                '犬 (Inu)': 'Dog',
                '猫 (Neko)': 'Cat',
                'お茶 (Ocha)': 'Tea',
                '水 (Mizu)': 'Water',
              },
            ),
          ],
        ),
      ],
    ),
  ];

  // PYTHON CODING COURSE
  static final List<Unit> pythonUnits = [
    Unit(
      id: 'py_unit_1',
      unitNumber: 1,
      title: 'Hello World & Variables',
      description: 'Learn programming fundamentals like a playful game!',
      themeColor: const Color(0xFF2E7D32),
      lessons: [
        Lesson(
          id: 'py_u1_l1',
          title: 'Print & Output',
          description: 'Write your first Python statement',
          icon: Icons.code_rounded,
          xpReward: 15,
          exercises: [
            const MultipleChoiceExercise(
              id: 'py_u1_l1_e1',
              prompt: 'What does print("Hello") do in Python?',
              question: 'print("Hello")',
              options: [
                '🖥️ Displays "Hello" on the screen',
                '💾 Saves a file named Hello',
                '🛑 Stops the program',
              ],
              correctIndex: 0,
            ),
            const SentenceBuilderExercise(
              id: 'py_u1_l1_e2',
              prompt: 'Assemble the code to print "Hi":',
              sentenceToTranslate: 'Display the word "Hi"',
              correctSequence: ['print', '(', '"Hi"', ')'],
              tokenBank: ['print', '(', '"Hi"', ')', 'input', 'var', 'echo'],
            ),
            const MatchingPairExercise(
              id: 'py_u1_l1_e3',
              prompt: 'Match the Python concepts:',
              pairs: {
                'print()': 'Output text to console',
                'str': 'Text string data type',
                'int': 'Whole number data type',
                '#': 'Comment (ignored code)',
              },
            ),
            const FillInBlankExercise(
              id: 'py_u1_l1_e4',
              prompt: 'Complete the Python print statement:',
              prefix: 'print("Hello, ',
              blankAnswer: 'World',
              suffix: '!")',
              options: ['World', 'def', 'while'],
            ),
          ],
        ),
        Lesson(
          id: 'py_u1_l2',
          title: 'Variables & Maths',
          description: 'Store numbers and calculate results',
          icon: Icons.calculate_rounded,
          xpReward: 20,
          exercises: [
            const MultipleChoiceExercise(
              id: 'py_u1_l2_e1',
              prompt: 'What value is stored in x?',
              question: 'x = 10 + 5',
              options: ['🔢 15', '🔢 105', '🔢 10'],
              correctIndex: 0,
            ),
            const MatchingPairExercise(
              id: 'py_u1_l2_e2',
              prompt: 'Match Python operators:',
              pairs: {
                '+': 'Addition',
                '-': 'Subtraction',
                '*': 'Multiplication',
                '==': 'Equal to comparison',
              },
            ),
            const SentenceBuilderExercise(
              id: 'py_u1_l2_e3',
              prompt: 'Assemble variable assignment:',
              sentenceToTranslate: 'Set score equal to 100',
              correctSequence: ['score', '=', '100'],
              tokenBank: ['score', '=', '100', '==', 'int', 'print'],
            ),
          ],
        ),
      ],
    ),
  ];

  // BANGLA TO ENGLISH (ইংরেজি শিখুন - English for Bengali Speakers)
  static final List<Unit> banglaToEnglishUnits = [
    Unit(
      id: 'bn_en_u1',
      unitNumber: 1,
      title: 'সাধারণ সম্ভাষণ ও পরিচিতি',
      description: 'সহজে ইংরেজিতে অভিবাদন ও নিজের পরিচয় দিতে শিখুন',
      themeColor: const Color(0xFF006A4E), // Bangladesh Green
      lessons: [
        Lesson(
          id: 'bn_en_u1_l1',
          title: 'অভিবাদন ও শুভেচ্ছা',
          description: 'Hello, Good morning, Thank you',
          icon: Icons.waving_hand_rounded,
          xpReward: 15,
          exercises: [
            const MultipleChoiceExercise(
              id: 'bn_en_u1_l1_e1',
              prompt: '"হ্যালো / ওহে" এর সঠিক ইংরেজি কোনটি?',
              question: 'হ্যালো',
              options: ['👋 Hello', '🍎 Apple', '💧 Water'],
              correctIndex: 0,
              speakerText: 'Hello',
            ),
            const SentenceBuilderExercise(
              id: 'bn_en_u1_l1_e2',
              prompt: 'বাক্যটি বাংলায় অনুবাদ অনুসারে সাজান: "আমি ভালো আছি"',
              sentenceToTranslate: 'আমি ভালো আছি',
              correctSequence: ['I', 'am', 'fine'],
              tokenBank: ['I', 'am', 'fine', 'you', 'is', 'good', 'he'],
              speakerText: 'I am fine',
            ),
            const MatchingPairExercise(
              id: 'bn_en_u1_l1_e3',
              prompt: 'সঠিক জোড়াগুলো মেলাও:',
              pairs: {
                'হ্যালো': 'Hello',
                'ধন্যবাদ': 'Thank you',
                'শুভ সকাল': 'Good morning',
                'বিদায়': 'Goodbye',
              },
            ),
            const SpeakingExercise(
              id: 'bn_en_u1_l1_e4',
              prompt: 'মাইক্রোফোনে বাক্যটি স্পষ্ট উচ্চারণ করুন:',
              targetPhrase: 'Good morning my friend',
              translation: 'শুভ সকাল আমার বন্ধু',
              targetWords: ['Good', 'morning', 'my', 'friend'],
              speakerText: 'Good morning my friend',
            ),
            const FillInBlankExercise(
              id: 'bn_en_u1_l1_e5',
              prompt: 'উপযুক্ত শব্দ দিয়ে শূন্যস্থান পূরণ করুন:',
              prefix: 'Thank ',
              blankAnswer: 'you',
              suffix: ' very much.',
              options: ['you', 'water', 'eat'],
              speakerText: 'Thank you very much.',
            ),
          ],
        ),
        Lesson(
          id: 'bn_en_u1_l2',
          title: 'নিজের পরিচয় দেওয়া',
          description: 'My name is, Friend, How are you',
          icon: Icons.person_rounded,
          xpReward: 20,
          exercises: [
            const MultipleChoiceExercise(
              id: 'bn_en_u1_l2_e1',
              prompt: '"বন্ধু" শব্দের ইংরেজি অর্থ কী?',
              question: 'বন্ধু',
              options: ['🤝 Friend', '🏠 House', '📖 Book'],
              correctIndex: 0,
              speakerText: 'Friend',
            ),
            const SentenceBuilderExercise(
              id: 'bn_en_u1_l2_e2',
              prompt: 'ইংরেজি বাক্যটি সাজান: "আমার নাম জন"',
              sentenceToTranslate: 'আমার নাম জন',
              correctSequence: ['My', 'name', 'is', 'John'],
              tokenBank: ['My', 'name', 'is', 'John', 'Your', 'are', 'friend'],
              speakerText: 'My name is John',
            ),
            const MatchingPairExercise(
              id: 'bn_en_u1_l2_e3',
              prompt: 'জোড়া মেলাও:',
              pairs: {
                'বন্ধু': 'Friend',
                'নাম': 'Name',
                'কেমন আছেন': 'How are you',
                'হ্যাঁ': 'Yes',
              },
            ),
          ],
        ),
      ],
    ),
    Unit(
      id: 'bn_en_u2',
      unitNumber: 2,
      title: 'খাবার, পানি ও রেস্তোরাঁ',
      description: 'দৈনন্দিন খাবার ও পানির ইংরেজি শব্দ শিখুন',
      themeColor: AppColors.orange,
      lessons: [
        Lesson(
          id: 'bn_en_u2_l1',
          title: 'খাবার ও পানীয়',
          description: 'Water, Rice, Bread, Tea',
          icon: Icons.restaurant_rounded,
          xpReward: 20,
          exercises: [
            const MultipleChoiceExercise(
              id: 'bn_en_u2_l1_e1',
              prompt: '"পানি" এর ইংরেজি শব্দ নির্বাচন করুন:',
              question: 'পানি',
              options: ['💧 Water', '🥛 Milk', '☕ Tea'],
              correctIndex: 0,
              speakerText: 'Water',
            ),
            const SentenceBuilderExercise(
              id: 'bn_en_u2_l1_e2',
              prompt: 'বাক্যটি সাজান: "আমি ভাত খাই"',
              sentenceToTranslate: 'আমি ভাত খাই',
              correctSequence: ['I', 'eat', 'rice'],
              tokenBank: ['I', 'eat', 'rice', 'drink', 'bread', 'water'],
              speakerText: 'I eat rice',
            ),
            const MatchingPairExercise(
              id: 'bn_en_u2_l1_e3',
              prompt: 'শব্দগুলো মেলাও:',
              pairs: {
                'পানি': 'Water',
                'ভাত': 'Rice',
                'রুটি': 'Bread',
                'চা': 'Tea',
              },
            ),
          ],
        ),
      ],
    ),
  ];

  // ENGLISH TO BENGALI (বাংলা ভাষা শিক্ষা)
  static final List<Unit> bengaliUnits = [
    Unit(
      id: 'bn_u1',
      unitNumber: 1,
      title: 'Greetings & Essentials',
      description: 'Learn heartfelt Bengali greetings and polite phrases!',
      themeColor: const Color(0xFFE03C31), // Bangladesh Red
      lessons: [
        Lesson(
          id: 'bn_u1_l1',
          title: 'Hello & Welcome',
          description: 'Nomoshkar, Dhonnobad, Kemon achhen',
          icon: Icons.favorite_rounded,
          xpReward: 15,
          exercises: [
            const MultipleChoiceExercise(
              id: 'bn_u1_l1_e1',
              prompt: 'Select the Bengali word for "Hello":',
              question: 'Hello',
              options: ['নমস্কার (Nomoshkar)', 'পানি (Pani)', 'ভাত (Bhat)'],
              correctIndex: 0,
              speakerText: 'নমস্কার',
            ),
            const SentenceBuilderExercise(
              id: 'bn_u1_l1_e2',
              prompt: 'Assemble: "How are you?":',
              sentenceToTranslate: 'How are you?',
              correctSequence: ['আপনি', 'কেমন', 'আছেন?'],
              tokenBank: ['আপনি', 'কেমন', 'আছেন?', 'ভালো', 'ধন্যবাদ', 'আমি'],
              speakerText: 'আপনি কেমন আছেন?',
            ),
            const MatchingPairExercise(
              id: 'bn_u1_l1_e3',
              prompt: 'Match the Bengali pairs:',
              pairs: {
                'নমস্কার': 'Hello',
                'ধন্যবাদ': 'Thank you',
                'শুভ সকাল': 'Good morning',
                'বিদায়': 'Goodbye',
              },
            ),
            const FillInBlankExercise(
              id: 'bn_u1_l1_e4',
              prompt: 'Complete the sentence:',
              prefix: 'আমি ',
              blankAnswer: 'ভালো',
              suffix: ' আছি। (I am fine)',
              options: ['ভালো', 'পানি', 'বই'],
              speakerText: 'আমি ভালো আছি',
            ),
          ],
        ),
      ],
    ),
    Unit(
      id: 'bn_u2',
      unitNumber: 2,
      title: 'Food & Daily Words',
      description: 'Water, Rice, Numbers & Chai',
      themeColor: AppColors.green,
      lessons: [
        Lesson(
          id: 'bn_u2_l1',
          title: 'Pani, Bhat & Cha',
          description: 'Essential dining vocabulary',
          icon: Icons.free_breakfast_rounded,
          xpReward: 15,
          exercises: [
            const MultipleChoiceExercise(
              id: 'bn_u2_l1_e1',
              prompt: 'Select translation for "Water":',
              question: 'Water',
              options: ['পানি (Pani)', 'চা (Cha)', 'মাছ (Machh)'],
              correctIndex: 0,
              speakerText: 'পানি',
            ),
            const MatchingPairExercise(
              id: 'bn_u2_l1_e2',
              prompt: 'Match the words:',
              pairs: {
                'পানি (Pani)': 'Water',
                'ভাত (Bhat)': 'Rice',
                'চা (Cha)': 'Tea',
                'মাছ (Machh)': 'Fish',
              },
            ),
          ],
        ),
      ],
    ),
  ];

  // CHINESE MANDARIN (中文普通话)
  static final List<Unit> chineseUnits = [
    Unit(
      id: 'zh_u1',
      unitNumber: 1,
      title: 'Pinyin & Essential Greetings',
      description: 'Master tones, greetings, and courteous phrases in Mandarin!',
      themeColor: const Color(0xFFD32F2F), // Crimson Red
      lessons: [
        Lesson(
          id: 'zh_u1_l1',
          title: 'Hello & Thank You',
          description: 'Nǐ hǎo, Xièxiè, Zàijiàn',
          icon: Icons.celebration_rounded,
          xpReward: 15,
          exercises: [
            const MultipleChoiceExercise(
              id: 'zh_u1_l1_e1',
              prompt: 'Select the translation for "Hello":',
              question: '你好 (Nǐ hǎo)',
              options: ['👋 Hello', '🙏 Thank you', '👋 Goodbye'],
              correctIndex: 0,
              speakerText: '你好',
            ),
            const SentenceBuilderExercise(
              id: 'zh_u1_l1_e2',
              prompt: 'Translate into Mandarin: "Thank you all":',
              sentenceToTranslate: 'Thank you all',
              correctSequence: ['谢谢', '大家'],
              tokenBank: ['谢谢', '大家', '你好', '再见', '老师'],
              speakerText: '谢谢大家',
            ),
            const MatchingPairExercise(
              id: 'zh_u1_l1_e3',
              prompt: 'Match Mandarin Pinyin with English:',
              pairs: {
                '你好 (Nǐ hǎo)': 'Hello',
                '谢谢 (Xièxiè)': 'Thank you',
                '再见 (Zàijiàn)': 'Goodbye',
                '早上好 (Zǎoshang hǎo)': 'Good morning',
              },
            ),
            const FillInBlankExercise(
              id: 'zh_u1_l1_e4',
              prompt: 'Complete the phrase "You are welcome":',
              prefix: '不',
              blankAnswer: '客气',
              suffix: ' (Bù kèqi)',
              options: ['客气', '你好', '再见'],
              speakerText: '不客气',
            ),
          ],
        ),
      ],
    ),
    Unit(
      id: 'zh_u2',
      unitNumber: 2,
      title: 'Tea Culture & Dining',
      description: 'Order tea, water, and staple Chinese dishes',
      themeColor: AppColors.yellowDark,
      lessons: [
        Lesson(
          id: 'zh_u2_l1',
          title: 'Tea & Rice',
          description: 'Chá, Shuǐ, Mǐfàn',
          icon: Icons.emoji_food_beverage_rounded,
          xpReward: 15,
          exercises: [
            const MultipleChoiceExercise(
              id: 'zh_u2_l1_e1',
              prompt: 'Select the translation for "Tea":',
              question: '茶 (Chá)',
              options: ['🍵 Tea', '💧 Water', '🍚 Rice'],
              correctIndex: 0,
              speakerText: '茶',
            ),
            const MatchingPairExercise(
              id: 'zh_u2_l1_e2',
              prompt: 'Match the food & drink items:',
              pairs: {
                '水 (Shuǐ)': 'Water',
                '茶 (Chá)': 'Tea',
                '米饭 (Mǐfàn)': 'Rice',
                '苹果 (Píngguǒ)': 'Apple',
              },
            ),
          ],
        ),
      ],
    ),
  ];

  // HINDI (हिंदी सीखें)
  static final List<Unit> hindiUnits = [
    Unit(
      id: 'hi_u1',
      unitNumber: 1,
      title: 'Namaste & Everyday Greetings',
      description: 'Learn polite Hindi greetings, introducing yourself & gratitude',
      themeColor: const Color(0xFFFF6F00), // Saffron Orange
      lessons: [
        Lesson(
          id: 'hi_u1_l1',
          title: 'Namaste & Basics',
          description: 'Namaste, Dhanyavaad, Aap kaise hain',
          icon: Icons.volunteer_activism_rounded,
          xpReward: 15,
          exercises: [
            const MultipleChoiceExercise(
              id: 'hi_u1_l1_e1',
              prompt: 'Select the translation for "Hello":',
              question: 'नमस्ते (Namaste)',
              options: ['🙏 Hello', '💧 Water', '🍎 Apple'],
              correctIndex: 0,
              speakerText: 'नमस्ते',
            ),
            const SentenceBuilderExercise(
              id: 'hi_u1_l1_e2',
              prompt: 'Assemble "How are you?":',
              sentenceToTranslate: 'How are you?',
              correctSequence: ['आप', 'कैसे', 'हैं?'],
              tokenBank: ['आप', 'कैसे', 'हैं?', 'मैं', 'अच्छा', 'धन्यवाद'],
              speakerText: 'आप कैसे हैं?',
            ),
            const MatchingPairExercise(
              id: 'hi_u1_l1_e3',
              prompt: 'Match the Hindi words with English:',
              pairs: {
                'नमस्ते (Namaste)': 'Hello',
                'धन्यवाद (Dhanyavaad)': 'Thank you',
                'शुभ प्रभात (Shubh Prabhaat)': 'Good morning',
                'अलविदा (Alvida)': 'Goodbye',
              },
            ),
            const FillInBlankExercise(
              id: 'hi_u1_l1_e4',
              prompt: 'Complete "I am fine":',
              prefix: 'मैं ठीक ',
              blankAnswer: 'हूँ',
              suffix: '। (Main theek hoon)',
              options: ['हूँ', 'है', 'पानी'],
              speakerText: 'मैं ठीक हूँ',
            ),
          ],
        ),
      ],
    ),
    Unit(
      id: 'hi_u2',
      unitNumber: 2,
      title: 'Chai & Daily Food',
      description: 'Chai, Paani, Roti, and dining expressions',
      themeColor: AppColors.greenDark,
      lessons: [
        Lesson(
          id: 'hi_u2_l1',
          title: 'Chai & Paani',
          description: 'Essential Hindi kitchen & dining words',
          icon: Icons.local_cafe_rounded,
          xpReward: 15,
          exercises: [
            const MultipleChoiceExercise(
              id: 'hi_u2_l1_e1',
              prompt: 'Select the translation for "Water":',
              question: 'पानी (Paani)',
              options: ['💧 Water', '☕ Tea', '🍞 Bread'],
              correctIndex: 0,
              speakerText: 'पानी',
            ),
            const MatchingPairExercise(
              id: 'hi_u2_l1_e2',
              prompt: 'Match the food items:',
              pairs: {
                'पानी (Paani)': 'Water',
                'चाय (Chai)': 'Tea',
                'रोটি (Roti)': 'Bread',
                'सेब (Seb)': 'Apple',
              },
            ),
          ],
        ),
      ],
    ),
  ];

  static final Map<String, Course> courses = {
    'bangla_to_english': Course(
      id: 'bangla_to_english',
      title: 'ইংরেজি শিখুন (Bangla → English)',
      flag: '🇧🇩',
      description: 'বাংলা মাধ্যমে সহজে ইংরেজি বলা ও ব্যাকরণ শিখুন • 2 Units',
      ttsLocale: 'en-US',
      units: banglaToEnglishUnits,
    ),
    'bengali': Course(
      id: 'bengali',
      title: 'Bengali (বাংলা)',
      flag: '🇧🇩',
      description: 'Section 1: Bornomala & Greetings • 2 Units',
      ttsLocale: 'bn-BD',
      units: bengaliUnits,
    ),
    'chinese': Course(
      id: 'chinese',
      title: 'Chinese (Mandarin • 中文)',
      flag: '🇨🇳',
      description: 'Section 1: Pinyin & Tones • 2 Units',
      ttsLocale: 'zh-CN',
      units: chineseUnits,
    ),
    'hindi': Course(
      id: 'hindi',
      title: 'Hindi (हिंदी)',
      flag: '🇮🇳',
      description: 'Section 1: Namaste & Essentials • 2 Units',
      ttsLocale: 'hi-IN',
      units: hindiUnits,
    ),
    'spanish': Course(
      id: 'spanish',
      title: 'Spanish',
      flag: '🇪🇸',
      description: 'Section 1: Rookie • 3 Units',
      ttsLocale: 'es-ES',
      units: units,
    ),
    'french': Course(
      id: 'french',
      title: 'French',
      flag: '🇫🇷',
      description: 'Section 1: Bonjour • 1 Unit',
      ttsLocale: 'fr-FR',
      units: frenchUnits,
    ),
    'japanese': Course(
      id: 'japanese',
      title: 'Japanese',
      flag: '🇯🇵',
      description: 'Section 1: Konnichiwa • 1 Unit',
      ttsLocale: 'ja-JP',
      units: japaneseUnits,
    ),
    'python': Course(
      id: 'python',
      title: 'Python Coding',
      flag: '🐍',
      description: 'Section 1: Hello World • 1 Unit',
      ttsLocale: 'en-US',
      units: pythonUnits,
    ),
  };

  static List<Unit> getUnitsForCourse(String courseId) {
    return courses[courseId]?.units ?? units;
  }

  static Course getCourse(String courseId) {
    return courses[courseId] ?? courses['spanish']!;
  }

  static Exercise? findExerciseById(String id) {
    for (final course in courses.values) {
      for (final unit in course.units) {
        for (final lesson in unit.lessons) {
          for (final ex in lesson.exercises) {
            if (ex.id == id) return ex;
          }
        }
      }
    }
    return null;
  }
}

