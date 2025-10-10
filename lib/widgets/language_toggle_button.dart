import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return PopupMenuButton<Locale>(
          icon: const Icon(Icons.language),
          tooltip: 'Change Language / 更改語言',
          onSelected: (Locale locale) {
            languageProvider.changeLanguage(locale);
          },
          itemBuilder: (BuildContext context) {
            return LanguageProvider.supportedLocales.map((locale) {
              String languageName;
              String flagEmoji;

              switch (locale.languageCode) {
                case 'en':
                  languageName = 'English';
                  flagEmoji = '🇺🇸';
                  break;
                case 'zh':
                  languageName = '繁體中文';
                  flagEmoji = '🇹🇼';
                  break;
                default:
                  languageName = locale.languageCode.toUpperCase();
                  flagEmoji = '🌐';
              }

              return PopupMenuItem<Locale>(
                value: locale,
                child: Row(
                  children: [
                    Text(flagEmoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(languageName),
                    if (languageProvider.currentLocale.languageCode ==
                        locale.languageCode)
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(Icons.check, size: 16, color: Colors.green),
                      ),
                  ],
                ),
              );
            }).toList();
          },
        );
      },
    );
  }
}
