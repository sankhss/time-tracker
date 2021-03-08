import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/models/job.dart';
import 'package:time_tracker/common_widgets/show_exception_alert.dart';
import 'package:time_tracker/common_widgets/show_platform_alert_dialog.dart';
import 'package:time_tracker/services/database.dart';

class JobFormPage extends StatefulWidget {
  final Database database;
  final Job job;

  const JobFormPage({Key key, @required this.database, this.job}) : super(key: key);

  static Future<void> show(BuildContext context, {Database database, Job job}) {
    return Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      builder: (ctx) => JobFormPage(database: database, job: job),
      fullscreenDialog: true,
    ));
  }

  @override
  _JobFormPageState createState() => _JobFormPageState();
}

class _JobFormPageState extends State<JobFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameFocus = FocusNode();
  final _rateFocus = FocusNode();

  bool _isLoading = false;

  String _name;
  int _ratePerHour;

  @override
  void initState() { 
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSave()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final jobs = await widget.database.jobsStream().first;
        final names = jobs.map((job) => job.name).toList();
        if (names.contains(_name) && widget.job == null) {
          showPlatformAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please use a different job name.',
            defaultActionText: 'Ok',
          );
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          await widget.database.setJob(Job(
            id: id,
            name: _name,
            ratePerHour: _ratePerHour,
          ));
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlert(
          context,
          title: 'Operation failed',
          exception: e,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: [
          FlatButton(
            onPressed: _isLoading ? null : _submit,
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: _isLoading
          ? _showLoading()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          initialValue: _name,
                          textInputAction: TextInputAction.next,
                          focusNode: _nameFocus,
                          onSaved: (value) => _name = value,
                          validator: (value) =>
                              value.isNotEmpty ? null : 'Name can\'t be empty.',
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_rateFocus),
                          decoration: InputDecoration(
                            labelText: 'Name',
                          ),
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          textInputAction: TextInputAction.done,
                          focusNode: _rateFocus,
                          onSaved: (value) =>
                              _ratePerHour = int.tryParse(value) ?? 0,
                          validator: (value) =>
                              value.isNotEmpty ? null : 'Rate can\'t be empty.',
                          onEditingComplete: _submit,
                          decoration: InputDecoration(
                            labelText: 'Rate Per Hour',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _showLoading() {
    return Center(child: CircularProgressIndicator());
  }
}
