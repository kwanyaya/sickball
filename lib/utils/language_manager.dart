import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class LanguageManager {
  // Singleton pattern
  static final LanguageManager _instance = LanguageManager._internal();
  factory LanguageManager() => _instance;
  LanguageManager._internal();

  // Translation map
  static const Map<String, Map<String, String>> _translations = {
    // App general
    'app_title': {'en': 'SickBall', 'zh': 'SickBall'},
    'app_subtitle': {'en': 'Smart Sick Leave Generator', 'zh': '智慧病假產生器'},

    // Login screen
    'login_description': {
      'en': 'Generate creative and believable sick leave reasons instantly!',
      'zh': '立即產生有創意且可信的病假理由！',
    },
    'continue_with_google': {
      'en': 'Continue with Google',
      'zh': '使用 Google 繼續',
    },
    'track_usage': {'en': 'Track Usage', 'zh': '追蹤使用'},
    'easy_share': {'en': 'Easy Share', 'zh': '輕鬆分享'},
    'statistics': {'en': 'Statistics', 'zh': '統計數據'},

    // Home screen
    'generate_reason': {'en': 'Generate Reason', 'zh': '產生理由'},
    'generate_new_reason': {'en': 'Generate New Reason', 'zh': '產生新理由'},
    'use_this': {'en': 'Use This', 'zh': '使用此理由'},
    'copy_reason': {'en': 'Copy Reason', 'zh': '複製理由'},
    'share_reason': {'en': 'Share Reason', 'zh': '分享理由'},
    'share': {'en': 'Share', 'zh': '分享'},
    'sick_leave_recorded': {
      'en': 'Sick leave recorded successfully!',
      'zh': '病假記錄成功！',
    },
    'generating_reason': {'en': 'Generating reason...', 'zh': '正在產生理由...'},
    'welcome_back': {'en': 'Welcome back', 'zh': '歡迎回來'},
    'view_all': {'en': 'View All', 'zh': '查看全部'},
    'quick_stats': {'en': 'Quick Stats', 'zh': '快速統計'},
    'total': {'en': 'Total', 'zh': '總計'},

    // Dashboard
    'dashboard': {'en': 'Dashboard', 'zh': '儀表板'},
    'this_month': {'en': 'This Month', 'zh': '本月'},
    'this_year': {'en': 'This Year', 'zh': '今年'},
    'total_sick_days': {'en': 'Total Sick Days', 'zh': '總病假天數'},
    'recent_sick_leaves': {'en': 'Recent Sick Leaves', 'zh': '最近的病假記錄'},
    'no_sick_leaves_yet': {
      'en': 'No sick leaves recorded yet',
      'zh': '尚未有病假記錄',
    },
    'start_generating': {
      'en': 'Start generating your first sick leave reason!',
      'zh': '開始產生您的第一個病假理由！',
    },

    // General
    'logout': {'en': 'Logout', 'zh': '登出'},
    'language': {'en': 'Language', 'zh': '語言'},
    'english': {'en': 'English', 'zh': 'English'},
    'traditional_chinese': {'en': 'Traditional Chinese', 'zh': '繁體中文'},
    'reason_copied': {'en': 'Reason copied to clipboard!', 'zh': '理由已複製到剪貼簿！'},
    'user_not_found': {'en': 'User not found', 'zh': '找不到使用者'},
  };

  /// Get translated text for a given key
  /// Usage: LanguageManager.getText(context, 'app_title')
  static String getText(BuildContext context, String key) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    final languageCode = languageProvider.currentLocale.languageCode;

    final translation = _translations[key];
    if (translation == null) {
      print('⚠️ Translation key "$key" not found');
      return key; // Return the key itself as fallback
    }

    return translation[languageCode] ?? translation['en'] ?? key;
  }

  /// Get all available translation keys (for debugging)
  static List<String> getAllKeys() {
    return _translations.keys.toList();
  }

  /// Check if a translation key exists
  static bool hasKey(String key) {
    return _translations.containsKey(key);
  }
}

/// Convenient widget that automatically gets translation and rebuilds when language changes
class TranslatedText extends StatelessWidget {
  final String translationKey;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TranslatedText(
    this.translationKey, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final text = LanguageManager.getText(context, translationKey);
        return Text(
          text,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}
