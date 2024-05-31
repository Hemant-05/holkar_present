import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageServices {
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  FirebaseStorageServices({
    required FirebaseStorage storage,
    required FirebaseAuth auth,
  })  : _storage = storage,
        _auth = auth;

  Future<String> uploadImage(Uint8List file) async{
    String uuid = Uuid().v1();
    final ref = _storage.ref().child('profile').child(uuid);
    final uploadTask = ref.putData(file);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}
