import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharedbill/providers/settingsState.dart';
import 'package:sharedbill/providers/tabsState.dart';
import 'package:sharedbill/screens/create.dart';
import 'package:sharedbill/screens/home.dart';
import 'package:sharedbill/screens/login.dart';
import 'package:sharedbill/screens/register.dart';
import 'package:sharedbill/screens/settings.dart';
import 'package:sharedbill/screens/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  final Color primaryColor = const Color(0xff03da9d);
  final Color accentColor = const Color(0xff333333);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsState>(create: (_) => SettingsState()),
        ChangeNotifierProvider<TabsState>(create: (_) => TabsState()),
      ],
      child: MaterialApp(
        title: 'Tabs',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            secondary: Colors.orange,
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            displayMedium: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            displaySmall: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            labelLarge: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          primaryColor: primaryColor,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(color: Colors.white),
          fontFamily: 'Rubik',
          buttonTheme: ButtonThemeData(
            buttonColor: primaryColor,
            textTheme: ButtonTextTheme.normal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.all(8),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(style: BorderStyle.none),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        routes: {
          Welcome.id: (context) => Welcome(),
          Register.id: (context) => Register(),
          Login.id: (context) => Login(),
          NewTab.id: (context) => NewTab(),
          Settings.id: (context) => Settings()
        },
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ); // Show a loading indicator while checking auth state
            }
            if (snapshot.hasData) {
              return Home(snapshot.data!); // User is signed in
            } else {
              return Welcome(); // User is not signed in
            }
          },
        ),
      ),
    );
  }
}
