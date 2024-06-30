import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/login_details/bindings/login_details_binding.dart';
import '../modules/login_details/views/login_details_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();
  
  static var  INITIAL = FirebaseAuth.instance.currentUser == null ? Routes.LOGIN : Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_DETAILS,
      page: () => const LoginDetailsView(),
      binding: LoginDetailsBinding(),
    ),
  ];
}
