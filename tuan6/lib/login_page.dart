import 'package:flutter/material.dart';
import 'package:tuan6/bai5.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
  ));
}

// ✅ Danh sách 10 tài khoản
List<Map<String, String>> users = [
  {'fullname':'Trương Hoài Phong','username': '1050080222', 'password': '123', 'classs':'CNPM3'},
  {'fullname':'Nguyễn Thanh Bình','username': '1050080333', 'password': '123','classs':'CNPM3'},
  {'fullname':'Dương Vĩnh Toàn','username': '105008111', 'password': '123','classs':'CNPM3'},
  {'fullname':'Trần Thái Thiên','username': '1050080202', 'password': '123','classs':'CNPM3'},
];

// ✅ Màn hình Đăng nhập
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _handleLogin(BuildContext context) {
    String username = usernameController.text.trim();
    String password = passwordController.text;

    // Tìm user khớp với username và password
    final matchedUser = users.firstWhere(
          (user) =>
      user['username'] == username && user['password'] == password,
      orElse: () => {},
    );

    // Nếu tìm thấy
    if (matchedUser.isNotEmpty) {
      String fullname = matchedUser['fullname']!;
      String classs = matchedUser['classs']!;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Bai2(fullname: fullname, classs: classs),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sai tên đăng nhập hoặc mật khẩu")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  )
                ],
              ),
              SizedBox(height: 40),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    image: DecorationImage(
                      image: NetworkImage('https://blog.pirago.vn/content/images/2023/08/1_5-aoK8IBmXve5whBQM90GA-1.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8), // hoặc 0 nếu muốn góc vuông
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: "Username or email address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: Icon(Icons.visibility),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _handleLogin(context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  "LOG IN",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}