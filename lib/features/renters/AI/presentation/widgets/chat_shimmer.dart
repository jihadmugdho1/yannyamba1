import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatShimmer extends StatelessWidget {
  const ChatShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: 6,
            itemBuilder: (_, index) {
              final isUser = index % 2 == 0;
              return _shimmerBubble(isUser);
            },
          ),
        ),
        _shimmerInput(),
      ],
    );
  }

  Widget _shimmerBubble(bool isUser) {
    final widths = [120.0, 180.0, 240.0]..shuffle();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(right: 8, top: 4),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          Flexible(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 40,
                width: widths.first,
                margin: EdgeInsets.only(
                  left: isUser ? 50 : 0,
                  right: isUser ? 0 : 50,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerInput() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
