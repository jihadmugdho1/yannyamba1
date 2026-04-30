import 'package:flutter/material.dart';
import 'package:yannyamba/core/core.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  const ChatInput({
    super.key,
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: !isSending,
                decoration: InputDecoration(
                  hintText: 'Write your message',
                  hintStyle: getTextStyle(color: AppColors.textColor2),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
            isSending
                ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90E2).withValues(alpha: .5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : InkWell(
                    onTap: onSend,
                    borderRadius: BorderRadius.circular(20),
                    child: const Icon(Icons.send, color: Color(0xFF4A90E2)),
                  ),
          ],
        ),
      ),
    );
  }
}
