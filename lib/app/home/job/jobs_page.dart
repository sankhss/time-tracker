import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/job_entries/job_entries_page.dart';
import 'package:time_tracker/app/home/job/job_list_tile.dart';
import 'package:time_tracker/app/home/job/job_form_page.dart';
import 'package:time_tracker/app/home/job/list_items_builder.dart';
import 'package:time_tracker/app/models/job.dart';
import 'package:time_tracker/common_widgets/show_exception_alert.dart';
import 'package:time_tracker/services/database.dart';

class JobsPage extends StatelessWidget {
  Future<void> _delete(BuildContext context, Job job) async {
    final database = Provider.of<Database>(context, listen: false);
    try {
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlert(context, exception: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => JobFormPage.show(
              context,
              database: Provider.of<Database>(context, listen: false),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Job>>(
        stream: Provider.of<Database>(context, listen: false).jobsStream(),
        builder: (ctx, snapshot) {
          return ListItemsBuilder<Job>(
            snapshot: snapshot,
            itemBuilder: (ctx, job) => Dismissible(
              key: ValueKey(job.id),
              background: Container(
                color: Colors.red,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 40.0,
                ),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(
                  right: 15.0,
                ),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => _delete(context, job),
              child: JobListTile(
                job: job,
                onTap: () => JobEntriesPage.show(ctx, job),
              ),
            ),
          );
        },
      ),
    );
  }
}
