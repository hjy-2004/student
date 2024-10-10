import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'grades_management_screen.dart';
import 'historical_events.dart';
import 'l10n/app_localizations.dart';
import 'main.dart';
import 'personal_center.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    GradesManagementScreen(),
    HistoricalEventsScreen(),
    PersonalCenterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        backgroundColor: Colors.amber,
        actions: [
          PopupMenuButton<Locale>(
            onSelected: (Locale locale) {
              Provider.of<LocaleNotifier>(context, listen: false)
                  .setLocale(locale);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<Locale>(
                    value: Locale('en', ''), child: Text('English')),
                PopupMenuItem<Locale>(
                    value: Locale('zh', ''), child: Text('中文')),
              ];
            },
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amber,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: AppLocalizations.of(context)!.home),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: AppLocalizations.of(context)!.gradesManagement),
          BottomNavigationBarItem(
              icon: Icon(Icons.history_edu_rounded),
              label: AppLocalizations.of(context)!.historicalEvents),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: AppLocalizations.of(context)!.personalCenter),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imageList = [
    'images/1.jpg',
    'images/2.jpg',
    'images/3.jpg',
    'images/4.jpg',
    'images/5.jpg',
    'images/6.jpg',
    'images/7.jpg',
    'images/8.jpg',
  ];

  PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  String _shenhuifu = '';
  String _mingrenmingyan = '';
  Uint8List _newsImage = Uint8List(0);

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    fetchShenhuifu();
    fetchMingrenmingyan();
    fetchNews();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (!_pageController.position.isScrollingNotifier.value) {
        if (_currentPage < imageList.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> fetchShenhuifu() async {
    setState(() {
      _shenhuifu = ''; // 清空当前内容
    });

    final response = await http.get(Uri.parse(
        'https://v.api.aa1.cn/api/api-wenan-shenhuifu/index.php?aa1=json'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _shenhuifu = jsonData[0]['shenhuifu'].replaceAll('<br>', '\n');
      });
    } else {
      throw Exception('Failed to load shenhuifu: ${response.statusCode}');
    }
  }

  Future<void> fetchMingrenmingyan() async {
    final response = await http.get(Uri.parse(
        'https://v.api.aa1.cn/api/api-wenan-mingrenmingyan/index.php?aa1=json'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _mingrenmingyan = jsonData[0]['mingrenmingyan'];
      });
    } else {
      throw Exception('Failed to load mingrenmingyan: ${response.statusCode}');
    }
  }

  Future<void> fetchNews() async {
    final response =
        await http.get(Uri.parse('https://v.api.aa1.cn/api/60s-v3/?cc=国内要闻'));

    if (response.statusCode == 200) {
      setState(() {
        _newsImage = response.bodyBytes; // 保存字节数据
      });
    } else {
      throw Exception('Failed to load news: ${response.statusCode}');
    }
  }

  void _refreshShenhuifu() {
    fetchShenhuifu();
  }

  void _refreshMingrenmingyan() {
    fetchMingrenmingyan();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 将轮播图移到最上面
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(16.0),
                ),
                margin: EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: imageList.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        imageList[index],
                        fit: BoxFit.cover,
                      );
                    },
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index; // 更新当前页索引
                      });
                    },
                  ),
                ),
              ),
              Container(
                height: 20,
                margin: EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(imageList.length, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      width: _currentPage == index ? 10.0 : 8.0,
                      height: _currentPage == index ? 10.0 : 8.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _currentPage == index ? Colors.amber : Colors.grey,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.shenhuifuTitle, // 使用本地化文本
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 8),
                  Text(_shenhuifu),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _refreshShenhuifu,
                      child: Text(
                          AppLocalizations.of(context)!.refresh), // 使用本地化文本
                    ),
                  ),
                ],
              ),
            ),
          ),
          QuoteCard(
            title: AppLocalizations.of(context)!.famousQuotesTitle, // 使用本地化文本
            content: _mingrenmingyan,
            onRefresh: _refreshMingrenmingyan,
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('60秒国内新闻',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 8),
                  _newsImage.isNotEmpty
                      ? Column(
                          children: [
                            Image.memory(_newsImage),
                            SizedBox(height: 8),
                          ],
                        )
                      : CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuoteCard extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onRefresh;

  const QuoteCard({
    Key? key,
    required this.title,
    required this.content,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 8),
            Text(content),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onRefresh,
                child: Text(AppLocalizations.of(context)!.refresh), // 使用本地化文本
              ),
            ),
          ],
        ),
      ),
    );
  }
}
