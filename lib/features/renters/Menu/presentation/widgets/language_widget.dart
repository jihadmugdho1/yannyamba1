import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yannyamba/core/common/styles/global_text_style.dart';
import 'package:yannyamba/core/utils/constants/app_texts.dart';

class LanguageToggleWidget extends StatelessWidget {
  final String selectedLanguage;
  final ValueChanged<String> onChange;

  const LanguageToggleWidget({
    super.key,
    required this.selectedLanguage,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(Iconsax.language_circle, size: 24, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Text(
            AppText.language.tr,
            style: getTextStyle(
              fontSize: 18,
              font: AppFont.supreme,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE6E6E6),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [_languageOption('FR'), _languageOption('EN')],
            ),
          ),
        ],
      ),
    );
  }


  Widget _languageOption(String lang) {
    final bool isSelected = selectedLanguage == lang;

    return GestureDetector(
      onTap: () => onChange(lang),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          lang,
          style: getTextStyle(
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey.shade800,
          ),
        ),
      ),
    );
  }
}
