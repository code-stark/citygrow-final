import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FirebaseBloc {
  final Firestore firestore = Firestore.instance;
//! Fav Selector
  void uploadFav(data, String uid) {
    final String uuid = Uuid().v1();
    firestore
        .collection("AppUsers")
        .document(uid)
        .collection('favorite')
        .document(uuid)
        .setData(data);
  }
//! Fav remover

  void deleteFav(uuids, String uid) {
    firestore
        .collection("AppUsers")
        .document(uid)
        .collection('favorite')
        .document(uuids)
        .delete();
  }

//! Rating data

  void ratingData(data) {
    final String uuid = Uuid().v1();
    firestore.collection("rating").document(uuid).setData(data);
  }
}
