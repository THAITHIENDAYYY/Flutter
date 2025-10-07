import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sharedbill/screens/home.dart';
import 'package:sharedbill/screens/register.dart';
import 'package:sharedbill/services/auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import './forgot_pass.dart';

class Login extends StatefulWidget {
  static const String id = "login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String errorMessage = '';
  bool loading = false;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email.';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email.';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password.';
    }
    return null;
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        loading = true;
        errorMessage = '';
      });
      try {
        if (email != null && password != null) {
          final userCredential = await Auth.signIn(email!, password!);
          if (userCredential != null) {
             Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home(FirebaseAuth.instance.currentUser!)),
              (route) => false,
            );
          } else {
             setState(() {
               errorMessage = 'Sign in failed. Please check your credentials.';
               loading = false;
             });
          }
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message ?? 'An unknown error occurred.';
          loading = false;
        });
      } catch (e) {
        setState(() {
          errorMessage = 'An unknown error occurred.';
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: loading
          ? Center(
              child: SpinKitDoubleBounce(
                color: Theme.of(context).primaryColor,
                size: 50.0,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Log In',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 48.0),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: validateEmail,
                      onSaved: (value) => email = value,
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: validatePassword,
                      onSaved: (value) => password = value,
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Log In'),
                    ),
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 8.0),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Register.id);
                      },
                      child: const Text('Don\'t have an account? Sign Up'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, ForgotPass.id);
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
