import '../../services/ai_service.dart';
import 'package:provider/provider.dart';
import '../../providers/game_progress_provider.dart';
import '../../services/curriculum_data.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../widgets/duo_mascot.dart';

// Global variable to persist chat history across screen navigations
final List<Map<String, dynamic>> _globalMessages = [
  {
    'isUser': false,
    'text': 'Squawk! Hello! I am your AI language partner. Let\'s practice some English! What would you like to talk about?',
  }
];

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<GameProgressProvider>();
      final course = CurriculumData.getCourse(provider.activeCourseId);
      final targetLanguage = course.title;
      // We assume Bangla to English means base is Bangla
      final baseLanguage = provider.activeCourseId == 'bangla_to_english' ? 'Bangla' : 'English';
      AiService.initializeChat(targetLanguage, baseLanguage);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    // Force keyboard to dismiss when leaving the chat screen
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty || _isTyping) return;
    
    final text = _controller.text.trim();
    setState(() {
      _globalMessages.insert(0, {'isUser': true, 'text': text});
      _globalMessages.insert(0, {'isUser': false, 'text': ''}); // Placeholder for stream
      _isTyping = true;
    });
    _controller.clear();
    _focusNode.requestFocus();

    // Stream dynamic AI response via Gemini
    try {
      final stream = AiService.sendMessageStream(text);
      String fullResponse = '';
      
      await for (final chunk in stream) {
        if (!mounted) break;
        setState(() {
          fullResponse += chunk;
          _globalMessages[0] = {'isUser': false, 'text': fullResponse};
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _globalMessages[0] = {'isUser': false, 'text': 'Squawk! I hit a snag.'};
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Row(
          children: [
            DuoMascot(size: 36, mood: MascotMood.happy),
            SizedBox(width: 8),
            Text('Chat with Parrot', style: TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _globalMessages.length,
              itemBuilder: (context, index) {
                final msg = _globalMessages[index];
                final isUser = msg['isUser'] as bool;
                
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.green : Colors.white,
                      borderRadius: BorderRadius.circular(20).copyWith(
                        bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(20),
                        bottomLeft: !isUser ? const Radius.circular(0) : const Radius.circular(20),
                      ),
                      border: isUser ? null : Border.all(color: AppColors.greyBorder, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: isUser ? AppColors.greenDark : AppColors.greyBorder,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      msg['text'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        color: isUser ? Colors.white : AppColors.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Input Area
          Container(
            padding: const EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.greyBorder, width: 2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Focus(
                    onKeyEvent: (node, event) {
                      if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
                        _sendMessage();
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      textInputAction: TextInputAction.send,
                      onEditingComplete: _sendMessage,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Type your message in English...',
                        hintStyle: const TextStyle(color: AppColors.textMuted),
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: AppColors.blueDark, offset: Offset(0, 3)),
                      ],
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}
