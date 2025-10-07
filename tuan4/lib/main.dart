import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('19_1050080202_Trần Thái Thiên'),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: RotatedBox(
                quarterTurns: 2, // Xoay 180 độ
                child: Container(
                  width: 50,
                  height: 300,
                  color: Colors.lightBlueAccent,
                ),
              ),
            ),
            SizedBox(height: 20), // Khoảng cách giữa các widget
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(color: Colors.green, width: 2),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: Icon(Icons.album, color: Colors.blue, size: 40),
                title: Text("19_1050080202_Trần Thái Thiên"),
                subtitle: Text("19_1050080202_Trần Thái Thiên"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}