import 'dart:convert';

import 'package:ecbee_test_app/app/modules/login/controllers/login_controller.dart';
import 'package:ecbee_test_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

import '../controllers/login_details_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LoginDetailsView extends GetView<LoginDetailsController> {
  const LoginDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    User? user = controller.auth.currentUser;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xff2e2c5e),
        appBar: AppBar(
           leading: IconButton(onPressed: (){
            Get.back();
           }, icon: const Icon(Icons.arrow_back_ios,color: Colors.white,)),
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
                height: Get.height / 1.2,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const TabBar(
                        labelColor: Colors.white,
                        indicatorColor: Colors.transparent,
                        dividerColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.only(left: 50),
                        indicatorWeight: 4,
                        indicatorSize: TabBarIndicatorSize.label,
                        isScrollable: true,
                        tabAlignment:
                            TabAlignment.start, // Align tabs to the left
                        automaticIndicatorColorAdjustment: true,
      
                        tabs: [
                          Tab(text: 'Today'),
                          Tab(text: 'Yesterday'),
                          Tab(text: 'Other'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            TodayTab(user: user),
                            YesterdayTab(user: user),
                            OtherTab(user: user),
                          ],
                        ),
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
                      "Last Login",
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

class TodayTab extends StatelessWidget {
  final User? user;

  TodayTab({required this.user});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginDetailsController());
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return StreamBuilder(
      stream: controller.firestore
          .collection('login_details')
          .where('userId', isEqualTo: user!.uid)
          .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
          .where('timestamp', isLessThan: endOfDay)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final loginDetails = snapshot.data!.docs;

        return  loginDetails.isEmpty
            ? const Center(
                child: Text(
                  "No Active Data",
                  style: TextStyle(color: Colors.white),
                ),
              )
            :ListView.builder(
          itemCount: loginDetails.length,
          itemBuilder: (context, index) {
            var detail = loginDetails[index];

            final jiffy = Jiffy.parseFromDateTime(detail['timestamp'].toDate());
            final formattedTime = jiffy.format(pattern: 'h:mm a');

            String jsonString = detail['ip'];
            Map<String, dynamic> jsonData = jsonDecode(jsonString);
            String ipAddress = jsonData['ip'];
            print(ipAddress);
            return   Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 120,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  formattedTime,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'IP: ${ipAddress ?? '-'}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  '${detail['location'] ?? '-'}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          if (detail['qrCodeUrl'] != null)
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  child: CachedNetworkImage(
                                    progressIndicatorBuilder:
                                        (context, url, progress) => Center(
                                      child: CircularProgressIndicator(
                                        value: progress.progress,
                                      ),
                                    ),
                                    imageUrl: detail['qrCodeUrl'],
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class YesterdayTab extends StatelessWidget {
  final User? user;

  YesterdayTab({required this.user});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginDetailsController());
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day - 1);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return StreamBuilder(
      stream: controller.firestore
          .collection('login_details')
          .where('userId', isEqualTo: user!.uid)
          .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
          .where('timestamp', isLessThan: endOfDay)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final loginDetails = snapshot.data!.docs;

        return loginDetails.isEmpty
            ? const Center(
                child: Text(
                  "No Active Data",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: loginDetails.length,
                itemBuilder: (context, index) {
                  var detail = loginDetails[index];
                  final jiffy = Jiffy.parseFromDateTime(detail['timestamp'].toDate());
                  final formattedTime = jiffy.format(pattern: 'h:mm a');
                  print(detail['ip']);
                  String jsonString = detail['ip'];
                  Map<String, dynamic> jsonData = jsonDecode(jsonString);
                  String ipAddress = jsonData['ip'];
                  print(ipAddress);

                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 120,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        formattedTime,
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        'IP: ${ipAddress ?? '-'}',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        '${detail['location'] ?? '-'}',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                if (detail['qrCodeUrl'] != null)
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        child: CachedNetworkImage(
                                          progressIndicatorBuilder:
                                              (context, url, progress) => Center(
                                            child: CircularProgressIndicator(
                                              value: progress.progress,
                                            ),
                                          ),
                                          imageUrl: detail['qrCodeUrl'],
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
      },
    );
  }
}
class OtherTab extends StatelessWidget {
  final User? user;

  OtherTab({required this.user});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginDetailsController());
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day - 2);

    return StreamBuilder(
      stream: controller.firestore
          .collection('login_details')
          .where('userId', isEqualTo: user!.uid)
          .where('timestamp', isLessThan: startOfDay)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final loginDetails = snapshot.data!.docs;

        return 
            loginDetails.isEmpty
            ? const Center(
                child: Text(
                  "No Active Data",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
          itemCount: loginDetails.length,
          itemBuilder: (context, index) {
            var detail = loginDetails[index];
            final jiffy = Jiffy.parseFromDateTime(detail['timestamp'].toDate());
            final formattedTime = jiffy.format(pattern: 'h:mm a');
            print(detail['ip']);
            String jsonString = detail['ip'];
            Map<String, dynamic> jsonData = jsonDecode(jsonString);
            String ipAddress = jsonData['ip'];
            print(ipAddress);

            return  Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 120,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  formattedTime,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'IP: ${ipAddress ?? '-'}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  '${detail['location'] ?? '-'}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          if (detail['qrCodeUrl'] != null)
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: CachedNetworkImage(
                                    progressIndicatorBuilder:
                                        (context, url, progress) => Center(
                                      child: CircularProgressIndicator(
                                        value: progress.progress,
                                      ),
                                    ),
                                    imageUrl: detail['qrCodeUrl'],
                                  ),
                                 
                                ),
                              ),
                            )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
