import 'dart:io';

import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2024_09_22/api_constants.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'generated/intl/app_localizations.dart';

class GradesManagementScreen extends StatefulWidget {
  @override
  _GradesManagementScreenState createState() => _GradesManagementScreenState();
}

class _GradesManagementScreenState extends State<GradesManagementScreen> {
  List<Map<String, dynamic>> _grades = [];
  Map<String, dynamic>? _searchedStudent;
  final TextEditingController _searchController = TextEditingController();
  final Dio _dio = Dio();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchGradesData();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchGradesData() async {
    try {
      final response = await _dio.get('$baseUrl/api/students/getAllStudents');
      if (response.statusCode == 200) {
        setState(() {
          _grades =
              List<Map<String, dynamic>>.from(response.data.map((student) => {
                    'uid': student[0],
                    'stuClass': student[1],
                    'name': student[2],
                    'totalCredits': student[3] ?? '--',
                  }));
        });
        // print('Fetched grades: $_grades');
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('无法获取成绩数据: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(AppLocalizations.of(context)!.gradesManagement)),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchStudentId,
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchedStudent = null;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onSubmitted: (value) {
                    _searchStudent(value);
                  },
                ),
                SizedBox(height: 20),
                _searchedStudent != null
                    ? Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${AppLocalizations.of(context)!.studentName}: ${_searchedStudent!['name']}',
                                  style: TextStyle(fontSize: 18)),
                              SizedBox(height: 8),
                              Text(
                                  '${AppLocalizations.of(context)!.className}: ${_searchedStudent!['stuClass']}',
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(height: 8),
                              Text(
                                  '${AppLocalizations.of(context)!.totalCredits}: ${_searchedStudent!['totalCredits']}',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      )
                    : Text(
                        AppLocalizations.of(context)!.enterStudentIdToSearch),
                SizedBox(height: 20),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('学号')),
                            DataColumn(label: Text('姓名')),
                            DataColumn(label: Text('班级')),
                            DataColumn(label: Text('总学分')),
                          ],
                          rows: _grades.map((grade) {
                            return DataRow(cells: [
                              DataCell(Text(grade['uid'].toString())),
                              DataCell(Text(grade['name'])),
                              DataCell(Text(grade['stuClass'])),
                              DataCell(Text(grade['totalCredits'].toString())),
                            ]);
                          }).toList(),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _exportData,
        child: Icon(Icons.download),
      ),
    );
  }

  void _searchStudent(String uid) {
    setState(() {
      _searchedStudent = _grades.firstWhere(
        (student) => student['uid'] == uid,
        orElse: () => <String, dynamic>{},
      );
      if (_searchedStudent!.isEmpty) {
        _searchedStudent = null;
      }
    });
  }

  void _exportData() async {
    // 请求权限
    var status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      // 权限被授予，执行导出逻辑
      try {
        var excel = Excel.createExcel();
        Sheet sheet = excel['成绩'];
        sheet.appendRow(['学号', '姓名', '班级', '总学分']);

        for (var grade in _grades) {
          sheet.appendRow([
            grade['uid'],
            grade['name'],
            grade['stuClass'],
            grade['totalCredits']
          ]);
        }

        final directory = await getApplicationDocumentsDirectory();

        // 获取当前时间
        String dateTime =
            DateTime.now().toString().replaceAll(':', '-').split('.')[0];
        final String filePath = '${directory.path}/学生成绩_$dateTime.xlsx';
        final File file = File(filePath);

        final excelBytes = await excel.save() ?? [];
        if (excelBytes.isEmpty) {
          throw Exception('Excel 文件未生成。');
        }

        await file.writeAsBytes(excelBytes);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('成绩已导出到: $filePath')),
        );

        _showViewFileDialog(filePath);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('导出失败: $e')),
        );
      }
    } else {
      // 权限被拒绝，提示用户
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('需要存储权限才能导出文件')),
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
                _openFile(filePath);
                Navigator.of(context).pop();
              },
              child: Text('查看'),
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

  void _openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('无法打开文件: ${result.message}')),
        );
        print('无法打开文件:${result.message}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('无法打开文件: $e')),
      );
    }
  }
}
