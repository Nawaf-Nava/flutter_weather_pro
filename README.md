# ⛅ تطبيق الطقس الذكي المتكامل | Flutter Weather Pro Application

تطبيق طقس احترافي متكامل مبني باستخدام **Flutter 3.x** و **Dart 3** مع بنية برمجية قياسية قائمة على **BLoC Pattern**.

---

## 📱 المميزات الرئيسية (Features)
- 🌦️ **توقعات دقيقة للطقس**: بيانات حية لدرجات الحرارة، الرطوبة، سرعة الرياح، مؤشر UV، الضغط الجوي، ونقطة الندى.
- ⚡ **رادار طقس تفاعلي (Interactive Radar)**: محاكاة رادار دوبلر للأمطار والسحب والرياح باستخدام `CustomPainter`.
- 🌐 **دعم كامل للغة العربية والإنجليزية (RTL / LTR)**: مع خطوط Google Fonts الاحترافية (Cairo).
- 📴 **العمل بدون إنترنت (Offline Caching)**: تخزين مؤقت تلقائي لبيانات المدن المفضلة عبر `SharedPreferences`.
- 📳 **اهتزازات لمسية واقعية (Haptic Feedback)**: استجابة لمسية فيزيائية لجميع التفاعلات.
- 🔔 **نظام إشعارات فورية (Push Notifications)**: تنبيهات الطقس العاجل والموجز الصباحي.
- 🧩 **ودجات الشاشة الرئيسية (Home Screen & Lock Screen Widgets)**.
- 👑 **بوابة اشتراكات VIP (In-App Purchases / RevenueCat)**.

---

## 🚀 كيفية تشغيل المشروع على جهازك (How to Run)

### المتطلبات الأساسية:
1. تثبيت **Flutter SDK** (الإصدار 3.10 أو أحدث).
2. تثبيت **Android Studio** أو **VS Code** مع إضافة Flutter & Dart.

### خطوات التشغيل:
```bash
# 1. الدخول إلى مجلد المشروع
cd flutter_weather_pro

# 2. تحميل الحزم والمكتبات
flutter pub get

# 3. تشغيل التطبيق على المحاكي أو جهازك الحقيقي
flutter run
```

### لبناء نسخة إنتاج جاهزة للمتاجر (Release Build):
```bash
# للأندرويد (Google Play APK / AAB)
flutter build appbundle --release
flutter build apk --release

# للآيفون (Apple App Store)
flutter build ipa --release
```

---

## 📂 هيكلية المشروع (Project Architecture)
```
lib/
├── main.dart                    # نقطة دخول التطبيق وإعداد BLoC
├── bloc/                        # إدارة الحالة بنمط BLoC
│   ├── weather_bloc.dart
│   ├── weather_event.dart
│   └── weather_state.dart
├── models/                      # نماذج البيانات (Models)
│   └── weather_models.dart
├── screens/                     # الشاشات الرئيسية
│   ├── weather_home_screen.dart
│   ├── radar_screen.dart
│   └── cities_management_screen.dart
├── widgets/                     # العناصر والرسومات التفاعلية
│   ├── weather_canvas_painter.dart
│   ├── weather_radar_canvas.dart
│   ├── hourly_forecast_strip.dart
│   └── weekly_forecast_list.dart
└── services/                    # طبقة الاتصال والخدمات
    ├── weather_api_service.dart
    ├── location_service.dart
    ├── offline_cache_manager.dart
    ├── push_notification_service.dart
    ├── home_widget_service.dart
    └── in_app_purchase_service.dart
```

تم إنشاء هذا المشروع بدقة متناهية ليكون جاهزاً للرفع المباشر إلى Google Play و Apple App Store.
