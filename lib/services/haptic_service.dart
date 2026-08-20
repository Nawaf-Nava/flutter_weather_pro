import 'package:flutter/services.dart';

enum HapticLevel {
  selection,
  light,
  medium,
  heavy,
  vibrate,
}

class HapticService {
  static bool isHapticsEnabled = true;

  /// تفعيل أو تعطيل الاهتزاز في التطبيق
  static void toggleHaptics() {
    isHapticsEnabled = !isHapticsEnabled;
    if (isHapticsEnabled) {
      trigger(HapticLevel.light);
    }
  }

  /// تنفيذ الاهتزاز بحسب المستوى المطلوب
  static Future<void> trigger([HapticLevel level = HapticLevel.light]) async {
    if (!isHapticsEnabled) return;

    switch (level) {
      case HapticLevel.selection:
        // اهتزاز فائق الخفة عند التنقل بين عناصر القائمة والتمرير
        await HapticFeedback.selectionClick();
        break;

      case HapticLevel.light:
        // نقرة خفيفة للأزرار العادية وتبديل الوحدات
        await HapticFeedback.lightImpact();
        break;

      case HapticLevel.medium:
        // نقرة متوسطة عند حفظ مدينة جديدة أو تبديل التبويب
        await HapticFeedback.mediumImpact();
        break;

      case HapticLevel.heavy:
        // نقرة قوية عند حذف مدينة أو عند وصول تنبيه جوي خطير
        await HapticFeedback.heavyImpact();
        break;

      case HapticLevel.vibrate:
        // نمط اهتزاز قياسي كامل
        await HapticFeedback.vibrate();
        break;
    }
  }
}