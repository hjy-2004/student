import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 导入
// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/intl/app_localizations.dart';
import 'generated/l10n.dart';
import 'home_page.dart';
import 'login_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleNotifier>(
      builder: (context, localeNotifier, child) {
        return MaterialApp(
          home: SplashScreen(),
          locale: localeNotifier.currentLocale, // 设置当前的 locale
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate, // 添加你的本地化委托
            S.delegate, // 使用 S.delegate 替代 AppLocalizations.delegate
          ],
          supportedLocales: S.delegate.supportedLocales, // 确保支持的语言列表与 S 一致
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // 模拟延迟1秒
    await Future.delayed(Duration(seconds: 1));

    bool isLoggedIn = await _checkLoginStatus();
    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    return username != null && password != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // 启动页面背景颜色
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 这里可以添加你的启动页面内容，例如 logo 或者图片
            Icon(
              Icons.school,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              '学生成绩管理系统',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocaleNotifier extends ChangeNotifier {
  Locale _currentLocale = Locale('zh');

  Locale get currentLocale => _currentLocale;

  void setLocale(Locale newLocale) {
    _currentLocale = newLocale;
    notifyListeners();
    print('Locale changed to: ${newLocale.languageCode}'); // Debugging
  }
}
