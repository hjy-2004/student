import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StickerSelectionPage extends StatefulWidget {
  @override
  _StickerSelectionPageState createState() => _StickerSelectionPageState();
}

class _StickerSelectionPageState extends State<StickerSelectionPage> {
  List<String> stickers = []; // 存储从后台获取的贴纸URL
  int _selectedIndex = 0; // 当前选择的标签索引
  final List<String> _tabs = ['表情', '动画', '卡通', '气泡', '人物']; // 标签名称

  @override
  void initState() {
    super.initState();
    _fetchStickers(); // 初始化时获取贴纸
  }

  Future<void> _fetchStickers() async {
    final response =
        await http.get(Uri.parse('http://192.168.8.104:8080/stickers/list'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        stickers = jsonData.map((stickerPath) {
          // 确保每个 URL 都是完整的
          return 'http://192.168.8.104:8080$stickerPath';
        }).toList();
      });
    } else {
      throw Exception('Failed to load stickers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(16.0)), // 设置顶部圆角
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white60,
              elevation: 0.0, // 去掉底部的阴影线
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16.0), // 页面顶部圆角
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center, // 修改为居中对齐
                children: [
                  Container(
                    width: 60.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: Colors.yellow, // 黄色下划线
                      borderRadius: BorderRadius.circular(2.0), // 圆角
                    ),
                  ),
                ],
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(40.0),
                child: Container(
                  color: Colors.white60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _tabs.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String label = entry.value;
                      return InkWell(
                        // 使用 InkWell 提供点击效果
                        onTap: () {
                          setState(() {
                            _selectedIndex = idx;
                          });
                        },
                        child: Text(
                          label,
                          style: TextStyle(
                            color: _selectedIndex == idx
                                ? Colors.black
                                : Colors.grey,
                            fontWeight: _selectedIndex == idx
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          body: stickers.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Container(
                  color: Colors.white60, // 设置背景颜色
                  child: PageView.builder(
                    itemCount: _tabs.length,
                    controller: PageController(initialPage: _selectedIndex),
                    onPageChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return GridView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0), // 设置水平和垂直间距
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0, // 网格间隔
                          mainAxisSpacing: 8.0, // 行间隔
                          childAspectRatio: 1.0,
                        ),
                        itemCount: stickers.length,
                        itemBuilder: (context, stickerIndex) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context, stickers[stickerIndex]);
                            },
                            child: Container(
                              margin: EdgeInsets.all(4.0), // 贴纸之间的外间距
                              color: Colors.white,
                              padding: EdgeInsets.all(20.0),
                              child: Image.network(
                                stickers[stickerIndex],
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ));
  }
}
