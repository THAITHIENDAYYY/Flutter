import 'package:flutter/material.dart';

main() {
  runApp(Bai3());
}

class Bai3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/home',
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => Home(),
        '/details': (BuildContext context) => Details(),
        '/about': (BuildContext context) => About(),
      },
    );
  }
}

class Home extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("19_Trần Thái Thiên_1050080202"),
      ),
      body: Center(


          child: Row (
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                child: Text('Go to Details Page'),
                onPressed: () {
                  Navigator.of(context).pushNamed('/details');
                },
              ),
              ElevatedButton(
                child: Text('Go to About Page'),
                onPressed: () {
                  Navigator.of(context).pushNamed('/about');
                },
              ),
            ],
          )
      ),
    );
  }
}

class Details extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title of Details Page"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Close'),
          onPressed: () {
            // Close page and pass a value back to previous page
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.lightGreen[100],
    );
  }
}

class About extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title of About Page"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Close'),
          onPressed: () {
            // Close page
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.cyan[100],
    );
  }
}
