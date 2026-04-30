import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:yannyamba/core/core.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  late List<bool> _expanded;

  // Use AppText keys for all FAQs so they can be localized in the project's
  // translation files. Ensure keys faqQuestion1..faqQuestion10 and
  // faqAnswer1..faqAnswer10 are added to the localization resources.
  late final List<Map<String, String>> faqs = [
    {'question': AppText.faqQuestion1.tr, 'answer': AppText.faqAnswer1.tr},
    {'question': AppText.faqQuestion2.tr, 'answer': AppText.faqAnswer2.tr},
    {'question': AppText.faqQuestion3.tr, 'answer': AppText.faqAnswer3.tr},
    {'question': AppText.faqQuestion4.tr, 'answer': AppText.faqAnswer4.tr},
    {'question': AppText.faqQuestion5.tr, 'answer': AppText.faqAnswer5.tr},
    {'question': AppText.faqQuestion6.tr, 'answer': AppText.faqAnswer6.tr},
    {'question': AppText.faqQuestion7.tr, 'answer': AppText.faqAnswer7.tr},
    {'question': AppText.faqQuestion8.tr, 'answer': AppText.faqAnswer8.tr},
    {'question': AppText.faqQuestion9.tr, 'answer': AppText.faqAnswer9.tr},
    {'question': AppText.faqQuestion10.tr, 'answer': AppText.faqAnswer10.tr},
  ];

  @override
  void initState() {
    super.initState();
    // initialize expansion state based on the number of faqs
    _expanded = List.filled(faqs.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppText.faqs.tr,
        showBackButton: true,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: _buildFAQItem(
              index: index,
              question: faq['question']!,
              answer: faq['answer']!,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFAQItem({
    required int index,
    required String question,
    required String answer,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _expanded[index] = !_expanded[index];
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                Icon(
                  _expanded[index]
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          alignment: Alignment.centerLeft,
          child: Text(
            answer,
            maxLines: _expanded[index] ? null : 1,
            overflow: _expanded[index]
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
            style: getTextStyle(fontSize: 14, color: AppColors.textColor2),
          ),
        ),
      ],
    );
  }
}
