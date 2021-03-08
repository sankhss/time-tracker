import 'package:flutter/foundation.dart';

class Job {
  final String id;
  final String name;
  final int ratePerHour;

  Job({
    @required this.id,
    @required this.name,
    @required this.ratePerHour,
  });

  factory Job.fromMap(Map<String, dynamic> map, String id) {
    if (map == null) {
      return null;
    }
    return Job(
      id: id,
      name: map['name'],
      ratePerHour: map['ratePerHour'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
