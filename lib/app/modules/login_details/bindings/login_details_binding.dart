import 'package:get/get.dart';

import '../controllers/login_details_controller.dart';

class LoginDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginDetailsController>(
      () => LoginDetailsController(),
    );
  }
}
