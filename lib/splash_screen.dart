import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// صفحات مؤقتة حتى نقوم ببرمجتها في الخطوات القادمة
import 'home_page.dart'; 
import 'signup_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // انتظار لمدة ثانيتين حسب المتطلبات
    await Future.delayed(const Duration(seconds: 2));

    // التحقق من حالة تسجيل الدخول باستخدام SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!mounted) return;

    // التوجيه بناءً على حالة تسجيل الدخول
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined, // أيقونة مؤقتة كشعار
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'متجر المنتجات',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(), // مؤشر تحميل
          ],
        ),
      ),
    );
  }
}