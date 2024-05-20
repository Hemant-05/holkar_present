import 'dart:typed_data';

class Student {
  final String roll;
  final String subject;
  final String semester;
  final String section;
  final List<List<String>> attendance;
  Student({
    required this.roll,
    required this.subject,
    required this.semester,
    required this.section,
    required this.attendance,
  });
}
