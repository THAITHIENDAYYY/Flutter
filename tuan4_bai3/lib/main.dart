import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MenuScreen(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('19_1050080202_Trần Thái Thiên'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildMenuButton(context, "Bài tập 1: 19_1050080202_Trần Thái Thiên _RotatedBox 90 độ", const FirstExercise()),
            buildMenuButton(context, "Bài tập 2: 19_1050080202_Trần Thái Thiên _Card Example", const CardExercise()),
            buildMenuButton(context, "Bài tập 3: 19_1050080202_Trần Thái Thiên _Circle TVH", const CircleTVHExercise()),
            buildMenuButton(context, "Bài Tập 4: 19_1050080202_Trần Thái Thiên_Icon Xe Buýt", const BusIconExercise()),
          ],
        ),
      ),
    );
  }

  Widget buildMenuButton(BuildContext context, String title, Widget screen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Text(title),
      ),
    );
  }
}

// Bài tập 1: Xoay 90 độ
class FirstExercise extends StatelessWidget {
  const FirstExercise({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bài tập 1: RotatedBox 90 độ")),
      body: Center(
        child: RotatedBox(
          quarterTurns: 1,
          child: Container(
            width: 50,
            height: 300,
            color: Colors.lightBlueAccent,
          ),
        ),
      ),
    );
  }
}


// Bài tập 2: Card Example
class CardExercise extends StatelessWidget {
  const CardExercise({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bài tập 2: Card Example")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: const BorderSide(color: Colors.green, width: 2),
            ),
            elevation: 5,
            margin: const EdgeInsets.all(10),
            child: const ListTile(
              leading: Icon(Icons.album, color: Colors.blue, size: 40),
              title: Text("Let's Talk About Love"),
              subtitle: Text("Modern Talking Album"),
            ),
          ),
        ],
      ),
    );
  }
}
// Bài tập 3: Circle TVH
class CircleTVHExercise extends StatelessWidget {
  const CircleTVHExercise({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bài tập 3: Circle TVH")),
      body: Center(
        child: Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            color: Colors.lightBlueAccent,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              'TTT',
              style: TextStyle(
                color: Colors.red,
                fontSize: 70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// Bài tập 5: Icon Xe Buýt
class BusIconExercise extends StatelessWidget {
  const BusIconExercise({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("19_1050080202_Trần Thái Thiên _Icon Xe Buýt")),
      body: const Center(
        child: Icon(
          Icons.directions_bus,
          size: 50,
          color: Colors.black,
        ),
      ),
    );
  }
}