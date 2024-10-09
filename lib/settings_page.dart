import 'package:flutter/material.dart';

import 'account_management.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('设置')),
      body: ListView(
        children: [
          ListTile(
            title: Text('账号管理'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AccountManagementPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
