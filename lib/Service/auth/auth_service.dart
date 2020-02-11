import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:digitalproductstore/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  // final fblogin = FacebookLogin();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  // SharedPreferences sharedPreferences;
  String usernameSign;
  final Firestore firestore = Firestore();
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  User usersFromFirebase(FirebaseUser user) {
    if (user != null) {
      return User(
          uid: user?.uid,
          imageUrl: user?.photoUrl,
          name: user?.displayName,
          emailId: user?.email);
    } else {
      return null;
    }
  }

  // stream users
  Stream<User> get user {
    return auth.onAuthStateChanged.map(usersFromFirebase);
  }

  // ! ananomy as gust
  // Future signAnon() async {
  //   try {
  //     final result = await auth.signInAnonymously();
  //     FirebaseUser user = result.user;
  //     assert(user.isAnonymous != null);
  //     return true;
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

// ! Signin with email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      final AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final FirebaseUser user = result.user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      final String fcm = await firebaseMessaging.getToken();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final Map<String, Object> data = {
        'TimeCreated': Timestamp.now(),
        'Register By': 'Register Via Email Password',
        'id': user.uid,
        'refercode': user.uid.toString().substring(0, 6).toLowerCase(),
        'Email': user.email,
        'photo': user.isEmailVerified,
        'userToken': fcm,
        'Device': {
          'product': androidInfo.product,
          'model': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
          'version': androidInfo.version.release,
          'sdkVersion': androidInfo.version.sdkInt
        }
      };
      firestore.collection('Sellers').document(user.uid).updateData(data);
      final Map<String, String> data2 = {
        'Email': user.email,
        'Token': fcm,
        'refercode': user.uid.toString().substring(0, 6).toLowerCase(),
        'name': user.displayName ??
            user.uid.toString().substring(3, 8).toLowerCase(),
      };
      firestore
          .collection('Sellers')
          .document(user.uid)
          .collection('Token')
          .document(fcm)
          .setData(data2);
      return true;
    } catch (e) {
      switch (e.code) {
        case 'ERROR_USER_NOT_FOUND':
          // authError = 'Invalid Email';
          Fluttertoast.showToast(msg: 'This Email Does Not Exit');
          print('object');
          break;
        case 'ERROR_WRONG_PASSWORD':
          // authError = 'Wrong Password';
          Fluttertoast.showToast(msg: 'Wrong Password Please Check It');
          break;
        default:
          // authError = 'Error';
          break;
      }
      print(e.toString());
      return false;
    }
  }

  //! gooogle signinnnn

  Future<bool> signInWithGoogleeee() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount?.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );
      final AuthResult authResult =
          await auth?.signInWithCredential(credential);
      final FirebaseUser user = authResult?.user;
      assert(!user.isAnonymous);
      assert(await user?.getIdToken() != null);
      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoUrl != null);
      if (authResult != null) {
        final QuerySnapshot results = await Firestore.instance
            .collection('Sellers')
            .where('id', isEqualTo: user.uid)
            .getDocuments();
        final List<DocumentSnapshot> documents = results.documents;
        final String fcm = await firebaseMessaging.getToken();
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        if (documents.isEmpty) {
          final Map<String, Object> data = {
            'TimeCreated': Timestamp.now(),
            'Register By': 'Register Via Email Password',
            'id': user.uid,
            'refercode': user.uid.toString().substring(0, 6).toLowerCase(),
            'name': user.displayName ??
                user.uid.toString().substring(3, 8).toLowerCase(),
            'Email': user.email,
            'photo': user.isEmailVerified,
            'Verification': true,
            'Reward': 0,
            'Verification': false,
            'formstatus': false,
            'userToken': fcm,
            'Device': {
              'product': androidInfo.product,
              'model': androidInfo.model,
              'manufacturer': androidInfo.manufacturer,
              'version': androidInfo.version.baseOS,
              'sdkVersion': androidInfo.version.sdkInt
            }
          };
          Firestore.instance
              .collection('Sellers')
              .document(user.uid)
              .setData(data);
          final Map<String, String> data2 = {
            'Email': user.email,
            'Token': fcm,
            'refercode': user.uid.toString().substring(0, 6).toLowerCase(),
            'name': user.displayName ??
                user.uid.toString().substring(3, 8).toLowerCase()
          };
          firestore
              .collection('Sellers')
              .document(user.uid)
              .collection('Token')
              .document(fcm)
              .setData(data2);
        } else {
          final Map<String, Object> data = {
            'TimeCreated': Timestamp.now(),
            'Register By': 'Register Via Google Sign In',
            'id': user.uid,
            'refercode': user.uid.toString().substring(0, 6).toLowerCase(),
            'Email': user.email,
            'photo': user.isEmailVerified,
            'userToken': fcm,
            'Device': {
              'product': androidInfo.product,
              'model': androidInfo.model,
              'manufacturer': androidInfo.manufacturer,
              'version': androidInfo.version.release,
              'sdkVersion': androidInfo.version.sdkInt
            }
          };
          Firestore.instance
              .collection('Sellers')
              .document(user.uid)
              .updateData(data);
          final Map<String, String> data2 = {
            'Email': user.email,
            'Token': fcm,
            'refercode': user.uid.toString().substring(0, 6).toLowerCase(),
            'name': user.displayName ??
                user.uid.toString().substring(3, 8).toLowerCase(),
          };
          firestore
              .collection('Sellers')
              .document(user.uid)
              .collection('Token')
              .document(fcm)
              .setData(data2);
        }
      }
      final FirebaseUser currentUser = await auth.currentUser();
      assert(user.uid == currentUser.uid);
      return true;
    } catch (e) {
      print(e.toString());
      switch (e.code) {
        case 'sign_in_failed':
          Fluttertoast.showToast(msg: 'Opps! Something went wrong!');
          break;
        default:
          break;
      }
      return false;
    }
  }

//! reffer
  Future<dynamic> refferal(String refercode, String name) async {
    try {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      // final String uid = user.uid.toString();
      // final ref = firestore.collection('users').document();
      // String refercode;
      // final getRef =  firestore.collection('users').document(uid).snapshots();
      // getRef.listen((snapshot) async{
      //   refercode = await snapshot.data['refercode'];
      // });
      // todo: add
      final QuerySnapshot results = await Firestore.instance
          .collection('Sellers')
          .where('refercode', isEqualTo: refercode)
          .getDocuments();
      final List<DocumentSnapshot> documents = results.documents;
      if (documents.isNotEmpty || documents.length == 1) {
        List.generate(documents?.length, (int i) {
          final Map<String, FieldValue> data2 = {
            'Reward': (results.documents[i].data['refercode'] == refercode)
                ? FieldValue.increment(25)
                : null
          };
          firestore
              .collection('Sellers')
              .document(documents[i].data['id'])
              .updateData(data2);
          final Map<String, Object> data3 = {
            'RefferalId': refercode,
            'Name': name,
            'Time joined': Timestamp.now(),
            'id': user.uid,
          };
          firestore
              .collection('Sellers')
              .document(documents[i].data['id'])
              .collection('joined User')
              .document(user.uid)
              .setData(data3);
          if (results.documents[i].data['refercode']
              .toString()
              .contains(refercode)) {
            Fluttertoast.showToast(msg: 'Verification Pending');
          } else if (!results.documents[i].data['refercode']
              .toString()
              .contains(refercode)) {
            Fluttertoast.showToast(msg: 'Invalid ReferCode');
          }
        });
      } else if (refercode.isEmpty) {
      } else {
        return false;
      }

      // if (documents.length == 1) {
      //   Firestore.instance.collection('Sellers').document(user.uid).collection('joined').document(user.displayName).updateData({
      //     'TimeCreated': Timestamp.now(),
      //     'Register By': 'registerWithEmailAndPassword',
      //     'id': user.uid,
      //     'refercode': user.displayName ?? user.uid.toString().substring(0, 6),
      //     'name': user.displayName ?? user.uid.toString().substring(3, 8),
      //     'Email': user.email,
      //     'photo': user.isEmailVerified,
      //     'Reward': (results.documents[0].data['refercode'] == refercode) ? FieldValue.increment(50) : null
      //   });
      // } else {
      //   Firestore.instance.collection('Sellers').document(user.uid).updateData({
      //     'TimeCreated': Timestamp.now(),
      //     'Register By': 'registerWithEmailAndPassword',
      //     'id': user.uid,
      //     'refercode': user.displayName ?? user.uid.toString().substring(0, 6),
      //     'name': user.displayName ?? user.uid.toString().substring(3, 8),
      //     'Email': user.email,
      //     'photo': user.isEmailVerified,
      //   });
      // }

      // final database = FirebaseDatabase();
      // int path = 20;
      // final dataRef = database
      //     .reference()
      //     .child(user.displayName)
      //     .reference()
      //     .child('referCode')
      //     .child('referCode');
      // database
      //     .reference()
      //     .child(user.displayName)
      //     .reference()
      //     .child('referCode')
      //     .child('joined')
      //     .reference()
      //     .child(user.displayName)
      //     .set({
      //   'JoinedPerson': user.displayName.toString(),
      //   'uid': user.uid.toString()
      // });
      // database
      //     .reference()
      //     .child(user.displayName)
      //     .reference()
      //     .child('referCode')
      //     .child('referCode')
      //     .once()
      //     .then((DataSnapshot onValue) => path = int.parse('${onValue.value}'));

      // dataRef.runTransaction((MutableData transaction) async {
      //   transaction.value = (uid == refercode ? path : -20) + 20;
      //   return transaction;
      // });
      //  return await FirebaseDatabase().reference().child('referCode').child(user.displayName).push().update({
      //       'pop': FieldValue.increment(1).toString(),
      //     });
      //  return  ref.updateData({
      //     'referalId': user.displayName ?? user.uid.toString().substring(0, 6),
      //     'pop': (refercode == referCode)
      //         ? FieldValue.increment(1)
      //         : FieldValue.increment(-1)
      //   });

    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // ! register with email and password
  Future<bool> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final AuthResult result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final FirebaseUser user = result.user;
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      if (result != null) {
        final QuerySnapshot results = await Firestore.instance
            .collection('Sellers')
            .where('id', isEqualTo: user.uid)
            .getDocuments();
        final List<DocumentSnapshot> documents = results.documents;
        final String fcm = await firebaseMessaging.getToken();
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        if (documents.isEmpty) {
          final Map<String, Object> data = {
            'TimeCreated': Timestamp.now(),
            'Register By': 'Register Via Email Password',
            'id': user.uid,
            'refercode': user.uid.toString().substring(0, 6).toLowerCase(),
            'name': user.displayName ??
                user.uid.toString().substring(3, 8).toLowerCase(),
            'Email': user.email,
            'photo': user.isEmailVerified,
            'Verification': true,
            'Reward': 0,
            'Verification': false,
            'formstatus': false,
            'userToken': fcm,
            'Device': {
              'product': androidInfo.product,
              'model': androidInfo.model,
              'manufacturer': androidInfo.manufacturer,
              'version': androidInfo.version.baseOS,
              'sdkVersion': androidInfo.version.sdkInt
            }
          };
          Firestore.instance
              .collection('Sellers')
              .document(user.uid)
              .setData(data);
          final data2 = {
            'Email': user.email,
            'Token': fcm,
            'refercode': user.uid.toString().substring(0, 6).toLowerCase(),
            'name': user.displayName ??
                user.uid.toString().substring(3, 8).toLowerCase(),
          };
          firestore
              .collection('Sellers')
              .document(user.uid)
              .collection('Token')
              .document(fcm)
              .setData(data2);
        } else {
          final data = {
            'TimeCreated': Timestamp.now(),
            'Register By': 'Register Via Email Password',
            'id': user.uid,
            'refercode': user.uid.toString().substring(0, 6).toLowerCase(),
            'Email': user.email,
            'photo': user.isEmailVerified,
            'userToken': fcm,
            'Device': {
              'product': androidInfo.product,
              'model': androidInfo.model,
              'manufacturer': androidInfo.manufacturer,
              'version': androidInfo.version.release,
              'sdkVersion': androidInfo.version.sdkInt
            }
          };
          Firestore.instance
              .collection('Sellers')
              .document(user.uid)
              .updateData(data);
          final Map<String, String> data2 = {
            'Email': user.email,
            'Token': fcm,
            'refercode': user.uid.toString().substring(0, 6).toLowerCase(),
            'name': user.displayName ??
                user.uid.toString().substring(3, 8).toLowerCase(),
          };
          firestore
              .collection('Sellers')
              .document(user.uid)
              .collection('Token')
              .document(fcm)
              .setData(data2);
        }
      }
      return true;
    } catch (e) {
      print(e.toString());

      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          // authError = 'Invalid Email';
          Fluttertoast.showToast(msg: 'Invaild Email Id');
          print('object');
          break;
        case 'ERROR_USER_NOT_FOUND':
          // authError = 'User Not Found';
          break;
        case 'ERROR_WRONG_PASSWORD':
          // authError = 'Wrong Password';
          break;
        default:
          // authError = 'Error';
          break;
      }
      return false;
    }
  }

// ! reset password
  Future<bool> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<dynamic> emailError(String email) async {
    try {
      return await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on PlatformException catch (e) {
      print(e.toString());
      return false;
    }
  }

  // //! data load
  // dataload() async {
  //   final ss = auth.signInAnonymously();
  //   try {
  //     if (ss != null) {
  //       return true;
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     return false;
  //   }
  // }

  // // ! facebook login
  // Future facebookLogin() async {
  //   FirebaseUser currentUser;
  //   // fbLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
  //   // if you remove above comment then facebook login will take username and pasword for login in Webview

  //   try {
  //     final FacebookLoginResult facebookLoginResult =
  //         await fblogin.logIn(['email', 'public_profile']);
  //     if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
  //       FacebookAccessToken facebookAccessToken =
  //           facebookLoginResult.accessToken;
  //       final AuthCredential credential = FacebookAuthProvider.getCredential(
  //           accessToken: facebookAccessToken.token);
  //           fblogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
  //       final FirebaseUser user =
  //           (await auth.signInWithCredential(credential)).user;
  //       assert(user.email != null);
  //       assert(user.displayName != null);
  //       assert(!user.isAnonymous);
  //       if (facebookLoginResult != null) {
  //         final QuerySnapshot results = await Firestore.instance
  //             .collection('path')
  //             .where('id', isEqualTo: user.uid)
  //             .getDocuments();
  //         final List<DocumentSnapshot> documents = results.documents;

  //         if (documents.length == 0) {
  //           Firestore.instance.collection('users').document(user.uid).setData({
  //             'Register By': 'facebook',
  //             'id': user.uid,
  //             'Email': user.email,
  //             'photo': user.photoUrl,
  //             'phoneNumber': user.phoneNumber,
  //           });

  //           // await sharedPreferences.setString('id', user.uid);
  //           // await sharedPreferences.setString('Email', user.email);
  //           // await sharedPreferences.setString('photo', user.email);
  //         } else {
  //           // await sharedPreferences.setString('id', documents[0]['id']);
  //           // await sharedPreferences.setString('Email', documents[0]['Email']);
  //           // await sharedPreferences.setString('photo', documents[0]['photo']);
  //            Fluttertoast.showToast(msg: 'login sucessed');
  //         }

  //       }
  //       assert(await user.getIdToken() != null);
  //       currentUser = await auth.currentUser();
  //       assert(user.uid == currentUser.uid);
  //       return true;
  //     }
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  // !signout for anomn
  Future<void> signOut() async => await auth.signOut();
}
