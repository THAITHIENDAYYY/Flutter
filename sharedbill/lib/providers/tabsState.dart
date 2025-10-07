import 'package:sharedbill/controllers/tabsController.dart';
import 'package:sharedbill/models/tab.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class TabsState extends ChangeNotifier {
  List<TabModel> _allTabs = [];
  String? _filterName;
  StreamSubscription? _tabsSubscription;

  TabsState() {
    _initStream();
  }

  void _initStream() {
    _tabsSubscription?.cancel(); // Cancel previous subscription if any
    _tabsSubscription = TabsController.getTabsStream().listen((snapshot) {
      _allTabs = snapshot.docs
          .map((doc) => TabModel.fromDocument(doc))
          .toList();
      notifyListeners(); // Notify listeners when tabs data changes
    });
  }

  @override
  void dispose() {
    _tabsSubscription?.cancel(); // Cancel subscription when state is disposed
    super.dispose();
  }

  List<TabModel> get allTabs => _allTabs;

  List<TabModel> get openTabs => _allTabs
      .where((tab) =>
          !tab.isClosed &&
          (_filterName == null ||
              tab.name.toLowerCase().contains(_filterName!.toLowerCase())))
      .toList();

  List<TabModel> get closedTabs => _allTabs
      .where((tab) =>
          tab.isClosed &&
          (_filterName == null ||
              tab.name.toLowerCase().contains(_filterName!.toLowerCase())))
      .toList();

  bool get filterEnabled => _filterName != null;

  String? get name => _filterName;

  void setFilter(String name) {
    _filterName = name;
    notifyListeners();
  }

  void clearFilter() {
    _filterName = null;
    notifyListeners();
  }

  bool nameMatches(String name) {
    if (!filterEnabled) return true;
    return name == _filterName;
  }
}
