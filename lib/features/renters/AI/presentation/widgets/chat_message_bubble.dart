import 'package:flutter/material.dart';
import 'package:yannyamba/core/core.dart';
import '../../data/models/chat_model.dart';
import 'ai_apartment_card.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: message.isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!message.isUser)
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(right: 8, bottom: 4),
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(ImagePath.aiIcon, fit: BoxFit.cover),
                ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  margin: EdgeInsets.only(
                    left: message.isUser ? 50 : 0,
                    right: message.isUser ? 0 : 50,
                  ),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? const Color(0xFF4A90E2)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20).copyWith(
                      bottomLeft: message.isUser
                          ? const Radius.circular(20)
                          : const Radius.circular(4),
                      bottomRight: message.isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Display apartments if available
          if (!message.isUser &&
              message.apartments != null &&
              message.apartments!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: message.apartments!
                    .map((apartment) => AIApartmentCard(apartment: apartment))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
