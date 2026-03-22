import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../services/ai_chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final AIChatService _chatService = AIChatService();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;

  ChatProvider() {
    _messages.add(ChatMessage(
      text:
          'Welcome, cosmic traveler! \u2728\u{1F30C}\n\nI am astromini, your celestial guide through the mysteries of the zodiac. I can read the stars for your daily horoscope, explore love compatibility, offer career guidance, and reveal the secrets of any zodiac sign.\n\nWhat cosmic wisdom do you seek today?',
      sender: MessageSender.ai,
    ));
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messages.add(ChatMessage(text: text.trim(), sender: MessageSender.user));
    _isTyping = true;
    notifyListeners();

    try {
      final response = await _chatService.generateResponse(text);
      _messages.add(ChatMessage(text: response, sender: MessageSender.ai));
    } catch (e) {
      _messages.add(ChatMessage(
        text: 'The cosmic signals are temporarily disrupted. Please try again in a moment. \u{1F30C}',
        sender: MessageSender.ai,
      ));
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    _messages.add(ChatMessage(
      text:
          'A fresh start under new stars! \u2728 What would you like to explore?',
      sender: MessageSender.ai,
    ));
    notifyListeners();
  }
}
