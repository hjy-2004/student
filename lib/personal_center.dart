import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2024_09_22/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'account_management.dart';
import 'generated/intl/app_localizations.dart';
import 'notebook_page.dart';
import 'profile_page.dart';

class PersonalCenterScreen extends StatefulWidget {
  @override
  _PersonalCenterScreenState createState() => _PersonalCenterScreenState();
}

class _PersonalCenterScreenState extends State<PersonalCenterScreen> {
  String studentName = '加载中...';
  String? avatarPath; // 添加头像路径的变量
  // 之前的学生ID，用于清理头像数据
  String? previousStudentId;

  // 切换用户的方法
  void _onUserSwitch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('avatarPath_$previousStudentId'); // 清理之前用户的头像数据

    // 加载新用户的信息
    await _getStudentInfo();
  }

  @override
  void initState() {
    super.initState();
    _getStudentInfo();
  }

  Future<void> _getStudentInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? studentId = prefs.getString('username'); // 使用 'username'

    if (studentId == null) {
      setState(() {
        studentName = '未登录';
      });
      return;
    }

    // 获取头像路径，使用特定的键
    avatarPath = prefs.getString('avatarPath_$studentId'); // 使用学号作为键

    try {
      // 使用 Dio 进行网络请求
      Dio dio = Dio();
      Response response = await dio.get(
        '$baseUrl/api/students/getStudent', // 替换为你的 baseUrl
        queryParameters: {'username': studentId},
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        setState(() {
          studentName = response.data[0]['stuName'] ?? '未知姓名';
        });
      } else {
        setState(() {
          studentName = '获取失败';
        });
      }
    } catch (e) {
      setState(() {
        studentName = '获取失败';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations =
        AppLocalizations.of(context)!; // Get the localizations instance

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 用户头像和姓名
            GestureDetector(
              onTap: () {
                _showProfilePage(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: avatarPath != null
                            ? FileImage(File(avatarPath!))
                            : AssetImage('images/2.jpg') as ImageProvider,
                      ),
                      SizedBox(width: 10),
                      Text(
                        studentName,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            // 设置选项
            GestureDetector(
              onTap: () {
                _showSettingsDialog(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 10),
                      Text(localizations.settings,
                          style: TextStyle(fontSize: 15)),
                    ],
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(height: 30),
            // 笔记本选项
            GestureDetector(
              onTap: () {
                _showNotebookPage(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.note,
                        color: Colors.green[400],
                      ),
                      SizedBox(width: 10),
                      Text(localizations.notebook,
                          style: TextStyle(
                              fontSize:
                                  15)), // Assuming you added this in localizations
                    ],
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  void _showProfilePage(BuildContext context) async {
    final newAvatarPath = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );

    if (newAvatarPath != null) {
      setState(() {
        avatarPath = newAvatarPath; // 更新头像路径
      });

      // 更新 SharedPreferences 中的头像路径
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatarPath', avatarPath!);
    }
  }

  void _showSettingsDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // Get localizations

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.settings), // Use localized title
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                    localizations.accountManagement), // Use localized string
                onTap: () {
                  Navigator.of(context).pop(); // 关闭对话框
                  _showAccountManagement(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
              child: Text(localizations.close), // Use localized close text
            ),
          ],
        );
      },
    );
  }

  void _showAccountManagement(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccountManagementPage()),
    );
  }

  void _showNotebookPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotebookPage()),
    );
  }
}
