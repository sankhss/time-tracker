import 'package:time_tracker/app/models/entry.dart';
import 'package:time_tracker/app/models/job.dart';
import 'package:time_tracker/services/api_paths.dart';
import 'package:time_tracker/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<Job> jobStream(String jobId);
  Stream<List<Job>> jobsStream();

  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Job job});
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  final String uid;

  FirestoreDatabase(this.uid) : assert(uid != null);

  final _service = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) async => await _service.setData(
        path: APIPaths.job(uid, job.id),
        data: job.toMap(),
      );

  @override
  Future<void> deleteJob(Job job) async {
    final entries = await entriesStream(job: job).first;
    for (Entry entry in entries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    await _service.deleteData(
      path: APIPaths.job(uid, job.id),
    );
  }

  @override
  Stream<Job> jobStream(String jobId) => _service.documentStream(
        path: APIPaths.job(uid, jobId),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPaths.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Future<void> setEntry(Entry entry) => _service.setData(
        path: APIPaths.entry(uid, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) => _service.deleteData(
        path: APIPaths.entry(uid, entry.id),
      );

  @override
  Stream<List<Entry>> entriesStream({Job job}) =>
      _service.collectionStream<Entry>(
        path: APIPaths.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}
