import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/common_widgets/format.dart';

void main() {
  group('hours', (){
    test('positive', (){
      expect(Format.hours(10), '10h');
    });
  });
}