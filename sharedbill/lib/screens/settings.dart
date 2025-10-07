import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharedbill/providers/settingsState.dart';
import 'package:sharedbill/widgets/confirmDialog.dart';
import 'package:sharedbill/services/auth.dart';
import 'package:sharedbill/screens/welcome.dart';

class Settings extends StatefulWidget {
  static const String id = "/settings";

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final settingsState = Provider.of<SettingsState>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text(
              'Account',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            ListTile(
              title: const Text('Email'),
              subtitle: Text(user?.email ?? 'Not signed in'),
            ),
            ListTile(
              title: const Text('Email Verified'),
              subtitle: Text(user?.emailVerified == true ? 'Yes' : 'No'),
              trailing: user?.emailVerified == false
                  ? TextButton(
                      onPressed: () async {
                        await Auth.sendEmailVerification();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Verification email sent')),
                        );
                      },
                      child: const Text('Send Verification Email'),
                    )
                  : null,
            ),
            ListTile(
              title: const Text('Change Password'),
              onTap: () {
                 Auth.resetPassword(user?.email ?? ''); // Pass email to reset password
                 ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password reset link sent to your email')),
                      );
              },
            ),
            const Divider(),
            Text(
              'General',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            ListTile(
              title: const Text('Currency'),
              trailing: DropdownButton<String>(
                value: settingsState.selectedCurrency,
                items: <String>['\$', '€', '£', '¥'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    settingsState.selectCurrency(newValue);
                  }
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () async {
                await Auth.signOut();
              },
            ),
            ListTile(
              title: const Text('Delete Account'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmDialog(
                    title: 'Delete Account',
                    content: 'Are you sure you want to delete your account? This action is irreversible.',
                    onConfirmed: () async {
                       // TODO: Implement account deletion logic
                       Navigator.pop(context); // Close dialog
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
