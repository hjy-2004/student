// import 'package:flutter/material.dart';

// import 'notebook_page.dart';
// import 'profile_page.dart';
// import 'settings_page.dart';

// class PersonalCenterScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 用户头像和姓名
//             GestureDetector(
//               onTap: () {
//                 _showProfilePage(context);
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 30,
//                         backgroundImage: AssetImage('images/2.jpg'),
//                       ),
//                       SizedBox(width: 10),
//                       Text(
//                         '张三',
//                         style: TextStyle(
//                             fontSize: 15, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   Icon(
//                     Icons.chevron_right,
//                     color: Colors.grey[300],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 50),
//             // 设置选项
//             GestureDetector(
//               onTap: () {
//                 _showSettingsPage(context);
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.settings,
//                         color: Colors.grey,
//                       ),
//                       SizedBox(width: 10),
//                       Text('设置', style: TextStyle(fontSize: 15)),
//                     ],
//                   ),
//                   Icon(
//                     Icons.chevron_right,
//                     color: Colors.grey[300],
//                   ),
//                 ],
//               ),
//             ),
//             Divider(),
//             SizedBox(height: 30),
//             // 笔记本选项
//             GestureDetector(
//               onTap: () {
//                 _showNotebookPage(context);
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.note,
//                         color: Colors.green[400],
//                       ),
//                       SizedBox(width: 10),
//                       Text('笔记本', style: TextStyle(fontSize: 15)),
//                     ],
//                   ),
//                   Icon(
//                     Icons.chevron_right,
//                     color: Colors.grey[300],
//                   ),
//                 ],
//               ),
//             ),
//             Divider(),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showProfilePage(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => ProfilePage()),
//     );
//   }

//   void _showSettingsPage(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => SettingsPage()),
//     );
//   }

//   void _showNotebookPage(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => NotebookPage()),
//     );
//   }
// }
