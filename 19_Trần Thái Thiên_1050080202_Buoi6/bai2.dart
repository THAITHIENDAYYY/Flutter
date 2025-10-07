import 'package:flutter/material.dart';

void main() {
  runApp(Bai2());
}

class Bai2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Page1(),
    );
  }
}
class Page1 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("19_Trần Thái Thiên_1050080202"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Go!'),
          onPressed: () {
            Navigator.of(context).push(_createRoute());
          },
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (BuildContext context, Animation<double> animation,//
        Animation<double> secondaryAnimation) {
      return Page2();
    },
    transitionsBuilder: (BuildContext context, Animation<double> animation, //
        Animation<double> secondaryAnimation, Widget child) {
      return child;
    },
  );
}
class Page2 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title of Page 2"),
      ),
      body: Center(
        child: Text('Page 2'),
      ),
      backgroundColor: Colors.lightGreen[100],
    );
  }
}
