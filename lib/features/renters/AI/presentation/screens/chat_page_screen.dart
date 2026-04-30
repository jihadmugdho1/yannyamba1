import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/utils/constants/app_texts.dart';
import '../../controllers/chat_controller.dart';
import '../../data/models/chat_model.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_shimmer.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/chat_input.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final ChatController _chatController;
  Worker? _messageWorker;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _chatController = Get.find<ChatController>();
    _ownsController = false;

    _messageWorker = ever<List<ChatMessage>>(_chatController.messages, (_) {
      if (mounted && _chatController.messages.isNotEmpty) {
        _scrollToBottom();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatController.loadChatHistory();
    });
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    _messageController.clear();
    _chatController.sendMessage(messageText);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C3E50)),
          onPressed: () => Get.back<void>(),
        ),
        title: Text(
          AppText.aiAssistant.tr,
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF4A90E2)),
            onPressed: () => _chatController.refreshChat(),
          ),
        ],
      ),

      body: SafeArea(
        child: Obx(() {
          final isLoading = _chatController.isLoading.value;

          if (isLoading) {
            return const ChatShimmer();
          }

          return Stack(
            children: [
              Positioned.fill(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                  itemCount:
                      _chatController.messages.length +
                      (_chatController.isTyping.value ? 1 : 0) +
                      1,
                  itemBuilder: (context, index) {
                    if (index ==
                        _chatController.messages.length +
                            (_chatController.isTyping.value ? 1 : 0)) {
                      return const SizedBox(height: 20);
                    }

                    if (_chatController.isTyping.value &&
                        index == _chatController.messages.length) {
                      return const TypingIndicator();
                    }

                    final message = _chatController.messages[index];
                    return ChatMessageBubble(message: message);
                  },
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ChatInput(
                  controller: _messageController,
                  isSending: _chatController.isSendingMessage.value,
                  onSend: _sendMessage,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageWorker?.dispose();
    if (_ownsController && Get.isRegistered<ChatController>()) {
      Get.delete<ChatController>();
    }
    super.dispose();
  }
}
