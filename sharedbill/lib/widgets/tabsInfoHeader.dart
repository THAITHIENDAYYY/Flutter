import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sharedbill/providers/tabsState.dart';
import 'package:sharedbill/providers/settingsState.dart';
import 'package:intl/intl.dart';

class TabsInfoHeader extends StatelessWidget {
  final List<DocumentSnapshot> openTabs;

  const TabsInfoHeader({required this.openTabs});

  String getTotalAmountFormatted(
      List<DocumentSnapshot> tabs, String currencySymbol) {
    double total = 0;
    for (DocumentSnapshot tab in tabs) {
      if (tab["closed"] != true)
        tab["userOwesFriend"] == true
            ? total -= tab["amount"]
            : total += tab["amount"];
    }
    final currencyFormat = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: 2,
    );
    return currencyFormat.format(total);
  }

  String getHeaderText(List<DocumentSnapshot> tabs) {
    String text = "${tabs.length} open tab";
    if (tabs.length != 1) text += "s";
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: openTabs.isNotEmpty
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          if (Provider.of<TabsState>(context).filterEnabled)
            Text(
              "${Provider.of<TabsState>(context).name}'s tabs",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            )
          else
            Text(
              getHeaderText(openTabs),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          Text(
            getTotalAmountFormatted(
              openTabs,
              Provider.of<SettingsState>(context).selectedCurrency,
            ),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}
