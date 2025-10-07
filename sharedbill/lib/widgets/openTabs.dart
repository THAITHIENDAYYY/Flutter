import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sharedbill/controllers/tabsController.dart';
import 'package:sharedbill/widgets/tabCard.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:sharedbill/widgets/confirmDialog.dart';
import 'package:sharedbill/providers/tabsState.dart';
import 'package:sharedbill/models/tab.dart';

class OpenTabs extends StatelessWidget {
  final List<TabModel> openTabs;

  const OpenTabs(this.openTabs, {Key? key}) : super(key: key);

  final options = const LiveOptions(
    delay: Duration(milliseconds: 0),
    showItemInterval: Duration(milliseconds: 60),
    showItemDuration: Duration(milliseconds: 187),
  );

  @override
  Widget build(BuildContext context) {
    if (openTabs.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            Provider.of<TabsState>(context).filterEnabled
                ? 'Open Tabs for ${Provider.of<TabsState>(context).name}'
                : 'Open Tabs',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(
          height: 300, // Adjust height as needed
          child: LiveGrid.options(
            itemCount: openTabs.length,
            options: options,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (
              BuildContext context,
              int index,
              Animation<double> animation,
            ) =>
                FadeTransition(
              opacity: Tween<double>(
                begin: 0,
                end: 1,
              ).animate(animation),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-2, -0.1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.fastLinearToSlowEaseIn,
                )),
                child: TabCard(
                  tab: openTabs[index],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
