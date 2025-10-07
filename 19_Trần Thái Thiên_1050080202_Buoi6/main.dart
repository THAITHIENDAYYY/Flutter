
import 'package:flutter/material.dart';
import 'package:tuan6/bai1.dart'; // Import bài 1
import 'package:tuan6/bai2.dart'; // Import bài 1
import 'package:tuan6/bai3.dart'; // Import bài 1
import 'package:tuan6/bai4.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scaffold',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '19_Trần Thái Thiên_1050080202'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(
        child: Text(
          'Bài tập tuần 6\n19_Trần Thái Thiên_1050080202',
          style: TextStyle(fontSize: 20),
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Danh sách bài tập\n19_Trần Thái Thiên_1050080202\nCNPM3',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            _buildDrawerItem(context, "Bài 1", Bai1()),
            _buildDrawerItem(context, "Bài 2", Bai2()),
            _buildDrawerItem(context, "Bài 3", Bai3()),
            _buildDrawerItem(context, "Bài 4", HomeScreen()),
          ],
        ),
      ),
    );
  }

  /// Hàm tạo một `ListTile` có chức năng chuyển trang
  Widget _buildDrawerItem(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios), // Thêm icon để dễ nhìn
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page), // Chuyển sang trang mới
        );
      },
    );
  }
}
