import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/intl/app_localizations.dart';
import 'main.dart';

class HistoricalEventsScreen extends StatefulWidget {
  @override
  _HistoricalEventsScreenState createState() => _HistoricalEventsScreenState();
}

class _HistoricalEventsScreenState extends State<HistoricalEventsScreen> {
  String currentDate = '';
  List<String> historicalEvents = [];

  @override
  void initState() {
    super.initState();
    _getCurrentDate();
    _loadHistoricalEvents();
    // _fetchHistoricalEvents();
  }

  void _getCurrentDate() {
    setState(() {
      currentDate = DateFormat('yyyy年M月d日').format(DateTime.now());
    });
  }

  Future<void> _loadHistoricalEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      historicalEvents = prefs.getStringList('historicalEvents') ?? [];
    });
  }

  Future<void> _fetchHistoricalEvents() async {
    try {
      String today = DateFormat('M/d').format(DateTime.now());
      String url =
          'http://v.juhe.cn/todayOnhistory/queryEvent.php?key=5f96c7c89f89ac86a2755f70ee8ea281&date=$today';

      var response = await Dio().get(url);
      if (response.statusCode == 200) {
        var data = response.data;
        if (data['error_code'] == 0) {
          var events = data['result'];
          setState(() {
            historicalEvents = events
                .map<String>((event) => event['title'] as String)
                .toList();
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList('historicalEvents', historicalEvents);
        } else {
          setState(() {
            historicalEvents = ['错误: ${data['reason']}'];
          });
        }
      }
    } catch (e) {
      setState(() {
        historicalEvents = ['请求失败: $e'];
      });
    }
  }

  Future<void> _refreshData() async {
    await _fetchHistoricalEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleNotifier>(
      builder: (context, localeNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.historicalToday),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.todayIs}: $currentDate',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.historicalEventsOccurred,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 10),
                historicalEvents.isNotEmpty
                    ? Expanded(
                        child: RefreshIndicator(
                          onRefresh: _refreshData,
                          child: ListView.builder(
                            itemCount: historicalEvents.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    historicalEvents[index],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        );
      },
    );
  }
}
