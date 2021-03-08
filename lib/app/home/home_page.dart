import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/account/account_page.dart';
import 'package:time_tracker/app/home/cupertino_home_scaffold.dart';
import 'package:time_tracker/app/home/entries/entries_page.dart';
import 'package:time_tracker/app/home/job/jobs_page.dart';
import 'package:time_tracker/app/home/tab_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get pageBuilders {
    return {
      TabItem.jobs: (_) => JobsPage(),
      TabItem.entries: (_) => EntriesPage.create(context),
      TabItem.account: (_) => AccountPage(),
    };
  }

  _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    }
    setState(() {
      _currentTab = tabItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectedTab: _selectTab,
        pageBuilders: pageBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
