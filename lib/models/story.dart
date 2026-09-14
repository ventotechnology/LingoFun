import 'package:flutter/material.dart';

class StoryCharacter {
  final String id;
  final String name;
  final String avatarEmoji;
  final Color themeColor;

  const StoryCharacter({
    required this.id,
    required this.name,
    required this.avatarEmoji,
    required this.themeColor,
  });

  // Original International Cast
  static const StoryCharacter ayan = StoryCharacter(
    id: 'ayan',
    name: 'Ayan',
    avatarEmoji: '🧢',
    themeColor: Color(0xFF1CB0F6),
  );

  static const StoryCharacter maya = StoryCharacter(
    id: 'maya',
    name: 'Maya',
    avatarEmoji: '👓',
    themeColor: Color(0xFFCE82FF),
  );

  static const StoryCharacter sophia = StoryCharacter(
    id: 'sophia',
    name: 'Sophia',
    avatarEmoji: '🎨',
    themeColor: Color(0xFFFF9600),
  );

  static const StoryCharacter kenji = StoryCharacter(
    id: 'kenji',
    name: 'Kenji',
    avatarEmoji: '🎧',
    themeColor: Color(0xFF2B70C9),
  );

  static const StoryCharacter rafi = StoryCharacter(
    id: 'rafi',
    name: 'Rafi',
    avatarEmoji: '👨‍🍳',
    themeColor: Color(0xFFFFC800),
  );

  static const StoryCharacter luna = StoryCharacter(
    id: 'luna',
    name: 'Luna',
    avatarEmoji: '💜',
    themeColor: Color(0xFFA560EB),
  );

  static const StoryCharacter priya = StoryCharacter(
    id: 'priya',
    name: 'Priya',
    avatarEmoji: '🌸',
    themeColor: Color(0xFFFF4B4B),
  );

  static const StoryCharacter lingo = StoryCharacter(
    id: 'lingo',
    name: 'Lingo',
    avatarEmoji: '🦜',
    themeColor: Color(0xFF00C4CC),
  );

  // Backward compatibility aliases
  static const StoryCharacter junior = ayan;
  static const StoryCharacter bea = maya;
  static const StoryCharacter oscar = sophia;
  static const StoryCharacter lin = kenji;
  static const StoryCharacter vikram = rafi;
  static const StoryCharacter lily = luna;
  static const StoryCharacter zari = priya;
}

class CheckpointQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;

  const CheckpointQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });
}

class StoryLine {
  final String id;
  final StoryCharacter? character; // null for narrator
  final String text;
  final String translation;
  final CheckpointQuestion? question;

  const StoryLine({
    required this.id,
    this.character,
    required this.text,
    required this.translation,
    this.question,
  });

  bool get isNarrator => character == null;
}

class Story {
  final String id;
  final String courseId;
  final String title;
  final String translationTitle;
  final String emoji;
  final int xpReward;
  final int gemReward;
  final int unitRequirement;
  final List<StoryLine> lines;

  const Story({
    required this.id,
    required this.courseId,
    required this.title,
    required this.translationTitle,
    required this.emoji,
    this.xpReward = 25,
    this.gemReward = 15,
    this.unitRequirement = 1,
    required this.lines,
  });
}

class StoriesData {
  static final Map<String, List<Story>> storiesByCourse = {
    // Bangla to English
    'bangla_to_english': [
      const Story(
        id: 'bte_story_1',
        courseId: 'bangla_to_english',
        title: 'A Cup of Tea',
        translationTitle: 'এক কাপ চা',
        emoji: '☕',
        xpReward: 25,
        gemReward: 15,
        lines: [
          StoryLine(
            id: 'bte1_1',
            character: null,
            text: 'Junior and Vikram are at a breakfast restaurant.',
            translation: 'জুনিয়র এবং বিক্রম একটি সকালের খাবারের রেস্তোরাঁয় রয়েছে।',
          ),
          StoryLine(
            id: 'bte1_2',
            character: StoryCharacter.junior,
            text: 'Vikram, I want a cup of tea, please.',
            translation: 'বিক্রম, আমি এক কাপ চা চাই, অনুগ্রহ করে।',
          ),
          StoryLine(
            id: 'bte1_3',
            character: StoryCharacter.vikram,
            text: 'Sure, Junior! Do you want sugar in your tea?',
            translation: 'অবশ্যই জুনিয়র! তুমি কি তোমার চায়ে চিনি চাও?',
            question: CheckpointQuestion(
              question: 'What does Vikram ask Junior?',
              options: [
                'If he wants hot milk',
                'If he wants sugar in his tea',
                'If he wants chocolate cake',
              ],
              correctIndex: 1,
              explanation: 'Vikram asks: "Do you want sugar in your tea?"',
            ),
          ),
          StoryLine(
            id: 'bte1_4',
            character: StoryCharacter.junior,
            text: 'Yes, please! Two spoons of sugar.',
            translation: 'হ্যাঁ, দয়া করে! দুই চামচ চিনি।',
          ),
          StoryLine(
            id: 'bte1_5',
            character: StoryCharacter.vikram,
            text: 'Here is your tea. Be careful, it is very hot!',
            translation: 'এই নাও তোমার চা। সাবধান, এটা অনেক গরম!',
          ),
          StoryLine(
            id: 'bte1_6',
            character: StoryCharacter.junior,
            text: 'Thank you, Vikram! It smells amazing.',
            translation: 'ধন্যবাদ বিক্রম! চমৎকার সুবাস আসছে।',
          ),
          StoryLine(
            id: 'bte1_7',
            character: null,
            text: 'Junior drinks his sweet tea with a big smile.',
            translation: 'জুনিয়র মিষ্টি হাসি দিয়ে তার মিষ্টি চা পান করে।',
          ),
        ],
      ),
      const Story(
        id: 'bte_story_2',
        courseId: 'bangla_to_english',
        title: 'Where is My Passport?',
        translationTitle: 'আমার পাসপোর্ট কোথায়?',
        emoji: '✈️',
        xpReward: 30,
        gemReward: 20,
        lines: [
          StoryLine(
            id: 'bte2_1',
            character: null,
            text: 'Vikram is preparing to fly to London today.',
            translation: 'বিক্রম আজ লন্ডনে উড়াল দেওয়ার প্রস্তুতি নিচ্ছে।',
          ),
          StoryLine(
            id: 'bte2_2',
            character: StoryCharacter.vikram,
            text: 'Junior! Where is my passport? I cannot find it!',
            translation: 'জুনিয়র! আমার পাসপোর্ট কোথায়? আমি এটা খুঁজে পাচ্ছি না!',
          ),
          StoryLine(
            id: 'bte2_3',
            character: StoryCharacter.junior,
            text: 'Is it on the table in the living room?',
            translation: 'এটা কি বসার ঘরের টেবিলের উপর?',
            question: CheckpointQuestion(
              question: 'Where did Junior suggest looking first?',
              options: [
                'In the car',
                'On the table in the living room',
                'Under the sofa',
              ],
              correctIndex: 1,
            ),
          ),
          StoryLine(
            id: 'bte2_4',
            character: StoryCharacter.vikram,
            text: 'No, it is not on the table. Oh no, my flight!',
            translation: 'না, এটা টেবিলে নেই। সর্বনাশ, আমার ফ্লাইট!',
          ),
          StoryLine(
            id: 'bte2_5',
            character: StoryCharacter.junior,
            text: 'Vikram, look at your right hand!',
            translation: 'বিক্রম, তোমার ডান হাতের দিকে তাকাও!',
          ),
          StoryLine(
            id: 'bte2_6',
            character: StoryCharacter.vikram,
            text: 'Oh! I am holding it! How silly of me!',
            translation: 'ওহ! আমি তো নিজেই ধরে রেখেছি! কী বোকামি আমার!',
          ),
          StoryLine(
            id: 'bte2_7',
            character: null,
            text: 'They both laugh as Vikram rushes happily to the airport.',
            translation: 'তারা দুজনেই হাসে এবং বিক্রম আনন্দের সাথে বিমানবন্দরে রওনা হয়।',
          ),
        ],
      ),
      const Story(
        id: 'bte_story_3',
        courseId: 'bangla_to_english',
        title: 'The Job Interview',
        translationTitle: 'চাকরির ইন্টারভিউ',
        emoji: '💼',
        xpReward: 35,
        gemReward: 25,
        lines: [
          StoryLine(
            id: 'bte3_1',
            character: null,
            text: 'Maya is helping Ayan practice for his first job interview in English.',
            translation: 'মায়া অয়নকে ইংরেজিতে তার প্রথম চাকরির ইন্টারভিউয়ের প্রস্তুতি নিতে সাহায্য করছে।',
          ),
          StoryLine(
            id: 'bte3_2',
            character: StoryCharacter.maya,
            text: 'Okay Ayan, imagine I am the interviewer. Tell me about yourself!',
            translation: 'ঠিক আছে অয়ন, ভাবো আমি ইন্টারভিউয়ার। নিজের সম্পর্কে কিছু বলো!',
          ),
          StoryLine(
            id: 'bte3_3',
            character: StoryCharacter.ayan,
            text: 'Hello! My name is Ayan. I love software engineering and solving hard problems.',
            translation: 'হ্যালো! আমার নাম অয়ন। আমি সফটওয়্যার ইঞ্জিনিয়ারিং এবং জটিল সমস্যা সমাধান করতে ভালোবাসি।',
            question: CheckpointQuestion(
              question: 'What does Ayan love doing?',
              options: [
                'Cooking spicy food',
                'Software engineering and solving hard problems',
                'Sleeping late in the morning',
              ],
              correctIndex: 1,
              explanation: 'Ayan said: "I love software engineering and solving hard problems."',
            ),
          ),
          StoryLine(
            id: 'bte3_4',
            character: StoryCharacter.maya,
            text: 'Excellent answer! Now, what are your greatest strengths?',
            translation: 'চমৎকার উত্তর! এখন বলো, তোমার সবচেয়ে বড় শক্তি বা গুণ কী কী?',
          ),
          StoryLine(
            id: 'bte3_5',
            character: StoryCharacter.ayan,
            text: 'I am a fast learner, and I collaborate very well in multicultural teams.',
            translation: 'আমি দ্রুত শিখতে পারি এবং বহুজাতিক দলে খুব সুন্দর সমন্বয় করে কাজ করতে পারি।',
          ),
          StoryLine(
            id: 'bte3_6',
            character: StoryCharacter.maya,
            text: 'Brilliant! You will speak with absolute confidence tomorrow!',
            translation: 'দারুণ! কালকে তুমি পুরো আত্মবিশ্বাসের সাথে কথা বলতে পারবে!',
          ),
          StoryLine(
            id: 'bte3_7',
            character: null,
            text: 'Ayan smiles broadly, feeling fully ready to ace the interview.',
            translation: 'অয়ন উজ্জ্বল হাসি দিয়ে ইন্টারভিউ জয়ের জন্য সম্পূর্ণ প্রস্তুত অনুভব করে।',
          ),
        ],
      ),
      const Story(
        id: 'bte_story_4',
        courseId: 'bangla_to_english',
        title: 'Lost in London',
        translationTitle: 'লন্ডনে পথ হারিয়ে',
        emoji: '🗺️',
        xpReward: 35,
        gemReward: 25,
        lines: [
          StoryLine(
            id: 'bte4_1',
            character: null,
            text: 'Rafi is walking in central London looking for the British Museum.',
            translation: 'রাফি সেন্ট্রাল লন্ডনে ব্রিটিশ মিউজিয়াম খুঁজে খুঁজে হাঁটছে।',
          ),
          StoryLine(
            id: 'bte4_2',
            character: StoryCharacter.rafi,
            text: 'Excuse me miss! Could you please help me find the British Museum?',
            translation: 'মাফ করবেন মিস! আপনি কি দয়া করে ব্রিটিশ মিউজিয়ামের পথটি চিনিয়ে দিতে পারেন?',
          ),
          StoryLine(
            id: 'bte4_3',
            character: StoryCharacter.sophia,
            text: 'Of course! Go straight for two blocks, then turn right at the traffic lights.',
            translation: 'অবশ্যই! সামনের দিকে দুই ব্লক সোজা যান, তারপর ট্রাফিক লাইটে ডানদিকে ঘুরুন।',
            question: CheckpointQuestion(
              question: 'Where should Rafi turn right?',
              options: [
                'At the railway station',
                'At the traffic lights',
                'Inside the coffee shop',
              ],
              correctIndex: 1,
              explanation: 'Sophia tells him: "turn right at the traffic lights."',
            ),
          ),
          StoryLine(
            id: 'bte4_4',
            character: StoryCharacter.rafi,
            text: 'Is it far from here? Should I take an underground train?',
            translation: 'এটা কি এখান থেকে অনেক দূরে? আমার কি পাতাল রেল নেওয়া উচিত?',
          ),
          StoryLine(
            id: 'bte4_5',
            character: StoryCharacter.sophia,
            text: 'No, it is just a five-minute pleasant walk. You will see the grand pillars.',
            translation: 'না, এটা মাত্র পাঁচ মিনিটের সুন্দর হাঁটা পথ। আপনি বড় থামগুলো দেখতে পাবেন।',
          ),
          StoryLine(
            id: 'bte4_6',
            character: StoryCharacter.rafi,
            text: 'Thank you so much! Have a wonderful day!',
            translation: 'আপনাকে অনেক ধন্যবাদ! আপনার দিনটি শুভ হোক!',
          ),
          StoryLine(
            id: 'bte4_7',
            character: null,
            text: 'Rafi happily continues walking and reaches the historic museum entrance.',
            translation: 'রাফি আনন্দের সাথে এগিয়ে চলে এবং ঐতিহাসিক জাদুঘরের প্রবেশদ্বারে পৌঁছে যায়।',
          ),
        ],
      ),
      const Story(
        id: 'bte_story_5',
        courseId: 'bangla_to_english',
        title: 'A Flight to Remember',
        translationTitle: 'স্মরণীয় বিমানযাত্রা',
        emoji: '🛫',
        xpReward: 40,
        gemReward: 30,
        lines: [
          StoryLine(
            id: 'bte5_1',
            character: null,
            text: 'Priya and Kenji arrive at Heathrow Airport Terminal 4.',
            translation: 'প্রিয়া এবং কেনজি হিথ্রো বিমানবন্দর টার্মিনাল ৪-এ এসে পৌঁছায়।',
          ),
          StoryLine(
            id: 'bte5_2',
            character: StoryCharacter.priya,
            text: 'Kenji, please double check our boarding passes for the gate number.',
            translation: 'কেনজি, গেট নম্বরের জন্য আমাদের বোর্ডিং পাসগুলো আরেকবার মিলিয়ে দেখো।',
          ),
          StoryLine(
            id: 'bte5_3',
            character: StoryCharacter.kenji,
            text: 'Our flight boards at Gate 24B in twenty minutes.',
            translation: 'আমাদের বিমান বিশ মিনিটের মধ্যে গেট ২৪বি-তে বোর্ডিং শুরু করবে।',
            question: CheckpointQuestion(
              question: 'Which gate is their flight boarding at?',
              options: [
                'Gate 12A',
                'Gate 24B',
                'Gate 99C',
              ],
              correctIndex: 1,
              explanation: 'Kenji confirmed: "Our flight boards at Gate 24B in twenty minutes."',
            ),
          ),
          StoryLine(
            id: 'bte5_4',
            character: StoryCharacter.priya,
            text: 'Did we request window seats so we can see the clouds and sunset?',
            translation: 'আমরা কি জানালার পাশের আসন চেয়েছিলাম যাতে মেঘ আর সূর্যাস্ত দেখতে পারি?',
          ),
          StoryLine(
            id: 'bte5_5',
            character: StoryCharacter.kenji,
            text: 'Yes, row 14 seats A and B! The flight attendant said the weather is clear.',
            translation: 'হ্যাঁ, ১৪ নম্বর সারির এ এবং বি আসন! বিমানবালা জানিয়েছেন আকাশ একদম পরিষ্কার।',
          ),
          StoryLine(
            id: 'bte5_6',
            character: null,
            text: 'The speaker announces: "All passengers for flight LF-202, please proceed to board."',
            translation: 'মাইকে ঘোষণা এলো: "ফ্লাইট এলএফ-২০২ এর সকল যাত্রী, অনুগ্রহ করে বোর্ডিংয়ে আসুন।"',
          ),
          StoryLine(
            id: 'bte5_7',
            character: StoryCharacter.priya,
            text: 'Here we go! Our next global adventure begins now!',
            translation: 'চলো যাই! আমাদের পরবর্তী বৈশ্বিক রোমাঞ্চকর ভ্রমণ এখনই শুরু হচ্ছে!',
          ),
        ],
      ),
    ],

    // English to Bengali
    'bengali': [
      const Story(
        id: 'bn_story_1',
        courseId: 'bengali',
        title: 'সুপ্রভাত ঢাকা!',
        translationTitle: 'Good Morning Dhaka!',
        emoji: '☀️',
        xpReward: 25,
        gemReward: 15,
        lines: [
          StoryLine(
            id: 'bn1_1',
            character: null,
            text: 'বিয়া এবং বিক্রম পুরান ঢাকায় হাঁটছেন।',
            translation: 'Bea and Vikram are walking in Old Dhaka.',
          ),
          StoryLine(
            id: 'bn1_2',
            character: StoryCharacter.bea,
            text: 'সুপ্রভাত বিক্রম! আজকের সকালটা খুব সুন্দর।',
            translation: 'Good morning Vikram! Today morning is very beautiful.',
          ),
          StoryLine(
            id: 'bn1_3',
            character: StoryCharacter.vikram,
            text: 'হ্যাঁ বিয়া, চলো গরম পরোটা আর ডিম ভাজি খাই।',
            translation: 'Yes Bea, let us eat hot paratha and fried egg.',
            question: CheckpointQuestion(
              question: 'বিক্রম কী খেতে চায়? (What does Vikram want to eat?)',
              options: [
                'ভাত ও মাছ (Rice and fish)',
                'গরম পরোটা ও ডিম ভাজি (Hot paratha and fried egg)',
                'ফলমূল (Fruits)',
              ],
              correctIndex: 1,
            ),
          ),
          StoryLine(
            id: 'bn1_4',
            character: StoryCharacter.bea,
            text: 'চমৎকার! সাথে এক কাপ খাঁটি দুধের চা চাই।',
            translation: 'Wonderful! With it I want a cup of pure milk tea.',
          ),
          StoryLine(
            id: 'bn1_5',
            character: StoryCharacter.vikram,
            text: 'চাচা, দুইটা পরোটা আর দুই কাপ গরম চা দিন!',
            translation: 'Uncle, please give two parathas and two cups of hot tea!',
          ),
          StoryLine(
            id: 'bn1_6',
            character: null,
            text: 'খাবার দারুণ সুস্বাদু ছিল। তারা তৃপ্তি করে খেলেন।',
            translation: 'The food was immensely delicious. They ate with great satisfaction.',
          ),
        ],
      ),
      const Story(
        id: 'bn_story_2',
        courseId: 'bengali',
        title: 'হারিয়ে যাওয়া বিড়াল',
        translationTitle: 'The Lost Cat',
        emoji: '🐱',
        xpReward: 30,
        gemReward: 20,
        lines: [
          StoryLine(
            id: 'bn2_1',
            character: null,
            text: 'লিন ঘরের ভেতর ব্যাকুল হয়ে কিছু খুঁজছে।',
            translation: 'Lin is anxiously looking for something inside the house.',
          ),
          StoryLine(
            id: 'bn2_2',
            character: StoryCharacter.lin,
            text: 'জুনিয়র, তুমি কি আমার সাদা বিড়াল মিনিকে দেখেছ?',
            translation: 'Junior, have you seen my white cat Mini?',
          ),
          StoryLine(
            id: 'bn2_3',
            character: StoryCharacter.junior,
            text: 'সে কি সোফার নিচে বা বারান্দায় আছে?',
            translation: 'Is she under the sofa or on the balcony?',
            question: CheckpointQuestion(
              question: 'লিনের বিড়ালের রং কী? (What is the color of Lin\'s cat?)',
              options: [
                'কালো (Black)',
                'সাদা (White)',
                'বাদামী (Brown)',
              ],
              correctIndex: 1,
            ),
          ),
          StoryLine(
            id: 'bn2_4',
            character: StoryCharacter.lin,
            text: 'না, কোথাও নেই! মিনি কোথায় গেল?',
            translation: 'No, she is nowhere! Where did Mini go?',
          ),
          StoryLine(
            id: 'bn2_5',
            character: StoryCharacter.junior,
            text: 'লিন দেখো! তোমার স্কুল ব্যাগের ভেতরে সে ঘুমাচ্ছে!',
            translation: 'Lin look! She is sleeping inside your school bag!',
          ),
          StoryLine(
            id: 'bn2_6',
            character: StoryCharacter.lin,
            text: 'ওহ মিনি! তুমি সত্যি খুব আদুরে আর দুষ্টু!',
            translation: 'Oh Mini! You are truly adorable and mischievous!',
          ),
        ],
      ),
    ],

    // Chinese Mandarin
    'chinese': [
      const Story(
        id: 'zh_story_1',
        courseId: 'chinese',
        title: '在茶馆',
        translationTitle: 'At the Teahouse',
        emoji: '🍵',
        xpReward: 25,
        gemReward: 15,
        lines: [
          StoryLine(
            id: 'zh1_1',
            character: null,
            text: 'Junior和Lin来到了北京的一家茶馆。',
            translation: 'Junior and Lin came to a teahouse in Beijing.',
          ),
          StoryLine(
            id: 'zh1_2',
            character: StoryCharacter.junior,
            text: '你好，Lin！这里的茶好喝吗？',
            translation: 'Nǐ hǎo, Lin! Is the tea here delicious?',
          ),
          StoryLine(
            id: 'zh1_3',
            character: StoryCharacter.lin,
            text: '你好！这里的茉莉花茶非常好喝。',
            translation: 'Nǐ hǎo! The jasmine tea here is very delicious.',
            question: CheckpointQuestion(
              question: 'Lin推荐了什么茶？(What tea does Lin recommend?)',
              options: [
                '绿茶 (Green tea)',
                '茉莉花茶 (Jasmine tea)',
                '咖啡 (Coffee)',
              ],
              correctIndex: 1,
            ),
          ),
          StoryLine(
            id: 'zh1_4',
            character: StoryCharacter.junior,
            text: '太好了！服务员，请给我们两杯热茶。',
            translation: 'Great! Waiter, please give us two cups of hot tea.',
          ),
          StoryLine(
            id: 'zh1_5',
            character: StoryCharacter.lin,
            text: '我们还要吃热包子和水饺！',
            translation: 'We also want to eat hot steamed buns and dumplings!',
          ),
          StoryLine(
            id: 'zh1_6',
            character: null,
            text: '热茶很香，点心也很美味。他们非常开心。',
            translation: 'The hot tea was fragrant, and snacks delicious. They were very happy.',
          ),
        ],
      ),
      const Story(
        id: 'zh_story_2',
        courseId: 'chinese',
        title: '我的猫在哪儿？',
        translationTitle: 'Where is My Cat?',
        emoji: '🐱',
        xpReward: 30,
        gemReward: 20,
        lines: [
          StoryLine(
            id: 'zh2_1',
            character: null,
            text: 'Lin在家里四处寻找她的猫咪。',
            translation: 'Lin was searching all around the house for her kitty.',
          ),
          StoryLine(
            id: 'zh2_2',
            character: StoryCharacter.lin,
            text: 'Junior，我的小猫在哪儿？你看见它了吗？',
            translation: 'Junior, where is my kitten? Have you seen it?',
          ),
          StoryLine(
            id: 'zh2_3',
            character: StoryCharacter.junior,
            text: '它在椅子下面吗？',
            translation: 'Is it under the chair?',
            question: CheckpointQuestion(
              question: 'Junior先建议看哪里？(Where did Junior suggest looking first?)',
              options: [
                '椅子下面 (Under the chair)',
                '门外面 (Outside the door)',
                '冰箱里 (In the fridge)',
              ],
              correctIndex: 0,
            ),
          ),
          StoryLine(
            id: 'zh2_4',
            character: StoryCharacter.lin,
            text: '不在，椅子下面只有一本书。',
            translation: 'No, under the chair there is only a book.',
          ),
          StoryLine(
            id: 'zh2_5',
            character: StoryCharacter.junior,
            text: '快看！它在桌子上面喝牛奶呢！',
            translation: 'Quick look! It is drinking milk on top of the table!',
          ),
          StoryLine(
            id: 'zh2_6',
            character: StoryCharacter.lin,
            text: '哈哈，原来在这里！它真是一个淘气的小猫。',
            translation: 'Haha, so it is here! It is truly a naughty little kitten.',
          ),
        ],
      ),
    ],

    // Hindi
    'hindi': [
      const Story(
        id: 'hi_story_1',
        courseId: 'hindi',
        title: 'एक कप चाय',
        translationTitle: 'A Cup of Chai',
        emoji: '☕',
        xpReward: 25,
        gemReward: 15,
        lines: [
          StoryLine(
            id: 'hi1_1',
            character: null,
            text: 'विक्रम और जूनियर दिल्ली के एक चाय की दुकान पर हैं।',
            translation: 'Vikram and Junior are at a tea shop in Delhi.',
          ),
          StoryLine(
            id: 'hi1_2',
            character: StoryCharacter.junior,
            text: 'नमस्ते विक्रम! मुझे एक कप अच्छी चाय चाहिए।',
            translation: 'Namaste Vikram! I want a cup of good tea.',
          ),
          StoryLine(
            id: 'hi1_3',
            character: StoryCharacter.vikram,
            text: 'नमस्ते जूनियर! क्या तुम्हें मीठी मसाला चाय पसंद है?',
            translation: 'Namaste Junior! Do you like sweet masala chai?',
            question: CheckpointQuestion(
              question: 'विक्रम ने जूनियर से क्या पूछा? (What did Vikram ask Junior?)',
              options: [
                'क्या उसे ठंडा पानी चाहिए (If he wants cold water)',
                'क्या उसे मीठी मसाला चाय पसंद है (If he likes sweet masala chai)',
                'क्या वह सोना चाहता है (If he wants to sleep)',
              ],
              correctIndex: 1,
            ),
          ),
          StoryLine(
            id: 'hi1_4',
            character: StoryCharacter.junior,
            text: 'हाँ, बहुत मीठी और गरम चाय!',
            translation: 'Yes, very sweet and hot tea!',
          ),
          StoryLine(
            id: 'hi1_5',
            character: StoryCharacter.vikram,
            text: 'भैया, दो कप कड़क अदरक वाली मसाला चाय दीजिए।',
            translation: 'Brother, please give two cups of strong ginger masala chai.',
          ),
          StoryLine(
            id: 'hi1_6',
            character: null,
            text: 'गरमा-गरम चाय बहुत स्वादिष्ट थी।',
            translation: 'The piping hot tea was very delicious.',
          ),
        ],
      ),
      const Story(
        id: 'hi_story_2',
        courseId: 'hindi',
        title: 'स्टेशन पर',
        translationTitle: 'At the Station',
        emoji: '🚆',
        xpReward: 30,
        gemReward: 20,
        lines: [
          StoryLine(
            id: 'hi2_1',
            character: null,
            text: 'बीया और विक्रम ट्रेन का इंतज़ार कर रहे हैं।',
            translation: 'Bea and Vikram are waiting for the train.',
          ),
          StoryLine(
            id: 'hi2_2',
            character: StoryCharacter.bea,
            text: 'विक्रम, हमारी ट्रेन कब आएगी?',
            translation: 'Vikram, when will our train arrive?',
          ),
          StoryLine(
            id: 'hi2_3',
            character: StoryCharacter.vikram,
            text: 'ट्रेन दस मिनट में आएगी। क्या तुम्हारा टिकट सुरक्षित है?',
            translation: 'The train will arrive in ten minutes. Is your ticket safe?',
            question: CheckpointQuestion(
              question: 'ट्रेन कितनी देर में आएगी? (How soon will the train arrive?)',
              options: [
                'एक घंटे में (In one hour)',
                'दस मिनट में (In ten minutes)',
                'कल सुबह (Tomorrow morning)',
              ],
              correctIndex: 1,
            ),
          ),
          StoryLine(
            id: 'hi2_4',
            character: StoryCharacter.bea,
            text: 'हाँ, मेरा टिकट मेरे लाल बैग में है!',
            translation: 'Yes, my ticket is in my red bag!',
          ),
          StoryLine(
            id: 'hi2_5',
            character: StoryCharacter.vikram,
            text: 'बहुत बढ़िया! चलो तब तक गरमा-गरम समोसे खाते हैं।',
            translation: 'Very good! In the meantime let us eat hot samosas.',
          ),
          StoryLine(
            id: 'hi2_6',
            character: null,
            text: 'ट्रेन आ गई और उनका सफर शुरू हुआ।',
            translation: 'The train arrived and their journey began.',
          ),
        ],
      ),
    ],

    // Spanish
    'spanish': [
      const Story(
        id: 'es_story_1',
        courseId: 'spanish',
        title: 'Buenos Días',
        translationTitle: 'Good Morning',
        emoji: '🥞',
        xpReward: 25,
        gemReward: 15,
        lines: [
          StoryLine(
            id: 'es1_1',
            character: null,
            text: 'Junior entra en la cocina temprano por la mañana.',
            translation: 'Junior enters the kitchen early in the morning.',
          ),
          StoryLine(
            id: 'es1_2',
            character: StoryCharacter.junior,
            text: '¡Papá, buenos días! ¿Quieres un café con leche?',
            translation: 'Dad, good morning! Do you want coffee with milk?',
          ),
          StoryLine(
            id: 'es1_3',
            character: StoryCharacter.oscar,
            text: '¡Sí, por favor Junior! Necesito mucha energía hoy.',
            translation: 'Yes, please Junior! I need a lot of energy today.',
            question: CheckpointQuestion(
              question: '¿Qué necesita Oscar hoy?',
              options: [
                'Dormir más (To sleep more)',
                'Mucha energía (A lot of energy)',
                'Un taxi (A taxi)',
              ],
              correctIndex: 1,
            ),
          ),
          StoryLine(
            id: 'es1_4',
            character: StoryCharacter.junior,
            text: 'Aquí tienes. ¡Le puse tres cucharadas de azúcar!',
            translation: 'Here you go. I put three spoons of sugar in it!',
          ),
          StoryLine(
            id: 'es1_5',
            character: StoryCharacter.oscar,
            text: '¡Junior! ¡Esto sabe a caramelo, está súper dulce!',
            translation: 'Junior! This tastes like caramel, it is super sweet!',
          ),
          StoryLine(
            id: 'es1_6',
            character: StoryCharacter.junior,
            text: '¡De nada, papá! ¡Feliz día!',
            translation: 'You are welcome, Dad! Happy day!',
          ),
        ],
      ),
      const Story(
        id: 'es_story_2',
        courseId: 'spanish',
        title: 'Una Cita Romántica',
        translationTitle: 'A Romantic Date',
        emoji: '🌹',
        xpReward: 30,
        gemReward: 20,
        lines: [
          StoryLine(
            id: 'es2_1',
            character: null,
            text: 'Bea llega elegante a un restaurante español.',
            translation: 'Bea arrives elegantly at a Spanish restaurant.',
          ),
          StoryLine(
            id: 'es2_2',
            character: StoryCharacter.bea,
            text: '¡Hola! ¿Eres Carlos? ¿La persona de mi cita?',
            translation: 'Hello! Are you Carlos? The person from my date?',
          ),
          StoryLine(
            id: 'es2_3',
            character: StoryCharacter.vikram,
            text: 'No, no soy Carlos. Soy Vikram, el chef del restaurante.',
            translation: 'No, I am not Carlos. I am Vikram, the chef of the restaurant.',
            question: CheckpointQuestion(
              question: '¿Quién es Vikram realmente?',
              options: [
                'El hermano de Bea',
                'El chef del restaurante',
                'Carlos',
              ],
              correctIndex: 1,
            ),
          ),
          StoryLine(
            id: 'es2_4',
            character: StoryCharacter.bea,
            text: '¡Oh, qué vergüenza! Me equivoqué de mesa.',
            translation: 'Oh, how embarrassing! I got the wrong table.',
          ),
          StoryLine(
            id: 'es2_5',
            character: StoryCharacter.vikram,
            text: '¡No te preocupes! Toma asiento y prueba mis mejores tapas.',
            translation: 'Don\'t worry! Take a seat and taste my best tapas.',
          ),
          StoryLine(
            id: 'es2_6',
            character: StoryCharacter.bea,
            text: '¡Muchas gracias! ¡Esta comida huele fantástica!',
            translation: 'Thank you very much! This food smells fantastic!',
          ),
        ],
      ),
    ],

    // French
    'french': [
      const Story(
        id: 'fr_story_1',
        courseId: 'french',
        title: 'Le Croissant Chaud',
        translationTitle: 'The Warm Croissant',
        emoji: '🥐',
        xpReward: 25,
        gemReward: 15,
        lines: [
          StoryLine(
            id: 'fr1_1',
            character: null,
            text: 'Oscar et Bea entrent dans une boulangerie parisienne.',
            translation: 'Oscar and Bea enter a Parisian bakery.',
          ),
          StoryLine(
            id: 'fr1_2',
            character: StoryCharacter.oscar,
            text: 'Bonjour Madame ! Deux croissants chauds, s\'il vous plaît.',
            translation: 'Hello Madam! Two warm croissants, please.',
          ),
          StoryLine(
            id: 'fr1_3',
            character: StoryCharacter.bea,
            text: 'Et aussi deux cafés au lait bien chauds !',
            translation: 'And also two hot coffees with milk!',
            question: CheckpointQuestion(
              question: 'Que commande Bea en plus ?',
              options: [
                'Deux verres d\'eau',
                'Deux cafés au lait bien chauds',
                'Un gâteau au chocolat',
              ],
              correctIndex: 1,
            ),
          ),
          StoryLine(
            id: 'fr1_4',
            character: StoryCharacter.oscar,
            text: 'Le parfum du beurre et du café est incroyable.',
            translation: 'The scent of butter and coffee is incredible.',
          ),
          StoryLine(
            id: 'fr1_5',
            character: StoryCharacter.bea,
            text: 'Paris est vraiment magique le matin !',
            translation: 'Paris is truly magical in the morning!',
          ),
        ],
      ),
      const Story(
        id: 'fr_story_2',
        courseId: 'french',
        title: 'Le Passeport Perdu',
        translationTitle: 'The Lost Passport',
        emoji: '🛂',
        xpReward: 30,
        gemReward: 20,
        lines: [
          StoryLine(
            id: 'fr2_1',
            character: null,
            text: 'Vikram et Bea sont à l\'aéroport Charles de Gaulle.',
            translation: 'Vikram and Bea are at Charles de Gaulle airport.',
          ),
          StoryLine(
            id: 'fr2_2',
            character: StoryCharacter.vikram,
            text: 'Bea ! Au secours, j\'ai perdu mon passeport !',
            translation: 'Bea! Help, I lost my passport!',
          ),
          StoryLine(
            id: 'fr2_3',
            character: StoryCharacter.bea,
            text: 'Calme-toi Vikram ! Il n\'est pas dans ton sac à dos ?',
            translation: 'Calm down Vikram! Is it not in your backpack?',
            question: CheckpointQuestion(
              question: 'Quel est le problème de Vikram ?',
              options: [
                'Il a raté son avion',
                'Il pense avoir perdu son passeport',
                'Il a faim',
              ],
              correctIndex: 1,
            ),
          ),
          StoryLine(
            id: 'fr2_4',
            character: StoryCharacter.vikram,
            text: 'Non, j\'ai regardé partout ! Je ne peux pas voyager !',
            translation: 'No, I looked everywhere! I cannot travel!',
          ),
          StoryLine(
            id: 'fr2_5',
            character: StoryCharacter.bea,
            text: 'Vikram... regarde ta main gauche.',
            translation: 'Vikram... look at your left hand.',
          ),
          StoryLine(
            id: 'fr2_6',
            character: StoryCharacter.vikram,
            text: 'Ah ! Je l\'avais à la main ! Merci Bea, tu es géniale !',
            translation: 'Ah! I was holding it in my hand! Thanks Bea, you are great!',
          ),
        ],
      ),
    ],

    // Japanese
    'japanese': [
      const Story(
        id: 'ja_story_1',
        courseId: 'japanese',
        title: 'カフェで',
        translationTitle: 'At the Café',
        emoji: '🍵',
        xpReward: 25,
        gemReward: 15,
        lines: [
          StoryLine(
            id: 'ja1_1',
            character: null,
            text: 'JuniorとLinは渋谷のカフェに来ました。',
            translation: 'Junior and Lin came to a cafe in Shibuya.',
          ),
          StoryLine(
            id: 'ja1_2',
            character: StoryCharacter.junior,
            text: 'こんにちは！抹茶ラテをお願いします。',
            translation: 'Konnichiwa! Matcha latte o onegaishimasu. (Hello! A matcha latte please.)',
          ),
          StoryLine(
            id: 'ja1_3',
            character: StoryCharacter.lin,
            text: '私はおいしいチーズケーキを食べます。',
            translation: 'Watashi wa oishii chiizukeeki o tabemasu. (I will eat delicious cheesecake.)',
            question: CheckpointQuestion(
              question: 'Linは何を食べますか？ (What will Lin eat?)',
              options: [
                '寿司 (Sushi)',
                'チーズケーキ (Cheesecake)',
                'ラーメン (Ramen)',
              ],
              correctIndex: 1,
            ),
          ),
          StoryLine(
            id: 'ja1_4',
            character: StoryCharacter.junior,
            text: 'この抹茶ラテは甘くて温かいです！',
            translation: 'Kono matcha rate wa amakute atatakai desu! (This matcha latte is sweet and warm!)',
          ),
          StoryLine(
            id: 'ja1_5',
            character: StoryCharacter.lin,
            text: '日本のスイーツは最高ですね！',
            translation: 'Nihon no suiitsu wa saikou desu ne! (Japanese sweets are the best!)',
          ),
        ],
      ),
      const Story(
        id: 'ja_story_2',
        courseId: 'japanese',
        title: 'かわいい柴犬',
        translationTitle: 'Cute Shiba Inu',
        emoji: '🐕',
        xpReward: 30,
        gemReward: 20,
        lines: [
          StoryLine(
            id: 'ja2_1',
            character: null,
            text: 'BeaとOscarは公園を散歩しています。',
            translation: 'Bea and Oscar are walking in the park.',
          ),
          StoryLine(
            id: 'ja2_2',
            character: StoryCharacter.bea,
            text: '見て！あそこに小さくてかわいい柴犬がいます！',
            translation: 'Look! Over there is a small and cute Shiba Inu dog!',
          ),
          StoryLine(
            id: 'ja2_3',
            character: StoryCharacter.oscar,
            text: '本当ですね！名前はポチというそうです。',
            translation: 'Indeed! They say his name is Pochi.',
            question: CheckpointQuestion(
              question: '犬の名前は何ですか？ (What is the dog\'s name?)',
              options: [
                'タマ (Tama)',
                'ポチ (Pochi)',
                'シロ (Shiro)',
              ],
              correctIndex: 1,
            ),
          ),
          StoryLine(
            id: 'ja2_4',
            character: StoryCharacter.bea,
            text: 'ポチ、こんにちは！とても元気ですね。',
            translation: 'Pochi, hello! You are very energetic.',
          ),
          StoryLine(
            id: 'ja2_5',
            character: StoryCharacter.oscar,
            text: '天気が良くて犬も嬉しそうです。',
            translation: 'The weather is good and the dog looks happy too.',
          ),
        ],
      ),
    ],

    // Python Coding
    'python': [
      const Story(
        id: 'py_story_1',
        courseId: 'python',
        title: 'The Infinite Loop',
        translationTitle: 'The Infinite Loop',
        emoji: '🔄',
        xpReward: 25,
        gemReward: 15,
        lines: [
          StoryLine(
            id: 'py1_1',
            character: null,
            text: 'Junior is writing his first Python program late at night.',
            translation: 'Junior is writing his first Python script in the terminal.',
          ),
          StoryLine(
            id: 'py1_2',
            character: StoryCharacter.junior,
            text: 'Oscar! My terminal is spinning with millions of lines!',
            translation: 'Oscar! The terminal is printing endless text and won\'t stop!',
          ),
          StoryLine(
            id: 'py1_3',
            character: StoryCharacter.oscar,
            text: 'Junior, show me your while loop. What is your condition?',
            translation: 'Junior, show me your while loop. What is your condition?',
          ),
          StoryLine(
            id: 'py1_4',
            character: StoryCharacter.junior,
            text: 'I wrote: while count < 10: print("Learning Python!")',
            translation: 'I wrote: while count < 10: print("Learning Python!")',
            question: CheckpointQuestion(
              question: 'Why did Junior\'s loop run forever?',
              options: [
                'He used double quotes instead of single quotes',
                'He forgot to increment count += 1 inside the loop',
                'Python doesn\'t support while loops',
              ],
              correctIndex: 1,
              explanation: 'Without count += 1, count remains 0 forever so the condition is always True.',
            ),
          ),
          StoryLine(
            id: 'py1_5',
            character: StoryCharacter.oscar,
            text: 'Press Ctrl+C! You forgot to increment count += 1 inside the loop.',
            translation: 'Press Ctrl+C! You forgot to increment count += 1 inside the loop.',
          ),
          StoryLine(
            id: 'py1_6',
            character: StoryCharacter.junior,
            text: 'It worked! Now it prints exactly 10 times and finishes. Thanks Oscar!',
            translation: 'It worked! Now it prints exactly 10 times and finishes. Thanks Oscar!',
          ),
        ],
      ),
      const Story(
        id: 'py_story_2',
        courseId: 'python',
        title: 'Friday Deployment Bug',
        translationTitle: 'Friday Deployment Bug',
        emoji: '🐛',
        xpReward: 30,
        gemReward: 20,
        lines: [
          StoryLine(
            id: 'py2_1',
            character: null,
            text: 'Bea and Vikram are debugging code on Friday afternoon.',
            translation: 'Bea and Vikram are on-call inspecting server logs.',
          ),
          StoryLine(
            id: 'py2_2',
            character: StoryCharacter.bea,
            text: 'Vikram, the server crashed with IndexError: list index out of range!',
            translation: 'Vikram, the server crashed with IndexError: list index out of range!',
          ),
          StoryLine(
            id: 'py2_3',
            character: StoryCharacter.vikram,
            text: 'Did someone write: items[len(items)] to get the last element?',
            translation: 'Did someone write items[len(items)] to get the last element?',
            question: CheckpointQuestion(
              question: 'Why did items[len(items)] raise an IndexError?',
              options: [
                'Python lists are 0-indexed, so the last item is items[-1] or len - 1',
                'Lists in Python cannot hold strings',
                'You must use round brackets () for indexing',
              ],
              correctIndex: 0,
              explanation: 'In 0-indexed languages with length N, valid indices are 0 to N-1.',
            ),
          ),
          StoryLine(
            id: 'py2_4',
            character: StoryCharacter.bea,
            text: 'Yes, exactly! Python is 0-indexed. We should use items[-1]!',
            translation: 'Yes, exactly! Python is 0-indexed. We should use items[-1]!',
          ),
          StoryLine(
            id: 'py2_5',
            character: StoryCharacter.vikram,
            text: 'Fixed and deployed! All unit tests pass green. Have a nice weekend!',
            translation: 'Fixed and deployed! All unit tests pass green. Have a nice weekend!',
          ),
        ],
      ),
    ],
  };

  static List<Story> getStoriesForCourse(String courseId) {
    return storiesByCourse[courseId] ?? storiesByCourse['spanish']!;
  }
}
