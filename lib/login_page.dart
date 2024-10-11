import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_constants.dart';
import 'forgotPassword_page.dart';
import 'generated/intl/app_localizations.dart';
import 'home_page.dart';
import 'register_page.dart';

// 检查本地是否保存了用户名和密码
Future<bool> _checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username') != null &&
      prefs.getString('password') != null;
}

// 保存用户名和密码到本地存储
Future<void> _saveCredentials(String username, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
  await prefs.setString('password', password);
  await prefs.setString('currentUser', username); // 保存当前用户名
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus().then((isLoggedIn) {
      if (isLoggedIn) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  Future<void> login() async {
    // 1. 检查输入是否为空
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        String lang = Localizations.localeOf(context).languageCode;
        if (lang == 'zh') {
          _message = '用户名或密码不能为空'; // 中文错误信息
        } else {
          _message = 'Username and password cannot be empty'; // 英文错误信息
        }
      });
      return; // 输入无效，直接返回，不进行登录请求
    }

    try {
      Dio dio = Dio();
      final response = await dio.post(
        '$baseUrl/user/login',
        options: Options(contentType: Headers.formUrlEncodedContentType),
        data: {
          'user_name': _usernameController.text,
          'user_password': _passwordController.text,
        },
      );

      // 2. 检查服务器返回结果
      if (response.statusCode == 200) {
        final jsonResponse = response.data;

        if (jsonResponse['success']) {
          String username = jsonResponse['data']['username'];
          String password = _passwordController.text;

          await _saveCredentials(username, password);

          setState(() {
            // 登录成功信息
            String lang = Localizations.localeOf(context).languageCode;
            if (lang == 'zh') {
              _message = jsonResponse['message']; // 服务器返回的中文消息
            } else {
              _message = 'Login successful!'; // 英文消息
            }
          });

          // 跳转到主页
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          // 处理登录失败
          setState(() {
            String lang = Localizations.localeOf(context).languageCode;
            if (lang == 'zh') {
              _message = jsonResponse['message']; // 服务器返回的中文失败消息
            } else {
              _message = 'Login failed: ${jsonResponse['message']}'; // 英文失败消息
            }
          });
        }
      } else {
        // 登录失败的本地化信息
        setState(() {
          _message = AppLocalizations.of(context)!.loginFailed; // 使用本地化的失败消息
        });
      }
    } catch (e) {
      // 捕获异常并显示本地化的错误信息
      setState(() {
        _message = AppLocalizations.of(context)!.loginFailed; // 使用本地化的失败消息
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.login)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.username,
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.password,
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text(AppLocalizations.of(context)!.login),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.grey[200],
              child: Text(
                _message,
                style: TextStyle(
                  color: _message
                          .contains(AppLocalizations.of(context)!.loginSuccess)
                      ? Colors.green
                      : Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudentRegistrationPage()));
              },
              child: Text(
                AppLocalizations.of(context)!.noAccountRegister,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage()));
              },
              child: Text(
                AppLocalizations.of(context)!.forgotPassword,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
