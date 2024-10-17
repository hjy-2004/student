import 'dart:convert'; // 导入用于处理JSON
import 'dart:io';

import 'package:dio/dio.dart'; // 用于上传文件
import 'package:file_picker/file_picker.dart'; // 用于选择任意文件
import 'package:flutter/material.dart';
import 'package:flutter_2024_09_22/api_constants.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileManagementPage extends StatefulWidget {
  @override
  _FileManagementPageState createState() => _FileManagementPageState();
}

class _FileManagementPageState extends State<FileManagementPage> {
  List<File> uploadedFiles = []; // 已上传文件列表
  Dio dio = Dio();
  bool isLoading = false; // 用于控制加载状态

  // 获取已上传文件列表
  Future<void> _fetchUploadedFiles() async {
    setState(() {
      isLoading = true; // 开始加载
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? studentId = prefs.getString('username'); // 获取学号

      if (studentId == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('未找到登录信息')));
        return;
      }

      // 尝试从本地加载数据
      String? localData = prefs.getString('uploadedFiles');
      if (localData != null) {
        List<dynamic> filesData = jsonDecode(localData);
        String? storedUserId = filesData.isNotEmpty
            ? filesData[0]['username'] // 假设第一个文件的信息包含用户名
            : null;

        // 检查当前用户ID与存储的用户ID是否一致
        if (storedUserId != studentId) {
          // 清除不一致的本地文件列表
          await prefs.remove('uploadedFiles');
        } else {
          setState(() {
            uploadedFiles = filesData.map((fileData) {
              String filePath = fileData['filePath'];
              return File(filePath); // 根据文件路径创建文件对象
            }).toList();
          });
        }
      }

      // 如果没有本地文件，才请求服务器
      if (uploadedFiles.isEmpty) {
        Response response =
            await dio.get('$baseUrl/api/files/list/$studentId'); // 使用正确的 API 地址

        if (response.statusCode == 200) {
          List<dynamic> filesData = response.data;
          setState(() {
            uploadedFiles = filesData.map((fileData) {
              String serverFilePath = fileData['filePath']; // 从后端获取文件路径
              return File(serverFilePath); // 根据文件路径创建文件对象
            }).toList();
          });

          // 保存到本地
          await prefs.setString('uploadedFiles', jsonEncode(filesData));
        } else if (response.statusCode == 204) {
          // 如果返回204状态，说明没有文件，可以在这里显示空信息
          setState(() {
            uploadedFiles = []; // 确保列表为空
          });
        } else {
          // 只在有文件的情况下显示提示
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('获取文件列表失败')));
        }
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('获取文件列表出错')));
    } finally {
      setState(() {
        isLoading = false; // 结束加载
      });
    }
  }

  // 选择文件并上传
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      String? filePath = result.files.first.path;
      if (filePath != null) {
        File file = File(filePath);
        await _uploadFile(file);
      }
    }
  }

  Future<void> _uploadFile(File file) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? studentId = prefs.getString('username'); // 获取学号

      if (studentId == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('未找到登录信息')));
        return;
      }

      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
        "username": studentId, // 添加学号信息
      });

      Response response = await dio.post('$baseUrl/api/files/upload',
          data: formData); // 使用正确的 API 地址

      // 检查服务器返回的响应
      print("Response data: ${response.data}");

      if (response.statusCode == 200) {
        // 假设后端返回的 JSON 包含文件名和路径
        String serverFilePath = response.data['filePath']; // 获取文件路径

        setState(() {
          uploadedFiles.add(File(serverFilePath)); // 使用后端返回的文件路径
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('文件上传成功')));

        // 保存更新后的文件列表
        await prefs.setString(
            'uploadedFiles',
            jsonEncode(uploadedFiles.map((file) {
              return {"filePath": file.path};
            }).toList()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('文件上传失败')));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('上传出错')));
    }
  }

  // 下载文件
  void _downloadFile(File file) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? studentId = prefs.getString('username'); // 获取学号

      if (studentId == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('未找到登录信息')));
        return;
      }

      String fileName = file.path.split('/').last;
      final directory = await getApplicationDocumentsDirectory();
      final localFilePath = '${directory.path}/$fileName';

      // 检查本地文件是否存在
      if (await File(localFilePath).exists()) {
        // 文件已存在，直接打开
        _viewDownloadedFile(File(localFilePath));
        return;
      }

      // 文件不存在，执行下载
      Response response = await dio.get(
        '$baseUrl/api/files/download/$fileName',
        queryParameters: {"username": studentId}, // 根据学号获取文件
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        // 保存文件到本地
        File downloadedFile = File(localFilePath);
        await downloadedFile.writeAsBytes(response.data);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('文件下载成功，保存在: $localFilePath')));

        // 直接查看已下载文件
        _viewDownloadedFile(downloadedFile);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('文件下载失败')));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('文件下载出错')));
    }
  }

  // 查看已下载文件（可以直接打开）
  void _viewDownloadedFile(File file) {
    OpenFile.open(file.path);
  }

  // 删除文件
  Future<void> _deleteFile(File file) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? studentId = prefs.getString('username'); // 获取学号

      if (studentId == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('未找到登录信息')));
        return;
      }

      // 使用文件的后端返回的文件名进行删除
      String fileName = file.path.split('/').last;
      Response response = await dio.delete(
        '$baseUrl/api/files/delete/$fileName',
        queryParameters: {"username": studentId}, // 根据学号获取文件
      );

      if (response.statusCode == 200) {
        setState(() {
          uploadedFiles.remove(file); // 从列表中移除文件
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('文件删除成功')));

        // 更新本地保存的数据
        await prefs.setString(
            'uploadedFiles',
            jsonEncode(uploadedFiles.map((file) {
              return {"filePath": file.path};
            }).toList()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('文件删除失败')));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('删除文件出错')));
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUploadedFiles(); // 初始化时加载文件
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('文件管理'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // 显示加载指示器
          : uploadedFiles.isEmpty
              ? Center(child: Text('空空如也，尚未上传任何文件。')) // 显示空数据提示
              : ListView.builder(
                  itemCount: uploadedFiles.length,
                  itemBuilder: (context, index) {
                    File file = uploadedFiles[index];
                    return ListTile(
                      title: Text(file.path.split('/').last),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.download),
                            onPressed: () => _downloadFile(file),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteFile(file),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickFile,
        child: Icon(Icons.upload_file),
      ),
    );
  }
}
