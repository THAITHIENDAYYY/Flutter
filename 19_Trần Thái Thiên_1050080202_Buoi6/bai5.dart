import 'package:flutter/material.dart';
import 'package:tuan6/login_page.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
  ));
}

class Bai2 extends StatelessWidget {
  final String fullname;
  final String classs;

  const Bai2({required this.fullname, required this.classs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('19_Trần Thái Thiên_1050080202'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Xin chào, $fullname!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '$classs!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 60, height: 60, color: Colors.blue),
                SizedBox(width: 10),
                Container(width: 60, height: 60, color: Colors.green),
                SizedBox(width: 10),
                Container(width: 60, height: 60, color: Colors.orange),
              ],
            ),
            SizedBox(height: 40),
            Image.network(
              'https://vndigitech.com/wp-content/uploads/2022/05/flutter-logo-sharing.png',
              height: 100,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // xử lý gì đó ở đây nếu muốn
              },
              child: Text('Bấm vào đây!'),
            ),
          ],
        ),
      ),
    );
  }
}
