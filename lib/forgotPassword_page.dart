import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2024_09_22/generated/intl/app_localizations.dart';

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
        _showErrorDialog(AppLocalizations.of(context)!.checkUserEmailError);
      }
    } catch (e) {
      _showErrorDialog(
        AppLocalizations.of(context)!.checkUserEmailFailure(e.toString()),
      );
    }
  }

  Future<void> _bindNewEmail() async {
    if (_emailController.text.isEmpty) {
      _showErrorDialog(AppLocalizations.of(context)!.emailCannotBeEmpty);
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
        if (message.contains(AppLocalizations.of(context)!.bindEmailSuccess)) {
          _showSuccessDialog(message);
        } else {
          _showErrorDialog(AppLocalizations.of(context)!.bindEmailFailure);
        }
      } else {
        _showErrorDialog(AppLocalizations.of(context)!.bindEmailFailure);
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 404 &&
            e.response?.data == AppLocalizations.of(context)!.userNotFound) {
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
        _showSuccessDialog(AppLocalizations.of(context)!.verificationCodeSent);
      } else {
        _showErrorDialog(
            AppLocalizations.of(context)!.verificationCodeSendFailed);
      }
    } catch (e) {
      _showErrorDialog('发送验证码失败: $e');
    }
  }

  Future<void> _resetPassword(
      String email, String code, String newPassword) async {
    if (email.isEmpty || code.isEmpty || newPassword.isEmpty) {
      _showErrorDialog(AppLocalizations.of(context)!.fieldsCannotBeEmpty);
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
        _showSuccessDialog(AppLocalizations.of(context)!.resetPasswordSuccess);
      } else {
        _showErrorDialog(AppLocalizations.of(context)!.resetPasswordFailure);
      }
    } catch (e) {
      _showErrorDialog('重置密码失败: $e');
    }
  }

  void _showSendVerificationDialog(String email) {
    // 隐藏部分邮箱
    String maskEmail(String email) {
      if (email.isNotEmpty && email.contains('@')) {
        int atIndex = email.indexOf('@');
        if (atIndex > 3) {
          return email.replaceRange(3, atIndex, '****');
        }
      }
      return email; // 如果邮箱格式不符合，直接返回原邮箱
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.verificationCodeHint),
          content: Text(AppLocalizations.of(context)!
              .sendingVerificationCodeToEmail(maskEmail(email))),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _sendVerificationCode(email);
                _showEnterVerificationCodeDialog(email);
              },
              child: Text(AppLocalizations.of(context)!.confirm),
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
          title: Text(AppLocalizations.of(context)!.verificationCodeHint),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context)!
                  .enterVerificationCodeSentToEmail(email)),
              SizedBox(height: 10),
              TextField(
                controller: _verificationCodeController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.verificationCode,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.newPasswordLabel,
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
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
              child: Text(AppLocalizations.of(context)!.resetPasswordButton),
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
          title: Text(AppLocalizations.of(context)!.bindEmailDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context)!.enterQqEmailToBind),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.qqEmail,
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _bindNewEmail();
              },
              child: Text(AppLocalizations.of(context)!.confirm),
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
          title: Text(AppLocalizations.of(context)!.errorDialogTitle),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            if (onConfirm != null)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm();
                },
                child: Text(AppLocalizations.of(context)!.confirm),
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
          title: Text(AppLocalizations.of(context)!.successDialogTitle),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (message.contains(
                    AppLocalizations.of(context)!.registrationSuccess)) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }
              },
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.forgotPassword)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.studentId),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkUserEmail,
              child: Text(AppLocalizations.of(context)!.nextStep),
            ),
          ],
        ),
      ),
    );
  }
}
