import 'package:cloud_firestore/cloud_firestore.dart';

class UploadDetails {
  final Firestore firestore = Firestore.instance;

  Future uploadDetailsFun(Map<String, dynamic> data, uid) {
    return firestore.collection("AppUsers").document(uid).updateData(data);
  }
}
