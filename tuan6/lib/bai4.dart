import 'package:flutter/material.dart';
import 'package:tuan6/login_page.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F0FA), // màu nền nhạt giống hình
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Phone with Flutter logo
            Container(
              width: 180,
              height: 360,
              decoration: BoxDecoration(
                color: Color(0xFF42A5F5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlutterLogo(size: 80),
                    SizedBox(height: 20),
                    Text(
                      'Flutter',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 30),
            // Column of buttons
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlatformButton(icon: Icons.apple, label: 'iOS'),
                SizedBox(height: 20),
                PlatformButton(
                  icon: Icons.android,
                  label: 'Android',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
                SizedBox(height: 20),
                PlatformButton(icon: Icons.language, label: 'Web'),
                SizedBox(height: 20),
                PlatformButton(icon: Icons.desktop_windows, label: 'Desktop'),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PlatformButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const PlatformButton({required this.icon, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24),
        SizedBox(width: 8),
        GestureDetector(
          onTap: onPressed,
          child: Text(
            label,
            style: TextStyle(fontSize: 18, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
