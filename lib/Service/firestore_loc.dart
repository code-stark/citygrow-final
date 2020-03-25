import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FirebaseBloc {
  final Firestore firestore = Firestore.instance;
//! Fav Selector
  void uploadFav(data, String uid, String productUid) async {
    final String uuid = Uuid().v1();
    await firestore
        .collection("AppUsers")
        .document(uid)
        .collection('favorite')
        .document(uuid)
        .setData(data);
    await firestore
        .collection("AppUsers")
        .document(uid)
        .collection('favorite')
        .document(uuid)
        .updateData(
            {'productUid': productUid, 'selection': 'favorite'});
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
//! Comments data

  void commentData(data) {
    final String uuid = Uuid().v1();
    firestore.collection("comments").document(uuid).setData(data);
  }

  void commentInIt(data, uid) {
    final String uuid = Uuid().v1();
    firestore
        .collection("comments")
        .document(uid)
        .collection('comments')
        .document(uuid)
        .setData(data);
  }

  //! Add basketStore
  void uploadBasket(data, String uid, String productUid) async {
    final String uuid = Uuid().v1();
    await firestore
        .collection("AppUsers")
        .document(uid)
        .collection('cart')
        .document(uuid)
        .setData(data);
    await firestore
        .collection("AppUsers")
        .document(uid)
        .collection('cart')
        .document(uuid)
        .updateData({'productUid': productUid, 'selection': 'cart'});
  }

  //! Delete basketStore
  void deleteBasket(uuids, String uid) {
    firestore
        .collection("AppUsers")
        .document(uid)
        .collection('cart')
        .document(uuids)
        .delete();
  }

  //! order
  void orderProduct(uid, List<DocumentSnapshot> data) async {
    for (var i = 0; i < data.length; i++) {
      final String uuid = Uuid().v1();
      await firestore
          .collection("AppUsers")
          .document(uid)
          .collection('order')
          .document(uuid)
          .setData(data[i].data)
          .whenComplete(() => firestore
                  .collection("AppUsers")
                  .document(uid)
                  .collection('order')
                  .document(uuid)
                  .updateData({
                'timestamp': Timestamp.now(),
                'transactionID': uuid.substring(0, 8),
                'status': 'pending',
                'buyeruid': uid
              }));

      await firestore
          .collection("Sellers")
          .document(data[i].data['PersonID'])
          .collection('order')
          .document(uuid)
          .setData(data[i].data)
          .whenComplete(() => firestore
                  .collection("Sellers")
                  .document(data[i].data['PersonID'])
                  .collection('order')
                  .document(uuid)
                  .updateData({
                'timestamp': Timestamp.now(),
                'transactionID': uuid.substring(0, 8),
                'status': 'pending',
                'buyeruid': uid
              }));
      await firestore
          .collection("AppUsers")
          .document(uid)
          .collection('cart')
          .document(data[i].documentID)
          .delete();
    }
  }
}
