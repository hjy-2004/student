import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'api_constants.dart';
import 'login_page.dart';
import 'register_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  Future<void> _checkUserEmail() async {
    try {
      final response = await Dio().post(
        '$baseUrl/api/check-user-email',
        data: {'username': _usernameController.text},
      );

      if (response.statusCode == 200) {
        bool hasEmail = response.data['hasEmail'] ?? false;

        if (hasEmail) {
          String email = response.data['email'] ?? '';
          _showSendVerificationDialog(email);
        } else {
          _showBindEmailDialog();
        }
      } else {
        _showErrorDialog('无法检查用户邮箱，请重试');
      }
    } catch (e) {
      _showErrorDialog('检查用户邮箱失败: $e');
    }
  }

  Future<void> _bindNewEmail() async {
    if (_emailController.text.isEmpty) {
      _showErrorDialog('邮箱不能为空');
      return;
    }

    try {
      final response = await Dio().post(
        '$baseUrl/api/bind-email',
        data: {
          'username': _usernameController.text,
          'email': _emailController.text,
        },
      );

      // 检查状态码
      if (response.statusCode == 200) {
        String message = response.data;
        if (message.contains('邮箱绑定成功')) {
          _showSuccessDialog(message);
        } else {
          _showErrorDialog('邮箱绑定失败，请重试');
        }
      } else {
        _showErrorDialog('邮箱绑定失败，请重试');
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 404 &&
            e.response?.data == '用户不存在，请先去注册账号') {
          // 用户不存在，提示去注册账号
          _showErrorDialog(
            '用户不存在，请先注册账号',
            onConfirm: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StudentRegistrationPage()),
              );
            },
          );
        } else {
          _showErrorDialog('绑定邮箱失败: ${e.response?.data ?? e.message}');
        }
      } else {
        _showErrorDialog('绑定邮箱失败: $e');
      }
    }
  }

  Future<void> _sendVerificationCode(String email) async {
    try {
      final response = await Dio().post(
        '$baseUrl/api/send-verification-code',
        data: {'qqEmail': email},
      );

      if (response.statusCode == 200) {
        _showSuccessDialog('验证码已发送，请检查邮箱');
      } else {
        _showErrorDialog('发送验证码失败，请重试');
      }
    } catch (e) {
      _showErrorDialog('发送验证码失败: $e');
    }
  }

  Future<void> _resetPassword(
      String email, String code, String newPassword) async {
    if (email.isEmpty || code.isEmpty || newPassword.isEmpty) {
      _showErrorDialog('邮箱、验证码和新密码不能为空');
      return;
    }

    try {
      final response = await Dio().post(
        '$baseUrl/api/reset-password',
        data: {
          'qqEmail': '$email',
          'verificationCode': _verificationCodeController.text,
          'newPassword': _newPasswordController.text,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200 && response.data['success']) {
        _showSuccessDialog('密码重置成功，请使用新密码登录');
      } else {
        _showErrorDialog('密码重置失败，请重试');
      }
    } catch (e) {
      _showErrorDialog('重置密码失败: $e');
    }
  }

  void _showSendVerificationDialog(String email) {
    // 隐藏部分邮箱
    String maskedEmail = email.replaceRange(3, email.indexOf('@'), '****');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('验证邮箱'),
          content: Text('将通过你的QQ邮箱 $maskedEmail 发送验证码'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _sendVerificationCode(email);
                _showEnterVerificationCodeDialog(email);
              },
              child: Text('确定'),
            ),
          ],
        );
      },
    );
  }

  void _showEnterVerificationCodeDialog(String email) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('输入验证码'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('请输入发送到你的QQ邮箱 $email 的验证码'),
              SizedBox(height: 10),
              TextField(
                controller: _verificationCodeController,
                decoration: InputDecoration(
                  labelText: '验证码',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '新密码',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetPassword(
                  email,
                  _newPasswordController.text,
                  _verificationCodeController.text,
                );
              },
              child: Text('验证并重置密码'),
            ),
          ],
        );
      },
    );
  }

  void _showBindEmailDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('绑定邮箱'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('请输入你的QQ邮箱以进行绑定'),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'QQ邮箱',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _bindNewEmail();
              },
              child: Text('确定'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message, {VoidCallback? onConfirm}) {
    print('Dialog message: $message, has onConfirm: ${onConfirm != null}');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            if (onConfirm != null)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm();
                },
                child: Text('确定'),
              ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('成功'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (message.contains('密码重置成功')) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }
              },
              child: Text('确定'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('忘记密码')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: '学号'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkUserEmail,
              child: Text('下一步'),
            ),
          ],
        ),
      ),
    );
  }
}
