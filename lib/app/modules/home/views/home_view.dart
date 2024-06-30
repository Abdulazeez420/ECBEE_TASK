// ignore_for_file: depend_on_referenced_packages

import 'package:ecbee_test_app/app/modules/login/controllers/login_controller.dart';
import 'package:ecbee_test_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:jiffy/jiffy.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    User? user = controller.auth.currentUser;
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        print("yes");
        final loginController = Get.put(LoginController());
        loginController.sendClick.value = true;
        loginController.getCode.value = false;
        // logic
      },
      child: Scaffold(
        backgroundColor: const Color(0xff2e2c5e),
        appBar: AppBar(
         
          automaticallyImplyLeading: false,
        
          
          backgroundColor: const Color(0xff2e2c5e),
         
          actions: [
            GestureDetector(
              onTap: () async {
                await controller.auth.signOut();
                final loginController = Get.put(LoginController());
                loginController.sendClick.value = true;
                loginController.getCode.value = false;
                Get.offNamedUntil(Routes.LOGIN, (route) => false);
              },
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 120),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: Get.height,
                width: Get.width,
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
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            height: 200,
                            width: Get.width - 100,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Color(0xFF121212),
                                  Color(0xff2e2c5e),
                                ],
                                stops: [0.4, 0.4],
                                transform: GradientRotation(30 * pi / 180),
                              ),
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 70),
                                    child: Text(
                                      'Generated Number',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Text(
                                      controller.randomNumber.toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(
                              0.0,
                              -300.0 / 2.0,
                            ),
                            child: Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Container(
                                  height: 180,
                                  width: 180,
                                  child: QrImageView(
                                    gapless: true,
                                    data: controller.qrCodeData,
                                    size: 200.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                      "Plugin",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ))),
              ),
              Positioned(
                bottom: 100,
                child: Container(
                  width: Get.width / 1.5,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.LOGIN_DETAILS,
                            preventDuplicates: false);
                      },
                      child: StreamBuilder(
                        stream: controller.firestore
                            .collection('login_details')
                            .where('userId', isEqualTo: user!.uid)
                            .where('timestamp',
                                isGreaterThanOrEqualTo: DateTime.now()
                                    .subtract(const Duration(days: 1)))
                            .orderBy('timestamp', descending: true)
                            .limit(1) // Get only the most recent login
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final loginDetails = snapshot.data!.docs;

                          if (loginDetails.isEmpty) {
                            return const Text('No login history found');
                          }

                          final lastLoginTime =
                              loginDetails.first['timestamp'].toDate();

                          final jiffy = Jiffy.parseFromDateTime(lastLoginTime);
                          final formattedTime =
                              jiffy.format(pattern: 'MMM d, yyyy, h:mm a');
                          return Text(
                            'Last login at: $formattedTime',
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      )),
                ),
              ),
              Obx(
                () => Positioned(
                  bottom: 20,
                  child: Container(
                    width: Get.width / 1.5,
                    decoration: BoxDecoration(
                        color: const Color(0xff3e3e3e),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: controller.isLoading.value == false
                          ? controller.saveData
                          : null,
                      child: controller.isLoading.value == false
                          ? const Text(
                              'Save',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            )
                          : const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
