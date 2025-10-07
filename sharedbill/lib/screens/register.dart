import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sharedbill/screens/home.dart';
import 'package:sharedbill/services/auth.dart';
import 'package:sharedbill/screens/login.dart';

class Register extends StatefulWidget {
  static const String id = "register";
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
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
          final userCredential = await Auth.register(email!, password!);
          if (userCredential != null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home(FirebaseAuth.instance.currentUser!)),
              (route) => false,
            );
          } else {
            setState(() {
              errorMessage = 'Registration failed. Please try again.';
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
        title: const Text('Register'),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
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
                      'Create an Account',
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
                      child: const Text('Register'),
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
                        Navigator.pushNamed(context, Login.id);
                      },
                      child: const Text('Already have an account? Sign In'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
