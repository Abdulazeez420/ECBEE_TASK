import 'package:country_picker/country_picker.dart';
import 'package:ecbee_test_app/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool sendClick=true.obs;
  RxBool getCode=false.obs;
  RxBool isLoading1=false.obs;
  RxBool isLoading2=false.obs;
 final FirebaseAuth auth = FirebaseAuth.instance;
  RxString phoneNumber = ''.obs;
  RxString smsCode = ''.obs;
  String verificationId = '';
  RxString countrycode=''.obs;
  final phoneFormKey = GlobalKey<FormState>();
  final smsFormKey = GlobalKey<FormState>();
  void codeSelect(){
showCountryPicker(
  context:Get.context!,
  showPhoneCode: true, // optional. Shows phone code before the country name.
  onSelect: (Country country) {
    countrycode.value=country.phoneCode;
    
    print('Select country: ${country.phoneCode}');
    
  },
  favorite: ['IN']
);
  }
  
 Future<void> sendVerificationCode() async {
  isLoading1.value=true;
    await auth.verifyPhoneNumber(
      phoneNumber: "+${countrycode.value}${phoneNumber.value}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        Get.toNamed(Routes.HOME);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verId, int? resendToken) {
       
          verificationId = verId;
          print("1st");
          sendClick.value=false;
           isLoading1.value=false;
          getCode.value=true;
      
      },
      codeAutoRetrievalTimeout: (String verId) {
       
          verificationId = verId;
           print("2st");
        
      },
    );
  }

  Future<void> signInWithCredential() async {
  isLoading2.value=true;
    try {
       PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode.value);
    await auth.signInWithCredential(credential);

    Get.toNamed(Routes.HOME);
     isLoading2.value=false;
    } catch (e) {
     
    }
   
  }
  @override
  void onInit() {
    super.onInit();
   countrycode.value='91';
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
