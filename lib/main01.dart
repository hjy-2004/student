// ignore: unused_import
import 'dart:convert'; // 用于 JSON 编码
// ignore: unused_import
import 'dart:io'; // 用于文件操作

// ignore: unused_import
import 'package:excel/excel.dart'; //Excel
// ignore: unused_import
import 'package:fl_chart/fl_chart.dart'; // 添加图表库依赖
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
// ignore: unused_import
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
// ignore: unused_import
import 'package:open_file/open_file.dart';
// ignore: unused_import
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
// ignore: unused_import
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: unused_import
import 'package:url_launcher/url_launcher.dart';

import 'login_page.dart';

void main() {
  runApp(MyApp());
}

// 删除本地保存的用户名和密码
Future<void> _clearCredentials() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('username');
  await prefs.remove('password');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '学生成绩管理系统',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    GradesManagementScreen(),
    StatisticsScreen(),
    PersonalCenterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('学生成绩管理系统'),
        backgroundColor: Colors.amber,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amber, // 设置底部导航栏背景颜色为黄色
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: '成绩管理'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '统计报表'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '个人中心'),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white, // 选中项颜色
        unselectedItemColor: Colors.black, // 未选中项颜色
        type: BottomNavigationBarType.fixed, // 固定类型，确保样式一致
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('欢迎使用学生成绩管理系统！', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GradesManagementScreen()),
                );
              },
              child: Text('查看成绩'),
            ),
            ElevatedButton(
              onPressed: () {
                // 跳转到成绩添加页面，或弹出对话框添加成绩
              },
              child: Text('添加成绩'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StatisticsScreen()),
                );
              },
              child: Text('统计分析'),
            ),
            ElevatedButton(
              onPressed: () {
                // 实现导出数据功能
              },
              child: Text('导出数据'),
            ),
          ],
        ),
      ),
    );
  }
}

class GradesManagementScreen extends StatefulWidget {
  @override
  _GradesManagementScreenState createState() => _GradesManagementScreenState();
}

class _GradesManagementScreenState extends State<GradesManagementScreen> {
  List<Map<String, dynamic>> _grades = [
    {'name': '张三', 'subject': '数学', 'score': 95},
    {'name': '李四', 'subject': '英语', 'score': 88},
  ];

  // 在此处可以添加方法来加载其他写死的数据
  void _loadSampleData() {
    _grades.addAll([
      {'name': '王五', 'subject': '物理', 'score': 90},
      {'name': '赵六', 'subject': '化学', 'score': 85},
    ]);
  }

  @override
  void initState() {
    super.initState();
    _loadSampleData(); // 加载示例数据
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('成绩管理')),
      body: ListView.builder(
        itemCount: _grades.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                '${_grades[index]['name']} - ${_grades[index]['subject']}'),
            subtitle: Text('成绩: ${_grades[index]['score']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteGrade(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddGradeDialog();
        },
        child: Icon(Icons.add),
      ),
      persistentFooterButtons: [
        TextButton(
          onPressed: _exportData,
          child: Text('导出数据'),
        ),
      ],
    );
  }

  void _showAddGradeDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController subjectController = TextEditingController();
    final TextEditingController scoreController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('添加成绩'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: "姓名"),
              ),
              TextField(
                controller: subjectController,
                decoration: InputDecoration(hintText: "科目"),
              ),
              TextField(
                controller: scoreController,
                decoration: InputDecoration(hintText: "成绩"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addGrade(nameController.text, subjectController.text,
                    int.parse(scoreController.text));
                Navigator.of(context).pop();
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

  void _addGrade(String name, String subject, int score) {
    setState(() {
      _grades.add({'name': name, 'subject': subject, 'score': score});
    });
  }

  void _deleteGrade(int index) {
    setState(() {
      _grades.removeAt(index);
    });
  }

  void _exportData() async {
    try {
      var excel = Excel.createExcel();
      Sheet sheet = excel['成绩'];

      sheet.appendRow(['姓名', '科目', '成绩']);

      for (var grade in _grades) {
        sheet.appendRow([grade['name'], grade['subject'], grade['score']]);
      }

      final directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/grades.xlsx';
      final File file = File(filePath);

      final excelBytes = await excel.save() ?? [];
      if (excelBytes.isEmpty) {
        throw Exception('Excel 文件未生成。');
      }

      await file.writeAsBytes(excelBytes);
      print('成绩已导出到: $filePath');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('成绩已导出到: $filePath')),
      );

      _showViewFileDialog(filePath);
    } catch (e) {
      print('导出失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('导出失败: $e')),
      );
    }
  }

  void _showViewFileDialog(String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('导出成功'),
          content: Text('您要查看导出的文件吗？'),
          actions: [
            TextButton(
              onPressed: () {
                _openFile(filePath); // 打开文件
                Navigator.of(context).pop();
              },
              child: Text('查看'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
              child: Text('取消'),
            ),
          ],
        );
      },
    );
  }

  void _openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        // Use 'done' instead of 'success'
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('无法打开文件: ${result.message}')),
        );
        print('无法打开文件: ${result.message}');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('无法打开文件: $e')),
      );
    }
  }
}

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('统计报表')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            barGroups: [
              BarChartGroupData(
                x: 1,
                barRods: [BarChartRodData(toY: 95, color: Colors.blue)],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [BarChartRodData(toY: 88, color: Colors.green)],
              ),
              // 添加更多数据
            ],
          ),
        ),
      ),
    );
  }
}

class PersonalCenterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '个人中心',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('基本信息', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('姓名: 张三'),
            Text('学号: 123456'),
            Text('邮箱: zhangsan@example.com'),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // 弹出修改密码对话框
                _showChangePasswordDialog(context);
              },
              child: Text('修改密码'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // 弹出退出登录确认对话框
                _showLogoutConfirmation(context);
              },
              child: Text('退出登录'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('修改密码'),
          content: Column(
            children: [
              TextField(
                controller: newPasswordController,
                decoration: InputDecoration(hintText: "输入新密码"),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // TODO: 调用后台接口更新密码
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('密码修改成功')),
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
                // 清除用户登录信息
                await _clearCredentials(); // 清除本地存储的用户名和密码

                // 返回登录页面
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('确认'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            )
          ],
        );
      },
    );
  }
}
