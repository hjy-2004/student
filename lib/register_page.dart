import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'api_constants.dart';
import 'generated/intl/app_localizations.dart';
import 'login_page.dart';

class StudentRegistrationPage extends StatefulWidget {
  @override
  _StudentRegistrationPageState createState() =>
      _StudentRegistrationPageState();
}

class _StudentRegistrationPageState extends State<StudentRegistrationPage> {
  int _currentStep = 0;
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();

  // 控件的控制器
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();

  String _className = '';
  String _studentName = '';
  String _teacherId = '';
  List<Map<String, dynamic>> _teachers = [];

  @override
  void initState() {
    super.initState();
    _fetchTeachers(); // 动态获取老师信息
  }

  Future<void> _fetchTeachers() async {
    try {
      final response = await Dio().get('$baseUrl/api/teachers');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          _teachers = data.map((teacher) {
            return {'id': teacher['id'].toString(), 'name': teacher['name']};
          }).toList();
        });
      }
    } catch (e) {
      print('获取老师信息失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.appBarTitle)),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _nextStep,
        onStepCancel:
            _currentStep > 0 ? () => setState(() => _currentStep--) : null,
        steps: _getSteps(),
      ),
    );
  }

  List<Step> _getSteps() {
    return [
      Step(
        title: Text(AppLocalizations.of(context)!.step1Title),
        content: Form(
          key: _formKeyStep1,
          child: Column(
            children: [
              TextFormField(
                controller: _studentIdController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.studentId),
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)!.studentIdHint
                    : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.password),
                obscureText: true,
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)!.passwordHint
                    : null,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.confirmPassword),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return AppLocalizations.of(context)!.passwordMismatchHint;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        isActive: _currentStep == 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text(AppLocalizations.of(context)!.step2Title),
        content: Form(
          key: _formKeyStep2,
          child: Column(
            children: [
              TextFormField(
                controller: _studentIdController, // 绑定到学号控制器
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.studentId),
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)!.studentIdHint
                    : null,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.classNameId),
                onChanged: (value) {
                  _className = value; // 确保班级信息被更新
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入班级';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.studentName),
                onChanged: (value) => _studentName = value,
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)!.studentNameHint
                    : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.selectTeacher),
                items: _teachers.map((teacher) {
                  return DropdownMenuItem<String>(
                    value: teacher['id'],
                    child: Text(teacher['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _teacherId = value ?? '';
                  });
                },
                validator: (value) => value == null
                    ? AppLocalizations.of(context)!.selectTeacherHint
                    : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.qqEmail),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null ||
                      !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                    return AppLocalizations.of(context)!.qqEmailHint;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        isActive: _currentStep == 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text(AppLocalizations.of(context)!.step3Title),
        content: Form(
          key: _formKeyStep3,
          child: Column(
            children: [
              TextFormField(
                controller: _verificationCodeController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.verificationCode,
                  suffixIcon: TextButton(
                    onPressed: _sendVerificationCode,
                    child: Text(
                        AppLocalizations.of(context)!.sendVerificationCode),
                  ),
                ),
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)!.verificationCodeHint
                    : null,
              ),
            ],
          ),
        ),
        isActive: _currentStep == 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
    ];
  }

  void _nextStep() async {
    if (_currentStep == 0 && _formKeyStep1.currentState!.validate()) {
      _formKeyStep1.currentState!.save();
      bool step1Success = await _registerStep1(context);
      if (step1Success) {
        setState(() {
          _currentStep += 1;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.step1Failed)));
      }
    } else if (_currentStep == 1 && _formKeyStep2.currentState!.validate()) {
      _formKeyStep2.currentState!.save();
      // 确保保存的数据都是有效的
      if (_className.isNotEmpty) {
        bool step2Success = await _registerStep2();
        if (step2Success) {
          setState(() {
            _currentStep += 1;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.step2Failed)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.classInfoMissing)));
      }
    } else if (_currentStep == 2 && _formKeyStep3.currentState!.validate()) {
      _formKeyStep3.currentState!.save();
      bool step3Success = await _registerStep3();
      if (step3Success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.registrationSuccess)));
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.step3Failed)));
      }
    }
  }

  Future<bool> _isUsernameExists(String username) async {
    try {
      final response = await Dio().get(
        '$baseUrl/students/check-username',
        queryParameters: {'username': username},
      );
      return response.data; // 这里假设返回的是布尔值
    } catch (e) {
      print('检查学号失败: $e');
      return false;
    }
  }

  Future<bool> _registerStep1(BuildContext context) async {
    final usernameExists = await _isUsernameExists(_studentIdController.text);
    if (usernameExists) {
      print('学号已经注册');
      // 使用对话框提示用户
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.registerFailed),
            content: Text(AppLocalizations.of(context)!.usernameExists),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 关闭对话框
                },
                child: Text(AppLocalizations.of(context)!.confirm),
              ),
            ],
          );
        },
      );
      return false;
    }

    try {
      final response = await Dio().post(
        '$baseUrl/user/register',
        data: {
          'username': _studentIdController.text,
          'password': _passwordController.text,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('步骤 1 注册失败: $e');
      return false;
    }
  }

  String? _registeredStudentId; // 用于保存已注册的学号

  Future<bool> _registerStep2() async {
    try {
      // 检查学号是否已注册
      bool studentExists = false;

      if (_registeredStudentId == null ||
          _studentIdController.text != _registeredStudentId) {
        final checkResponse = await Dio().get(
          '$baseUrl/api/students/exists',
          queryParameters: {'username': _studentIdController.text},
        );

        if (checkResponse.statusCode == 200 && checkResponse.data['exists']) {
          studentExists = true; // 如果存在，则标记为 true
        }
      }

      // 获取所选老师的完整信息
      Map<String, dynamic> selectedTeacher = _teachers.firstWhere(
        (teacher) => teacher['id'] == _teacherId,
        orElse: () => {},
      );

      if (selectedTeacher.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(AppLocalizations.of(context)!.teacherSelectionError)));
        return false;
      }

      // 插入或更新数据
      if (studentExists) {
        // 学号已存在，调用更新的 API
        final updateResponse = await Dio().put(
          '$baseUrl/students/update-by-uid/${_registeredStudentId}', // 使用UID
          data: {
            'stuClass': _className,
            'stuName': _studentName,
            'email': _emailController.text,
            'teacher': {
              'id': selectedTeacher['id'],
              'name': selectedTeacher['name'],
            },
          },
        );

        if (updateResponse.statusCode == 200) {
          // 更新成功
          return true;
        } else {
          return false;
        }
      } else {
        // 学号不存在，调用插入的 API
        final response = await Dio().post(
          '$baseUrl/students/addOrUpdate',
          data: {
            'stuClass': _className,
            'stuName': _studentName,
            'username': _studentIdController.text,
            'email': _emailController.text,
            'teacher': {
              'id': selectedTeacher['id'],
              'name': selectedTeacher['name'],
            },
          },
        );

        if (response.statusCode == 200) {
          // 保存已注册的 UID，而不是学号
          _registeredStudentId = response.data['uid'].toString();
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      print('步骤 2 注册失败: $e');
      return false;
    }
  }

  Future<bool> _registerStep3() async {
    try {
      final response = await Dio().post(
        '$baseUrl/api/verify-registration-code',
        data: {
          'qqEmail': _emailController.text,
          'verificationCode': _verificationCodeController.text,
        },
        options: Options(
          validateStatus: (status) {
            return status != null && status < 500; // 只抛出500以上的错误
          },
        ),
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.registrationSuccess)));
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false, // 清空导航堆栈
        ); // 跳转到登录页面
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response.data['message'] ??
                AppLocalizations.of(context)!.verificationCodeError)));
        return false;
      }
    } catch (e) {
      print('步骤 3 注册失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.checkInput)));
      return false;
    }
  }

  Future<void> _sendVerificationCode() async {
    if (_emailController.text.isNotEmpty) {
      try {
        final response = await Dio().post(
          '$baseUrl/api/send-registration-verification-code',
          data: {'qqEmail': _emailController.text},
        );
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.verificationCodeSent)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  AppLocalizations.of(context)!.verificationCodeSendFailed)));
        }
      } catch (e) {
        print('发送验证码失败: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                AppLocalizations.of(context)!.verificationCodeSendFailed)));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.enterEmail)));
    }
  }
}
