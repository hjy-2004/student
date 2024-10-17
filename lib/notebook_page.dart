import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/intl/app_localizations.dart'; // 更新为你的路径

class NotebookPage extends StatefulWidget {
  @override
  _NotebookPageState createState() => _NotebookPageState();
}

class _NotebookPageState extends State<NotebookPage> {
  List<Map<String, String>> notes = []; // 存储笔记的列表
  String? currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
      });
      _loadNotes(); // 加载现有笔记
    });
  }

  Future<String?> _getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentUser');
  }

  Future<String> _getUserLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    if (currentUser == null) {
      throw Exception("当前用户未登录");
    }
    String userPath = '${directory.path}/$currentUser';
    Directory userDirectory = Directory(userPath);
    if (!(await userDirectory.exists())) {
      await userDirectory.create(recursive: true);
    }
    return userPath;
  }

  Future<void> _loadNotes() async {
    if (currentUser == null) return; // 如果未获取到用户信息，直接返回
    String path = await _getUserLocalPath();
    Directory directory = Directory(path);
    if (await directory.exists()) {
      List<FileSystemEntity> files = directory.listSync();
      notes.clear(); // 清空列表
      for (var file in files) {
        if (file is File &&
            file.path.endsWith('.txt') &&
            !file.path.contains('notes_order')) {
          String content = await file.readAsString();
          String title = file.uri.pathSegments.last.replaceAll('.txt', '');
          notes.add({'title': title, 'content': content});
        }
      }
    }
    await _loadNotesOrder(); // 读取笔记顺序
    setState(() {}); // 更新 UI
  }

  Future<void> _saveNote(String title, String content, {int? index}) async {
    if (currentUser == null) return; // 如果未获取到用户信息，直接返回
    String path = await _getUserLocalPath();
    File noteFile = File('$path/$title.txt');
    await noteFile.writeAsString(content);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.noteSaved)),
    );

    setState(() {
      if (index != null) {
        notes[index] = {'title': title, 'content': content}; // 更新已有笔记
      } else {
        notes.add({'title': title, 'content': content}); // 新增笔记
      }
    });
    _persistNotes(); // 更新笔记顺序
  }

  Future<void> _deleteNote(int index) async {
    if (currentUser == null) return; // 如果未获取到用户信息，直接返回
    String path = await _getUserLocalPath();
    File noteFile = File('$path/${notes[index]['title']}.txt');
    if (await noteFile.exists()) {
      await noteFile.delete();
    }
    setState(() {
      notes.removeAt(index); // 从列表中删除笔记
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.noteDeleted)),
    );
    _persistNotes(); // 更新笔记顺序
  }

  Future<void> _persistNotes() async {
    if (currentUser == null) return; // 如果未获取到用户信息，直接返回
    String path = await _getUserLocalPath();
    final file = File('$path/notes_order.txt');
    await file.writeAsString(notes.map((note) => note['title']!).join('\n'));
  }

  Future<void> _loadNotesOrder() async {
    if (currentUser == null) return; // 如果未获取到用户信息，直接返回
    String path = await _getUserLocalPath();
    final file = File('$path/notes_order.txt');
    if (await file.exists()) {
      List<String> titles = await file.readAsLines();
      notes.sort((a, b) =>
          titles.indexOf(a['title']!).compareTo(titles.indexOf(b['title']!)));
    }
  }

  void _showEditNoteDialog(int index) {
    TextEditingController titleController =
        TextEditingController(text: notes[index]['title']);
    TextEditingController contentController =
        TextEditingController(text: notes[index]['content']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.editNote),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.inputNoteTitle),
              ),
              SizedBox(height: 10),
              TextField(
                controller: contentController,
                maxLines: 5,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.inputNoteContent),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String title = titleController.text;
                String content = contentController.text;
                if (title.isNotEmpty && content.isNotEmpty) {
                  _saveNote(title, content, index: index); // 更新笔记
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            AppLocalizations.of(context)!.titleContentEmpty)),
                  );
                }
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        );
      },
    );
  }

  void _togglePinNote(int index) {
    final note = notes.removeAt(index);
    notes.insert(0, note); // 简单的置顶逻辑
    setState(() {});

    // 持久化顺序到本地
    _persistNotes();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.notePinned)),
    );
  }

  void _showNoteActions(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context)!.editNote),
              onTap: () {
                Navigator.of(context).pop();
                _showEditNoteDialog(index);
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.delete),
              onTap: () {
                Navigator.of(context).pop();
                _deleteNote(index);
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.pin),
              onTap: () {
                Navigator.of(context).pop();
                _togglePinNote(index);
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddNoteDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.addNote),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.inputNoteTitle),
              ),
              SizedBox(height: 10),
              TextField(
                controller: contentController,
                maxLines: 5,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.inputNoteContent),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String title = titleController.text;
                String content = contentController.text;
                if (title.isNotEmpty && content.isNotEmpty) {
                  _saveNote(title, content);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            AppLocalizations.of(context)!.titleContentEmpty)),
                  );
                }
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.notebook)),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index]['title']!),
            subtitle: Text(notes[index]['content']!),
            onLongPress: () => _showNoteActions(index), // 长按显示操作菜单
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
