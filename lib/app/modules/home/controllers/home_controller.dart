
// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
class HomeController extends GetxController {
 
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  RxBool isLoading=false.obs;
  User? user;
  int randomNumber = Random().nextInt(1000000);
  String qrCodeData = '';
  String? userLocation;
  String?city;
  String? userIP;
   final localstorage = GetStorage();



Future<void> getLocationPermissionAndCurrentLocation() async {
  final permission = await Permission.location.request();
  if (permission.isGranted) {
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final latitude = position.latitude;
    final longitude = position.longitude;
    print('Current location: $latitude, $longitude');

    final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
     city = placemarks[0].locality;
     localstorage.write('city',city);
    print('City: $city');
  } else {
    print('Location permission denied');
  }
}

  Future<void> getUserIP() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.ipify.org?format=json'));
      if (response.statusCode == 200) {
       
          userIP = response.body;
        
      } else {
        throw Exception('Failed to get IP address');
      }
    } catch (e) {
      print('Error getting IP address: $e');
      
        userIP = 'Error fetching IP';
  
    }
  }



Future<void> saveData() async {
  isLoading.value=true;
  try {
    // Check if qrCodeData is not null or empty
    if (qrCodeData == null || qrCodeData.isEmpty) {
      throw Exception('QR code data is null or empty');
    }

    print('QR code data is valid');

    // Generate QR code image as bytes
    final qrBytes = await toQrImageData(qrCodeData);

    if (qrBytes == null) {
      throw Exception('Failed to generate QR code image');
    }
    print('QR code image generated successfully');
    String fileName = '$randomNumber.png';
    Reference ref = FirebaseStorage.instance.ref().child(fileName);

    print('Firebase Storage reference created');

    // Upload the QR code image to Firebase Storage
    TaskSnapshot uploadTask = await ref.putData(qrBytes);
    String downloadUrl = await uploadTask.ref.getDownloadURL();

    print('QR code image uploaded to Firebase Storage with download URL: $downloadUrl');

    // Save the login details to Firestore
    if (user != null) {
      var local= localstorage.read('city');
      await FirebaseFirestore.instance.collection('login_details').add({
        'userId': user!.uid,
        'randomNumber': randomNumber,
        'qrCodeUrl': downloadUrl,
        'location': city ?? local,
        'ip': userIP ?? '',
        'timestamp': Timestamp.now(),
      });
    } else {
      throw Exception('User is null');
    }
      isLoading.value=false;
    Fluttertoast.showToast(
        msg: "Data saved successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0
    );
    print('Data saved to Firestore successfully');

  } catch (e) {
    print('Error saving data: $e');
  }
}

Future<Uint8List> toQrImageData(String text) async {
  try {
    final image = await QrPainter(
      data: text,
      version: QrVersions.auto,
      gapless: false,
      color: const Color(0xff000000),
      emptyColor: const Color(0xffffffff),
    ).toImage(300);
    final a = await image.toByteData(format: ImageByteFormat.png);
    return a!.buffer.asUint8List();
  } catch (e) {
    rethrow;
  }
}

  @override
  void onInit() {
    super.onInit();
     user = auth.currentUser;
    qrCodeData = randomNumber.toString();
    getLocationPermissionAndCurrentLocation();
    getUserIP();
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
