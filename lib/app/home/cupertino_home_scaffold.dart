import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/tab_item.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, WidgetBuilder> pageBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  const CupertinoHomeScaffold({
    Key key,
    @required this.currentTab,
    @required this.onSelectedTab,
    @required this.pageBuilders,
    this.navigatorKeys,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _buildItem(TabItem.jobs),
          _buildItem(TabItem.entries),
          _buildItem(TabItem.account),
        ],
        onTap: (i) => onSelectedTab(TabItem.values[i]),
        activeColor: Colors.indigo,
      ),
      tabBuilder: (context, i) {
        final tabItem = TabItem.values[i];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[tabItem],
          builder: (context) => pageBuilders[tabItem](context),
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.tabs[tabItem];
    return BottomNavigationBarItem(
      label: itemData.title,
      icon: Icon(
        itemData.icon,
      ),
    );
  }
}
