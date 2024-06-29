class UserModel {
  final Object object;
  final String name;
  final String email;
  final String number;
  final String? profile;
  final String role;
  final String uid;

  UserModel({
    required this.object,
    required this.name,
    required this.email,
    required this.number,
    required this.profile,
    required this.role,
    required this.uid,
  });
  Map<String, dynamic> toMap() {
    return {
      'object': object,
      'name': name,
      'email': email,
      'number': number,
      'profile': profile,
      'role': role,
      'uid': uid,
    };
  }
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      object: map['object'] as Object,
      name: map['name'] as String,
      email: map['email'] as String,
      number: map['number'] as String,
      profile: map['profile'] as String?,
      role: map['role'] as String,
      uid: map['uid'] as String,
    );
  }
}