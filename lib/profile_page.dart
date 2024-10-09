import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_constants.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String studentName = '加载中...';
  String studentId = '加载中...';
  String studentClass = '加载中...';
  String studentEmail = '加载中...';
  String? avatarPath; // 头像路径

  @override
  void initState() {
    super.initState();
    _loadStudentInfo();
  }

  Future<void> _loadStudentInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedStudentId = prefs.getString('studentId'); // 获取学号

    // 清理之前的头像数据
    if (studentId != savedStudentId) {
      // 如果学生ID不一样，清除之前的头像
      await prefs.remove('avatarPath_$studentId');
      avatarPath = null; // 重新设置头像为null
    }

    String? savedAvatarPath =
        prefs.getString('avatarPath_$savedStudentId'); // 根据学号加载头像路径

    // 从本地存储加载其他学生信息
    String? savedStudentName = prefs.getString('studentName');
    String? savedStudentClass = prefs.getString('studentClass');
    String? savedStudentEmail = prefs.getString('studentEmail');

    setState(() {
      avatarPath = savedAvatarPath; // 设置头像路径
      studentName = savedStudentName ?? '加载中...';
      studentId = savedStudentId ?? '加载中...';
      studentClass = savedStudentClass ?? '加载中...';
      studentEmail = savedStudentEmail ?? '加载中...';
    });

    // 如果没有加载到学生信息，则请求
    if (savedStudentName == null ||
        savedStudentId == null ||
        savedStudentClass == null ||
        savedStudentEmail == null) {
      await _getStudentInfo();
    }
  }

  Future<void> _getStudentInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username'); // 获取学号

    if (username == null) {
      setState(() {
        studentName = '未登录';
        studentId = '未登录';
        studentClass = '未登录';
        studentEmail = '未登录';
      });
      return;
    }

    try {
      Dio dio = Dio();
      Response response = await dio.get(
        '$baseUrl/api/students/getStudent',
        queryParameters: {'username': username},
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        String newStudentId = response.data[0]['username'] ?? '未知学号';

        // 获取对应学号的头像路径
        String? savedAvatarPath = prefs.getString('avatarPath_$newStudentId');

        setState(() {
          studentName = response.data[0]['stuName'] ?? '未知姓名';
          studentId = newStudentId;
          studentClass = response.data[0]['stuClass'] ?? '未知班级';
          studentEmail = response.data[0]['email'] ?? '未提供邮箱';
          avatarPath = savedAvatarPath ?? avatarPath; // 保持之前加载的头像路径
        });

        // 将学生信息保存到本地
        await prefs.setString('studentName', studentName);
        await prefs.setString('studentId', studentId);
        await prefs.setString('studentClass', studentClass);
        await prefs.setString('studentEmail', studentEmail);
      } else {
        setState(() {
          studentName = '获取失败';
          studentId = '获取失败';
          studentClass = '获取失败';
          studentEmail = '获取失败';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        studentName = '获取失败';
        studentId = '获取失败';
        studentClass = '获取失败';
        studentEmail = '获取失败';
      });
    }
  }

  Future<void> _refreshStudentInfo() async {
    await _getStudentInfo();
  }

  Future<void> _pickAvatar() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarPath = image.path; // 更新头像路径
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'avatarPath_$studentId', avatarPath!); // 保存头像路径到本地，键为学号

      // 返回修改后的头像路径
      Navigator.pop(context, avatarPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('个人资料')),
      body: RefreshIndicator(
        onRefresh: _refreshStudentInfo,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage:
                  avatarPath != null ? FileImage(File(avatarPath!)) : null,
              child: avatarPath == null ? Icon(Icons.person, size: 60) : null,
            ),
            SizedBox(height: 10),
            Text('姓名: $studentName', style: TextStyle(fontSize: 20)),
            Text('学号: $studentId', style: TextStyle(fontSize: 20)),
            Text('班级: $studentClass', style: TextStyle(fontSize: 20)),
            Text('邮箱: $studentEmail', style: TextStyle(fontSize: 20)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _pickAvatar,
              child: Text('修改头像'),
            ),
          ],
        ),
      ),
    );
  }
}
