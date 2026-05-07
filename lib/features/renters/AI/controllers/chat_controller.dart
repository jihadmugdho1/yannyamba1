import 'dart:ui';

import 'package:get/get.dart';
import 'package:yannyamba/features/renters/AI/data/services/chat_services.dart';
import '../data/models/chat_model.dart';

class ChatController extends GetxController {
  ChatController({ChatServices? apiService})
    : _apiService = apiService ?? ChatServices();

  final ChatServices _apiService;

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSendingMessage = false.obs;
  final RxBool isTyping = false.obs;
  final RxnString error = RxnString();
  final Map<String, Size> messageSizes = {};

  Future<void> loadChatHistory() async {
    if (isLoading.value) return;

    _setLoading(true);
    _setError(null);

    try {
      // Load chat history from backend
      final loadResponse = await _apiService.loadChatHistory();

      if (!loadResponse.success) {
        throw Exception(loadResponse.error ?? "Failed to load chat history");
      }

      // Get the loaded chat history
      final chatHistory = await _apiService.getChatHistory();
      messages.assignAll(chatHistory);
    } catch (e) {
      _setError("Failed to load chat history: ${e.toString()}");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendMessage(String messageText) async {
    if (messageText.trim().isEmpty || isSendingMessage.value) return;

    _setSendingMessage(true);
    _setError(null);

    try {
      final sendResponse = await _apiService.sendMessage(messageText);

      if (!sendResponse.success) {
        throw Exception(sendResponse.error ?? "Failed to send message");
      }
      if (sendResponse.data != null) {
        _addMessage(sendResponse.data!);
      }
      isTyping.value = true;
      final aiResponse = await _apiService.getAIResponse(messageText);
      isTyping.value = false;
      if (aiResponse.success && aiResponse.data != null) {
        _addMessage(aiResponse.data!);
      } else {
        _addMessage(
          ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text:
                "Sorry, I'm having trouble responding right now. Please try again.",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      isTyping.value = false;
      _setError("Failed to send message: ${e.toString()}");
    } finally {
      _setSendingMessage(false);
    }
  }

  void clearUserData() {
    messages.clear();
    _setError(null);
    isTyping.value = false;
    messageSizes.clear();
  }

  void clearError() {
    _setError(null);
  }

  Future<void> refreshChat() async {
    if (isLoading.value) return;

    _setLoading(true);
    _setError(null);

    try {
      // Clear the conversation history in the service
      _apiService.clearHistory();
      // Clear local messages
      messages.clear();
      // Load fresh chat history (which will be empty after clearing)
      final chatHistory = await _apiService.getChatHistory();
      messages.assignAll(chatHistory);
    } catch (e) {
      _setError("Failed to refresh chat: ${e.toString()}");
    } finally {
      _setLoading(false);
    }
  }

  void _addMessage(ChatMessage message) {
    messages.add(message);
  }

  void _setLoading(bool loading) {
    isLoading.value = loading;
  }

  void _setSendingMessage(bool sending) {
    isSendingMessage.value = sending;
  }

  void _setError(String? value) {
    error.value = value;
  }
}
