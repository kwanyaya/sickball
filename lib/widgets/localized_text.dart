import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class LocalizedText extends StatelessWidget {
  final String englishText;
  final String chineseText;
  final TextStyle? style;
  final TextAlign? textAlign;

  const LocalizedText({
    super.key,
    required this.englishText,
    required this.chineseText,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final text =
            languageProvider.currentLocale.languageCode == 'zh'
                ? chineseText
                : englishText;

        return Text(text, style: style, textAlign: textAlign);
      },
    );
  }
}

// Helper widget for localized content
class LocalizedContent {
  static String get(
    BuildContext context,
    String englishText,
    String chineseText,
  ) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    return languageProvider.currentLocale.languageCode == 'zh'
        ? chineseText
        : englishText;
  }
}
