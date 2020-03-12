import 'package:digitalproductstore/Service/auth/auth_service.dart';
import 'package:digitalproductstore/model/user_model.dart';
import 'package:get_it/get_it.dart';

GetIt ls = GetIt.instance;

void setupLocator() {
  ls.registerLazySingleton<AuthService>(() => AuthService());
  ls.registerLazySingleton<Users>(() => Users());
}
