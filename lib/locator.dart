import 'package:digitalproductstore/Service/auth/auth_service.dart';
import 'package:digitalproductstore/Service/firestore_loc.dart';
import 'package:digitalproductstore/Service/uploadDetails.dart';
import 'package:digitalproductstore/model/user_model.dart';
import 'package:get_it/get_it.dart';
import 'Service/profileImageUpload.dart';

GetIt sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton<AuthService>(() => AuthService());
  sl.registerLazySingleton<Users>(() => Users());
  sl.registerLazySingleton<ProfileImageUpload>(() => ProfileImageUpload());
  sl.registerLazySingleton<UploadDetails>(() => UploadDetails());
  sl.registerLazySingleton<FirebaseBloc>(() => FirebaseBloc());
}
