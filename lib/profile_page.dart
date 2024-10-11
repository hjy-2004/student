import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_constants.dart';
import 'generated/l10n.dart'; // 引入本地化支持

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String studentName = '';
  String studentId = '';
  String studentClass = '';
  String studentEmail = '';
  String? avatarPath; // 头像路径

  @override
  void initState() {
    super.initState();
    _loadStudentInfo();
  }

  Future<void> _loadStudentInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedStudentId = prefs.getString('studentId'); // 获取学号

    if (studentId != savedStudentId) {
      await prefs.remove('avatarPath_$studentId');
      avatarPath = null;
    }

    String? savedAvatarPath = prefs.getString('avatarPath_$savedStudentId');
    String? savedStudentName = prefs.getString('studentName');
    String? savedStudentClass = prefs.getString('studentClass');
    String? savedStudentEmail = prefs.getString('studentEmail');

    setState(() {
      avatarPath = savedAvatarPath;
      studentName = savedStudentName ?? S.of(context).loading;
      studentId = savedStudentId ?? S.of(context).loading;
      studentClass = savedStudentClass ?? S.of(context).loading;
      studentEmail = savedStudentEmail ?? S.of(context).loading;
    });

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
        studentName = S.of(context).notLoggedIn;
        studentId = S.of(context).notLoggedIn;
        studentClass = S.of(context).notLoggedIn;
        studentEmail = S.of(context).notLoggedIn;
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
        String newStudentId =
            response.data[0]['username'] ?? S.of(context).failedToFetch;

        String? savedAvatarPath = prefs.getString('avatarPath_$newStudentId');

        setState(() {
          studentName =
              response.data[0]['stuName'] ?? S.of(context).failedToFetch;
          studentId = newStudentId;
          studentClass =
              response.data[0]['stuClass'] ?? S.of(context).failedToFetch;
          studentEmail =
              response.data[0]['email'] ?? S.of(context).failedToFetch;
          avatarPath = savedAvatarPath ?? avatarPath;
        });

        await prefs.setString('studentName', studentName);
        await prefs.setString('studentId', studentId);
        await prefs.setString('studentClass', studentClass);
        await prefs.setString('studentEmail', studentEmail);
      } else {
        setState(() {
          studentName = S.of(context).failedToFetch;
          studentId = S.of(context).failedToFetch;
          studentClass = S.of(context).failedToFetch;
          studentEmail = S.of(context).failedToFetch;
        });
      }
    } catch (e) {
      setState(() {
        studentName = S.of(context).failedToFetch;
        studentId = S.of(context).failedToFetch;
        studentClass = S.of(context).failedToFetch;
        studentEmail = S.of(context).failedToFetch;
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
        avatarPath = image.path;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatarPath_$studentId', avatarPath!);

      Navigator.pop(context, avatarPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).profileTitle)),
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
            Text('${S.of(context).studentName} $studentName',
                style: TextStyle(fontSize: 20)),
            Text('${S.of(context).studentId} $studentId',
                style: TextStyle(fontSize: 20)),
            Text('${S.of(context).studentClass} $studentClass',
                style: TextStyle(fontSize: 20)),
            Text('${S.of(context).studentEmail} $studentEmail',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _pickAvatar,
              child: Text(S.of(context).updateAvatar),
            ),
          ],
        ),
      ),
    );
  }
}
