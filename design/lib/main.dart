import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('19_1050080202_Tran Thai Thien'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Họ và tên , lớp',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  color: Colors.blue,
                ),
                Container(
                  width: 60,
                  height: 60,
                  color: Colors.green,
                ),
                Container(
                  width: 60,
                  height: 60,
                  color: Colors.orange,
                ),
              ],
            ),
            SizedBox(height: 40),
            Image.network(
              'https://vndigitech.com/wp-content/uploads/2022/05/flutter-logo-sharing.png',
              height: 100,
            ),
            SizedBox(height: 10),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {},
              child: Text('Bấm vào đây!'),
            ),
          ],
        ),
      ),
    );
  }
}