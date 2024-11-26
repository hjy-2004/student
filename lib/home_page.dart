// home_page.dart
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/homeImages/group_15.png',
              height: 50,
            ),
            Row(
              children: [
                Image.asset(
                  'assets/homeImages/sweep_it.png',
                  height: 30,
                ),
                SizedBox(width: 15),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.asset(
                      'assets/homeImages/print_1.png',
                      height: 30,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Image.asset(
                        'assets/homeImages/warn.png',
                        height: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 5),
                Text(
                  '未连接',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Banner Image
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Image.asset('assets/homeImages/mask_group.png'),
          ),

          // PageView with Grid
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16), // 添加左右边距
              child: Stack(
                children: [
                  Positioned.fill(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (int index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      children: [
                        _buildGridPage(),
                        _buildGridPage(),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10, // 调整指示器的垂直位置
                    left: 0,
                    right: 0,
                    child: _buildIndicator(), // 椭圆长条指示器
                  ),
                ],
              ),
            ),
          ),

          // 使用记录部分
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '使用记录',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Container(
            child: Column(
              children: [
                _buildUsageRecord(
                  'assets/homeImages/print_lele.png',
                  '姓名贴-乐乐',
                  '30×40mm(W×H)',
                  '2023.08.15 10:00',
                ),
                _buildUsageRecord(
                  'assets/homeImages/print_1_1_1.png',
                  '提示用语-有电提醒',
                  '40×40mm(W×H)',
                  '2023.08.10 16:00',
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // 设置背景颜色为白色
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true, // 始终显示未选中的标签
        type: BottomNavigationBarType.fixed, // 确保每个图标的间距一致
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/homeImages/home.png',
              width: 45, // 调整图标大小
              height: 45,
            ),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/homeImages/document_gray.png',
              width: 45, // 调整图标大小
              height: 45,
            ),
            label: '文档',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/homeImages/square_Ash.png',
              width: 45, // 调整图标大小
              height: 45,
            ),
            label: '场景',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/homeImages/my_Ash.png',
              width: 45, // 调整图标大小
              height: 45,
            ),
            label: '我的',
          ),
        ],
      ),
    );
  }

  Widget _buildGridPage() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), // 圆角
        color: Colors.white,
      ),
      child: GridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: [
          _buildGridButton('assets/homeImages/create_a_new_label.png', '新建标签'),
          _buildGridButton('assets/homeImages/photo_printing.png', '照片打印'),
          _buildGridButton('assets/homeImages/library.png', '素材库'),
          _buildGridButton('assets/homeImages/toolbox.png', '工具箱'),
          _buildGridButton('assets/homeImages/pdf_print.png', '文档打印'),
          _buildGridButton('assets/homeImages/photo_printing_1.png', '快速打印'),
          _buildGridButton('assets/homeImages/pdf_printing.png', '文本编辑'),
          _buildGridButton('assets/homeImages/web_printing.png', '网页打印'),
        ],
      ),
    );
  }

  Widget _buildGridButton(String assetPath, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(assetPath, width: 40, height: 40),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildUsageRecord(
      String imagePath, String title, String size, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Stack(
          children: [
            Row(
              children: [
                Image.asset(imagePath, width: 100, height: 100),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      Text(size,
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      SizedBox(height: 15), // 添加间距，调整打印时间位置
                      Text('打印时间：$time',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 4, // 调整垂直位置
              right: 4, // 调整水平位置
              child: Row(
                children: [
                  _buildIconButton('assets/homeImages/print_yellow.png'),
                  SizedBox(width: 2), // 调整按钮间距
                  _buildIconButton('assets/homeImages/more_yellow.png'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(String imagePath) {
    return Material(
      color: Colors.transparent, // 使背景透明
      child: InkWell(
        borderRadius: BorderRadius.circular(20), // 自定义圆角
        onTap: () {}, // 点击事件
        child: Padding(
          padding: const EdgeInsets.all(5.0), // 点击区域的大小
          child: Image.asset(
            imagePath,
            width: 30,
            height: 30,
          ),
        ),
      ),
    );
  }

  // 椭圆长条指示器
  Widget _buildIndicator() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(2, (index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 30 : 30, // 调整宽度以改变长度
            height: 8,
            decoration: BoxDecoration(
              color: _currentPage == index ? Colors.orange : Colors.white,
              borderRadius: BorderRadius.circular(4), // 圆角
              border: Border.all(
                color: _currentPage == index
                    ? Colors.orange
                    : Colors.yellow, // 边框颜色
                width: 2, // 边框粗细
              ),
            ),
          );
        }),
      ),
    );
  }
}
