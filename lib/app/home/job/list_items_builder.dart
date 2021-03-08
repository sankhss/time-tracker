import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/job/empty_job_list.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  const ListItemsBuilder({Key key, this.snapshot, this.itemBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContentList();
      }
    } else if (snapshot.hasError) {
      return Center(
        child: Text(
          'An error has occurred',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
      itemCount: items.length + 2,
      separatorBuilder: (ctx, i) => Divider(),
      itemBuilder: (ctx, i) {
        if (i == 0 || i == items.length + 1) {
          return Container();
        }
        return itemBuilder(ctx, items[i - 1]);
      },
    );
  }
}
