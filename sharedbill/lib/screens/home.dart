import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharedbill/controllers/tabsController.dart';
import 'package:sharedbill/providers/settingsState.dart';
import 'package:sharedbill/providers/tabsState.dart';
import 'package:sharedbill/screens/create.dart';
import 'package:sharedbill/widgets/closedTabs.dart';
import 'package:sharedbill/widgets/openTabs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sharedbill/screens/settings.dart' as AppSettings;
import 'package:flutter/cupertino.dart';
import 'package:sharedbill/services/auth.dart';
import 'dart:io' show Platform;

class Home extends StatelessWidget {
  final User user;

  const Home(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabsState = Provider.of<TabsState>(context);
    final settingsState = Provider.of<SettingsState>(context);

    return Scaffold(
      appBar: AppBar(
        title: tabsState.filterEnabled
            ? Text(
                "${tabsState.name}'s Tabs",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : const Text('Tabs'),
        actions: <Widget>[
          TextButton(
            onPressed: () => tabsState.clearFilter(),
            child: Text(
              'Clear Filter',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, AppSettings.Settings.id);
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          OpenTabs(tabsState.openTabs),
          ClosedTabs(tabs: tabsState.closedTabs),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, NewTab.id);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

void _showEmailConfirmDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        return CupertinoAlertDialog(
          title: const Text("Sorry, you need to verify your email first"),
          content: const Text("Please check your email"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text("Resend Email"),
              onPressed: () {
                Auth.sendEmailVerification();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      } else {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text("Sorry, you need to verify your email first"),
          content: const Text("Please check your email"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Resend Email"),
              onPressed: () {
                Auth.sendEmailVerification();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    },
  );
}
