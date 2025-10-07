import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sharedbill/widgets/closedTabs.dart';
import 'package:sharedbill/widgets/openTabs.dart';
import 'package:sharedbill/providers/tabsState.dart';
import 'package:sharedbill/controllers/tabsController.dart';
import 'package:sharedbill/widgets/confirmDialog.dart';
import 'package:sharedbill/models/tab.dart';

class ClosedTabs extends StatelessWidget {
  final List<TabModel> tabs;

  const ClosedTabs({Key? key, required this.tabs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tabs.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Closed Tabs',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ...tabs.map((tab) => ListTile(
              title: Text(tab.name ?? ''),
              subtitle: Text(
                  '${tab.description ?? '-'} - Amount: ${tab.amount}'),
              trailing: TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ConfirmDialog(
                      title: 'Delete Tab',
                      content:
                          'Are you sure you want to delete this tab? This action is irreversible.',
                      onConfirmed: () async {
                        await TabsController.deleteTab(tab.id);
                        Navigator.pop(context); // Close dialog
                      },
                    ),
                  );
                },
              ),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ConfirmDialog(
                  title: 'Delete All Closed Tabs',
                  content:
                      'Are you sure you want to delete all closed tabs? This action is irreversible.',
                  onConfirmed: () async {
                    await TabsController.deleteAllTabs(tabs.map((t) => t.id).toList());
                    Navigator.pop(context); // Close dialog
                  },
                ),
              );
            },
            child: const Text('Delete All Closed Tabs'),
          ),
        ),
      ],
    );
  }
}
