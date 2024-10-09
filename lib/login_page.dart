import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: unused_import
import 'api_constants.dart';
import 'forgotPassword_page.dart';
import 'home_page.dart';
// ignore: unused_import
import 'register_page.dart'; // 假设注册页面的文件名为 register_page.dart

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

      if (response.statusCode == 200) {
        final jsonResponse = response.data;

        if (jsonResponse['success']) {
          String username = jsonResponse['data']['username'];
          String password = _passwordController.text; // 获取密码

          await _saveCredentials(username, password); // 保存用户名和密码

          setState(() {
            _message = '登录成功！';
          });

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          setState(() {
            _message = '登录失败：${jsonResponse['message']}';
          });
        }
      } else {
        setState(() {
          _message = '登录失败：${response.data}';
        });
      }
    } catch (e) {
      setState(() {
        _message = '登录失败：$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('登录')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: '用户名')),
            TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: '密码'),
                obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text('登录')),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.grey[200],
              child: Text(_message,
                  style: TextStyle(
                      color:
                          _message.contains('成功') ? Colors.green : Colors.red,
                      fontSize: 16)),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            StudentRegistrationPage())); // 跳转到注册页面
              },
              child: Text(
                '没有账号吗？点击注册',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // TODO: 跳转到忘记密码页面
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage()));
              },
              child: Text(
                '忘记密码了吗？',
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
