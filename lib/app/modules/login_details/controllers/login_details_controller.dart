import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecbee_test_app/app/modules/login/controllers/login_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class LoginDetailsController extends GetxController {
final loginController=Get.put(LoginController());
 final FirebaseAuth auth = FirebaseAuth.instance;
 final FirebaseStorage storage = FirebaseStorage.instance;
 final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override

  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
