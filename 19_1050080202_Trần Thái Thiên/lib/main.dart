import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title of Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("19_1050080202_Tran Thai Thien"),
          automaticallyImplyLeading: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.file_upload),
              onPressed: () {
                print("Click on upload button");
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                print("Click on settings button");
              },
            ),
            PopupMenuButton(
              icon: Icon(Icons.share),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text("Facebook"),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text("Instagram"),
                ),
              ],
            ),
          ],
          backgroundColor: Colors.blue,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.car_crash, color: Colors.white)),
              Tab(icon: Icon(Icons.bike_scooter, color: Colors.white)),
              Tab(icon: Icon(Icons.train, color: Colors.white)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text("Car\n19_10ĐH_CNPM3")),
            Center(child: Text("Bike\n19_10ĐH_CNPM3")),
            Center(child: Text("Train\n19_10ĐH_CNPM3")),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
                child: Text(
                  'My Drawer\n19_10ĐH_CNPM3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: Text('Gallery'),
              ),
              ListTile(
                title: Text('Slideshow'),
              ),
              ListTile(
                title: Text('Trần Thái Thiên'),
              ),
              ListTile(
                title: Text('19_10ĐH_CNPM3'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 4.0,
          icon: const Icon(Icons.add),
          label: const Text('Add a task'),
          onPressed: () {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(icon: Icon(Icons.home), onPressed: () {}),
              PopupMenuButton(
                icon: Icon(Icons.share),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text("Facebook"),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text("Instagram"),
                  ),
                ],
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.email)),
            ],
          ),
        ),
      ),
    );
  }
}