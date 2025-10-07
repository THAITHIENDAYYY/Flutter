import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sharedbill/controllers/tabsController.dart';
import 'package:sharedbill/providers/settingsState.dart';
import 'package:sharedbill/widgets/changeAmountDialog.dart';
import 'package:intl/intl.dart';
import 'package:sharedbill/models/tab.dart';

class TabModal extends StatelessWidget {
  final TabModel tab;
  const TabModal({required this.tab});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: Provider.of<SettingsState>(context).selectedCurrency,
      decimalDigits: 2,
    );
    
    DateFormat formatter = DateFormat("yyyy/MM/dd");
    String formattedDateOpened =
        formatter.format((tab.time as Timestamp?)?.toDate() ?? DateTime.now());
    return Container(
      height: 450,
      margin: EdgeInsets.only(left: 18, right: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
                tab.userOwesFriend == true
                    ? "I Owe ${tab.name ?? ''}"
                    : "${tab.name ?? ''}'s Tab",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            Text(
              formattedDateOpened,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    "Amount",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  tab.description ?? '',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  currencyFormat.format(tab.amount ?? 0),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            Expanded(
              child: Image(
                image: AssetImage(
                  tab.userOwesFriend == true
                      ? 'assets/graphics/together.png'
                      : 'assets/graphics/money-guy.png',
                ),
                fit: BoxFit.contain,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton(
                  child: Text(tab.isClosed == true
                      ? "Reopen Tab"
                      : "Change Amount"),
                  onPressed: () {
                    if (tab.isClosed == true) {
                      TabsController.reopenTab(tab.id);
                      Navigator.pop(context);
                    } else
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ChangeAmountDialog(tab: tab);
                          });
                  },
                ),
                ElevatedButton(
                  child:
                      Text(tab.isClosed == true ? "Delete" : "Close Tab"),
                  onPressed: () {
                    tab.isClosed == true
                        ? TabsController.deleteTab(tab.id)
                        : TabsController.closeTab(tab.id);
                    Navigator.pop(context);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
