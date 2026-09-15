import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import '../../theme/app_colors.dart';

class SpeakingPracticeScreen extends StatefulWidget {
  const SpeakingPracticeScreen({Key? key}) : super(key: key);

  @override
  State<SpeakingPracticeScreen> createState() => _SpeakingPracticeScreenState();
}

class _SpeakingPracticeScreenState extends State<SpeakingPracticeScreen> with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speechToText;
  bool _isListening = false;
  bool _isSpeechInitialized = false;
  String _recognizedWords = '';
  
  // The phrase we want the user to practice
  final String _targetPhrase = "Hello, I am learning English";
  final String _targetPhraseBangla = "হ্যালো, আমি ইংরেজি শিখছি";

  double _confidenceLevel = 0.0;
  bool _isEvaluating = false;
  double _score = 0.0;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
    _initSpeech();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  void _initSpeech() async {
    _isSpeechInitialized = await _speechToText.initialize(
      onError: (error) => debugPrint('Error: $error'),
      onStatus: (status) => debugPrint('Status: $status'),
    );
    setState(() {});
  }

  void _startListening() async {
    if (!_isSpeechInitialized) {
      _initSpeech();
    }
    
    // Clear previous results
    setState(() {
      _recognizedWords = '';
      _isEvaluating = false;
      _score = 0.0;
    });

    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: 'en_US',
      cancelOnError: true,
      partialResults: true,
    );
    
    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
    
    _evaluatePronunciation();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _recognizedWords = result.recognizedWords;
      if (result.hasConfidenceRating && result.confidence > 0) {
        _confidenceLevel = result.confidence;
      }
    });
  }

  void _evaluatePronunciation() {
    if (_recognizedWords.isEmpty) return;
    
    setState(() {
      _isEvaluating = true;
    });

    List<String> targetWords = _targetPhrase.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').trim().split(RegExp(r'\s+'));
    List<String> spokenWords = _recognizedWords.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').trim().split(RegExp(r'\s+'));
    
    int matchedCount = 0;
    List<String> remainingTargetWords = List.from(targetWords);
    
    for (var word in spokenWords) {
      if (remainingTargetWords.contains(word)) {
        matchedCount++;
        remainingTargetWords.remove(word);
      }
    }
    
    double rawScore = matchedCount / targetWords.length;
    
    // Make the scoring more forgiving for learners
    if (rawScore >= 0.8) {
      // If they get 80% or more of the words right, give them a perfect score!
      rawScore = 1.0; 
    } else if (rawScore >= 0.5) {
      // Give a slight bump to decent attempts
      rawScore = (rawScore + 0.15); 
    }
    
    setState(() {
      _score = (rawScore * 100).clamp(0, 100);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _speechToText.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pronunciation Practice', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: LinearProgressIndicator(
                value: 0.3,
                backgroundColor: Colors.grey.shade200,
                color: AppColors.green,
                minHeight: 10,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 40),
            
            // Instruction
            const Text(
              "Speak this sentence loudly:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            
            // Target Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  )
                ],
                border: Border.all(color: Colors.grey.shade200, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    _targetPhrase,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _targetPhraseBangla,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Result Display
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Text(
                      _recognizedWords.isEmpty ? "Tap the mic and start speaking..." : _recognizedWords,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        color: _isListening ? AppColors.blue : Colors.black87,
                        fontStyle: _recognizedWords.isEmpty ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_isEvaluating && _score > 0) ...[
                      Text(
                        "Score: ${_score.toInt()}/100",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: _score >= 80 ? AppColors.green : (_score >= 50 ? Colors.orange : Colors.red),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _score >= 80 ? "Excellent pronunciation! 🎉" : (_score >= 50 ? "Good try, keep practicing! 👍" : "Let's try that again! 💪"),
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ]
                  ],
                ),
              ),
            ),

            // Microphone Button
            GestureDetector(
              onTapDown: (_) => _startListening(),
              onTapUp: (_) => _stopListening(),
              onTapCancel: () => _stopListening(),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Container(
                    padding: EdgeInsets.all(_isListening ? 15.0 + (_animationController.value * 10) : 15.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isListening ? AppColors.blue.withOpacity(0.2) : Colors.transparent,
                    ),
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: _isListening ? AppColors.blue : AppColors.green,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_isListening ? AppColors.blue : AppColors.green).withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _isListening ? "Release to send" : "Hold to speak",
              style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
