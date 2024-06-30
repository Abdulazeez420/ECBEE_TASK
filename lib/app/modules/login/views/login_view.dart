import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        backgroundColor: const Color(0xff2e2c5e),
      body: Padding(
        padding:  EdgeInsets.only(top: Get.height/5),
        child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: Get.height / 1.2,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Phone number input
                      Form(
                        key: controller.phoneFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                "Phone Number",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: Color(0xff2e2c5e)),
                              child: TextFormField(
                                style: const TextStyle(color: Colors.white),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  prefixIcon: Obx(
                                    () => Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 15),
                                      child: InkWell(
                                          onTap: () {
                                            controller.codeSelect();
                                          },
                                          child: Text(
                                            "+ ${controller.countrycode.value}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
                                          )),
                                    ),
                                  ),
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  return null;
                                },
                                onSaved: (value) =>
                                    controller.phoneNumber.value = value!,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => Visibility(
                            visible: controller.sendClick.value,
                            child: Column(
                              children: [
                                const SizedBox(height: 50),
                                Container(
                                  width: Get.width / 2,
                                  child: ElevatedButton(
                                    child: controller. isLoading1.value==false? Text('Send OTP'):CircularProgressIndicator(),
                                    onPressed: () async {
                                      if (controller.phoneFormKey.currentState!
                                          .validate()) {
                                        controller.phoneFormKey.currentState!
                                            .save();
                                        await controller.sendVerificationCode();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )),
                      ),
        
                      const SizedBox(height: 20),
                      // SMS code input
                      Obx(
                        () => Visibility(
                          visible: controller.getCode.value,
                          child: Column(
                            children: [
                              Form(
                                key: controller.smsFormKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        "OTP",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          color: Color(0xff2e2c5e)),
                                      child: TextFormField(
                                        inputFormatters: [LengthLimitingTextInputFormatter(6)],
                                        style:
                                            const TextStyle(color: Colors.white),
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(left: 10),
                                          border: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter the OTP';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) =>
                                            controller.smsCode.value = value!,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 50),
                              Container(
                                width: Get.width / 2,
                                child: ElevatedButton(
                                  child:controller. isLoading2.value==false? Text('Login'):CircularProgressIndicator(),
                                  onPressed: () async {
                                    if (controller.smsFormKey.currentState!
                                        .validate()) {
                                      controller.smsFormKey.currentState!.save();
                                      await controller.signInWithCredential();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0.0, -50.0 / 2.0),
                child: Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                        color: const Color(0xff00a3ff),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                        child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ))),
              ),
            ],
          ),
      ),
        
          ),
    );
  }
}
