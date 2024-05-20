import 'dart:typed_data';

class UserModel {
  final Object object;
  final String name;
  final String email;
  final String number;
  final Uint8List? profile;
  final String role;

  UserModel({
    required this.object,
    required this.name,
    required this.email,
    required this.number,
    required this.profile,
    required this.role,
  });
}
