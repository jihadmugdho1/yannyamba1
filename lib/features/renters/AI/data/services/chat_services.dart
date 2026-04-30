import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/services/storage_service.dart';
import 'package:yannyamba/features/renters/AI/data/models/chat_model.dart';
import 'package:yannyamba/features/renters/AI/data/models/chat_response.dart';
import 'package:yannyamba/features/renters/AI/data/models/ai_apartment_model.dart';

class ChatServices {
  static const String _baseUrl = 'http://46.224.80.189:8000/api/v1/api/v1/chat';
  static const String _chatHistoryUrl =
      'http://46.224.80.189:8000/api/v1/api/v1/chat-history';

  // Store conversation history locally
  final List<ChatMessage> _conversationHistory = [];

  Future<List<ChatMessage>> getChatHistory() async {
    // Return the stored conversation history
    return List.from(_conversationHistory);
  }

  /// Load chat history from the backend
  Future<ChatResponse> loadChatHistory() async {
    try {
      // Get current user ID from StorageService
      final userId =
          await StorageService.getUserId() ??
          await StorageService.getAuthRegisteredPhone() ??
          'anonymous_user';

      AppLoggerHelper.debug(
        'ChatServices: Loading chat history for user ID: $userId',
      );

      final response = await http.get(
        Uri.parse('$_chatHistoryUrl/$userId'),
        headers: {'accept': 'application/json'},
      );

      AppLoggerHelper.debug(
        'ChatServices: Chat history response: ${response.body} ${response.statusCode}}',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Clear existing history
        _conversationHistory.clear();

        // Parse and add messages to conversation history
        for (var item in data) {
          final type = item['type'] as String;
          final timestamp = DateTime.parse(item['timestamp'] as String);
          final id = item['_id'] as String;

          if (type == 'human') {
            // User message
            final content = item['content'] as String;
            _conversationHistory.add(
              ChatMessage(
                id: id,
                text: content,
                isUser: true,
                timestamp: timestamp,
                status: MessageStatus.sent,
              ),
            );
          } else if (type == 'ai') {
            // AI message
            final content = item['content'] as Map<String, dynamic>;
            final generalResponse =
                content['general_response'] as String? ?? '';

            // Parse apartments if available
            List<AIApartment>? apartments;
            if (content['apartments'] != null &&
                content['apartments'] is List) {
              final apartmentsList = content['apartments'] as List;
              if (apartmentsList.isNotEmpty) {
                apartments = apartmentsList
                    .map(
                      (apt) =>
                          AIApartment.fromJson(apt as Map<String, dynamic>),
                    )
                    .toList();
              }
            }

            _conversationHistory.add(
              ChatMessage(
                id: id,
                text: generalResponse,
                isUser: false,
                timestamp: timestamp,
                status: MessageStatus.sent,
                apartments: apartments,
              ),
            );
          }
        }

        AppLoggerHelper.debug(
          'ChatServices: Loaded ${_conversationHistory.length} messages from history',
        );

        return ChatResponse(
          success: true,
          message: "Chat history loaded successfully",
          data: null,
        );
      } else {
        AppLoggerHelper.error(
          'ChatServices: Failed to load chat history: ${response.statusCode}',
        );
        return ChatResponse(
          success: false,
          error: "Failed to load chat history: ${response.statusCode}",
        );
      }
    } catch (e) {
      AppLoggerHelper.error(
        'ChatServices: Error loading chat history: ${e.toString()}',
      );
      return ChatResponse(
        success: false,
        error: "Error loading chat history: ${e.toString()}",
      );
    }
  }

  Future<ChatResponse> sendMessage(String message) async {
    // Create user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // Add to conversation history
    _conversationHistory.add(userMessage);

    return ChatResponse(
      success: true,
      message: "Message sent successfully",
      data: userMessage,
    );
  }

  Future<ChatResponse> getAIResponse(String userMessage) async {
    try {
      // Get current user ID from StorageService
      final userId =
          await StorageService.getUserId() ??
          await StorageService.getAuthRegisteredPhone() ??
          'anonymous_user';

      AppLoggerHelper.debug(
        'ChatServices: Sending message for user ID: $userId',
      );

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'message': userMessage, 'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponseText = data['general_response'] as String?;

        // Parse apartments if available
        List<AIApartment>? apartments;
        if (data['apartments'] != null && data['apartments'] is List) {
          apartments = (data['apartments'] as List)
              .map((apt) => AIApartment.fromJson(apt as Map<String, dynamic>))
              .toList();
        }

        if (aiResponseText != null && aiResponseText.isNotEmpty) {
          final aiMessage = ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: aiResponseText,
            isUser: false,
            timestamp: DateTime.now(),
            apartments: apartments,
          );

          // Add to conversation history
          _conversationHistory.add(aiMessage);

          return ChatResponse(
            success: true,
            message: "AI response received",
            data: aiMessage,
          );
        } else {
          return ChatResponse(success: false, error: "Empty response from AI");
        }
      } else {
        return ChatResponse(
          success: false,
          error: "Failed to get AI response: ${response.statusCode}",
        );
      }
    } catch (e) {
      return ChatResponse(
        success: false,
        error: "Error connecting to AI: ${e.toString()}",
      );
    }
  }

  // Clear conversation history
  void clearHistory() {
    _conversationHistory.clear();
  }
}
