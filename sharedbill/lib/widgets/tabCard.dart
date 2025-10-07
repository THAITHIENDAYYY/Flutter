import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sharedbill/providers/tabsState.dart';
import 'package:sharedbill/providers/settingsState.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:sharedbill/widgets/tabModal.dart';
import 'package:sharedbill/models/tab.dart';

class TabCard extends StatelessWidget {
  final TabModel tab;
  const TabCard({required this.tab});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: Provider.of<SettingsState>(context).selectedCurrency,
      decimalDigits: 2,
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onLongPress: () {
          Provider.of<TabsState>(context, listen: false).setFilter(tab.name);
        },
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) => TabModal(
              tab: tab,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                tab.name ?? '',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                currencyFormat.format(tab.amount ?? 0),
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Chip(
                backgroundColor: tab.isClosed == true
                    ? Theme.of(context).colorScheme.secondary.withAlpha(30)
                    : tab.userOwesFriend == true
                        ? Colors.redAccent.withAlpha(30)
                        : Theme.of(context).primaryColor.withAlpha(30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                label: Text(
                  tab.description ?? '',
                  style: TextStyle(
                      color: tab.isClosed == true
                          ? Theme.of(context).colorScheme.secondary
                          : tab.userOwesFriend == true
                              ? Colors.redAccent
                              : Theme.of(context).primaryColor),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (tab.isClosed == true)
                      Text(
                        "Closed",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    Text(
                      timeago.format(tab.isClosed == true
                          ? tab.time ?? DateTime.now()
                          : tab.time ?? DateTime.now()),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
