import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: unused_import
import 'api_constants.dart';
import 'login_page.dart';

class AccountManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('账号管理')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('修改密码'),
              onTap: () {
                _showChangePasswordDialog(context);
              },
            ),
            ListTile(
              title: Text('退出登录'),
              onTap: () {
                _showLogoutConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('修改密码'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                decoration: InputDecoration(hintText: "输入旧密码"),
                obscureText: true,
              ),
              SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                decoration: InputDecoration(hintText: "输入新密码"),
                obscureText: true,
              ),
              SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(hintText: "确认新密码"),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String oldPassword = oldPasswordController.text;
                String newPassword = newPasswordController.text;
                String confirmPassword = confirmPasswordController.text;

                if (newPassword != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('新密码和确认密码不匹配')),
                  );
                  return;
                }

                if (oldPassword.isEmpty ||
                    newPassword.isEmpty ||
                    confirmPassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('密码不能为空')),
                  );
                  return;
                }

                // 调用后台接口更新密码
                bool success = await _updatePassword(oldPassword, newPassword);
                if (success) {
                  // 清除本地登录信息
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove('username');
                  await prefs.remove('password');

                  // 显示成功提示
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('密码修改成功，请重新登录')),
                  );

                  // 延迟一会儿再跳转到登录页面，以确保用户能看到 SnackBar 消息
                  await Future.delayed(Duration(seconds: 2));

                  // 关闭弹窗
                  Navigator.of(context).pop(); // 先关闭弹窗

                  // 跳转到登录页面并清空导航堆栈
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false, // 清空导航堆栈
                  );
                } else {
                  // 显示失败提示
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('修改密码失败，请重试')),
                  );
                }
              },
              child: Text('确认'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _updatePassword(String oldPassword, String newPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username'); // 获取当前用户名

    if (username == null) {
      // 如果未获取到用户名，返回 false
      return false;
    }

    try {
      // 创建 Dio 实例
      Dio dio = Dio();
      // 构建请求体
      Map<String, dynamic> data = {
        'username': username,
        'password': oldPassword,
        'newPassword': newPassword,
      };

      // 发送 PUT 请求至后端接口
      Response response = await dio.put(
        '$baseUrl/api/user/password',
        data: data,
      );

      // 检查响应状态码
      if (response.statusCode == 200) {
        return true; // 密码更新成功
      } else {
        return false; // 密码更新失败
      }
    } on DioException catch (e) {
      // 处理请求错误
      print('修改密码失败: ${e.response?.data ?? e.message}');
      return false;
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('确认退出'),
          content: Text('您确定要退出登录吗？'),
          actions: [
            TextButton(
              onPressed: () async {
                await _clearCredentials();
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false, // 清空导航堆栈
                );
              },
              child: Text('确认'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
          ],
        );
      },
    );
  }
}

Future<void> _clearCredentials() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('username');
  await prefs.remove('password');
}
