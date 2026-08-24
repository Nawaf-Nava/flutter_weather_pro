import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_screen.dart';
import 'products_page.dart'; // سنقوم بإنشائه الآن

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _username = '';

 final List<Widget> _pages = [
    const ProductsPage(),
    const Center(child: Text('المفضلة', style: TextStyle(fontSize: 24))),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // جلب اسم المستخدم المحفوظ
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'مستخدم';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('أهلاً بك، $_username'),
        centerTitle: true,
      ),
      body: _pages[_currentIndex], // عرض الصفحة بناءً على الفهرس
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'المفضلة'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}

// صفحة الملف الشخصي مدمجة هنا لتسهيل عملية تسجيل الخروج
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // دالة تسجيل الخروج وحذف البيانات المحفوظة
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // حذف البيانات المحفوظة بالكامل
    
    if (!context.mounted) return;
    
    // العودة إلى الشاشة الافتتاحية
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _logout(context),
        icon: const Icon(Icons.logout),
        label: const Text('تسجيل الخروج', style: TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
      ),
    );
  }
}