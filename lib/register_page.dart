import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'api_constants.dart';
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
      final response = await Dio().get('$baseUrl:8081/api/teachers');
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
      appBar: AppBar(title: Text('学生注册')),
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
        title: Text('步骤 1'),
        content: Form(
          key: _formKeyStep1,
          child: Column(
            children: [
              TextFormField(
                controller: _studentIdController,
                decoration: InputDecoration(labelText: '学号'),
                validator: (value) => value!.isEmpty ? '请输入学号' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: '密码'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? '请输入密码' : null,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: '确认密码'),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return '两次输入的密码不一致';
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
        title: Text('步骤 2'),
        content: Form(
          key: _formKeyStep2,
          child: Column(
            children: [
              TextFormField(
                controller: _studentIdController, // 绑定到学号控制器
                decoration: InputDecoration(labelText: '学号'),
                validator: (value) => value!.isEmpty ? '请输入学号' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '班级'),
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
                decoration: InputDecoration(labelText: '姓名'),
                onChanged: (value) => _studentName = value,
                validator: (value) => value!.isEmpty ? '请输入姓名' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: '选择老师'),
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
                validator: (value) => value == null ? '请选择老师' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'QQ邮箱'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null ||
                      !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                    return '请输入正确的QQ邮箱';
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
        title: Text('步骤 3'),
        content: Form(
          key: _formKeyStep3,
          child: Column(
            children: [
              TextFormField(
                controller: _verificationCodeController,
                decoration: InputDecoration(
                  labelText: '验证码',
                  suffixIcon: TextButton(
                    onPressed: _sendVerificationCode,
                    child: Text('发送验证码'),
                  ),
                ),
                validator: (value) => value!.isEmpty ? '请输入验证码' : null,
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('步骤 1 注册失败，请检查输入内容')));
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
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('步骤 2 注册失败，请检查输入内容')));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('班级信息不能为空')));
      }
    } else if (_currentStep == 2 && _formKeyStep3.currentState!.validate()) {
      _formKeyStep3.currentState!.save();
      bool step3Success = await _registerStep3();
      if (step3Success) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('注册成功')));
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('步骤 3 注册失败，请检查输入内容')));
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
            title: Text('注册失败'),
            content: Text('学号已经注册，请使用其他学号'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 关闭对话框
                },
                child: Text('确定'),
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('请选择正确的老师')));
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('注册成功')));
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false, // 清空导航堆栈
        ); // 跳转到登录页面
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.data['message'] ?? '验证码错误或已过期')));
        return false;
      }
    } catch (e) {
      print('步骤 3 注册失败: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('注册失败，请检查输入内容')));
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
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('验证码已发送到您的QQ邮箱')));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('发送验证码失败，请重试')));
        }
      } catch (e) {
        print('发送验证码失败: $e');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('发送验证码失败，请重试')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('请先输入QQ邮箱')));
    }
  }
}
