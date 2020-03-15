import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ProfileImageUpload {
  String appusers = 'AppUsers';
  Future uploadProfileImage() async {
    try {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      final String uid = user.uid.toString();

      final dynamic image = await ImagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);
      final String id = Uuid().v1();
      final FirebaseStorage storage = FirebaseStorage.instance;
      final String picture1 = '1${id.substring(0, 8)}.jpg';

      final StorageUploadTask task1 = storage
          .ref()
          .child(appusers)
          .child(uid)
          .child('Profile')
          .child(picture1)
          .putFile(image);
      final StorageTaskSnapshot snapshot1 = await task1.onComplete
          .then((StorageTaskSnapshot snapshot) => snapshot)
          .whenComplete(() => Fluttertoast.showToast(msg: 'Wait Uploading'));
      final dynamic imageUrl1 = await snapshot1.ref.getDownloadURL();
      // sl.get<ProductService>().uploadImage({"User Image": imageUrl1});
      final Map<String, dynamic> images = {'ProfileImage': imageUrl1};
      uploadImage(images);
    } catch (e) {
      print(e.toString());
      if (e.toString().contains('existsSync')) {
        Fluttertoast.showToast(msg: 'cancelled');
      }
      return null;
    }
  }

  void uploadImage(Map<String, dynamic> images) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    Firestore.instance
        .collection(appusers)
        .document(uid)
        .updateData(images)
        .whenComplete(() {
      Fluttertoast.showToast(msg: 'Image Uploaded');
    });
  }

  void updateImage(Map<String, dynamic> images) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    Firestore.instance
        .collection(appusers)
        .document(uid)
        .updateData(images)
        .whenComplete(() {
      Fluttertoast.showToast(msg: 'Image Updated');
    });
  }

  Future updateProfileImage() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    var id = Uuid().v1();
    Fluttertoast.showToast(msg: "Wait Uploading");

    final FirebaseStorage storage = FirebaseStorage.instance;
    final String picture1 = "1${id.substring(0, 8)}.jpg";
    StorageUploadTask task1 = storage
        .ref()
        .child(uid)
        .child('Profile')
        .child(picture1)
        .putFile(image);
    StorageTaskSnapshot snapshot1 =
        await task1.onComplete.then((snapshot) => snapshot);
    var imageUrl1 = await snapshot1.ref.getDownloadURL();
    updateImage({'ProfileImage': imageUrl1});
  }
}
