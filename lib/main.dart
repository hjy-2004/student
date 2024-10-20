import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'file_viewer_page.dart'; // 引入文件查看页面
import 'generated/intl/app_localizations.dart';
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
  static const platform = MethodChannel('file_viewer');
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleNotifier>(builder: (context, localeNotifier, child) {
      return MaterialApp(
        navigatorKey: navigatorKey, // 设置全局导航键
        home: SplashScreen(),
        locale: localeNotifier.currentLocale,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''),
          Locale('zh', ''),
        ],
      );
    });
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
    _requestPermissions();
    _navigateToNextScreen();
    _setupMethodChannel(); // 在此处设置 MethodChannel
  }

  Future<void> _requestPermissions() async {
    // 请求存储权限
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    // 你可以在这里检查权限是否被授予
    if (await Permission.storage.isGranted) {
      print("存储权限已被授予");
    } else {
      print("存储权限被拒绝");
    }
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 1));
    bool isLoggedIn = await _checkLoginStatus();
    if (isLoggedIn) {
      MyApp.navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      MyApp.navigatorKey.currentState?.pushReplacement(
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

  void _setupMethodChannel() {
    MyApp.platform.setMethodCallHandler((call) async {
      if (call.method == "openFile") {
        String filePath = call.arguments;
        print("Attempting to open file: $filePath");
        MyApp.navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => FileViewerPage(filePath: filePath),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 100, color: Colors.white),
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
  }
}
