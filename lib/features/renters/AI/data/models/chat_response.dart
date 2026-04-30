import 'chat_model.dart';

enum MessageStatus { sending, sent, delivered, failed }

class ChatResponse {
  final bool success;
  final String? message;
  final ChatMessage? data;
  final String? error;

  ChatResponse({required this.success, this.message, this.data, this.error});
}
