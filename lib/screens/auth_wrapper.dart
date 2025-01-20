import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Services/auth_services.dart';
import '../screens/login_screen.dart';
import '../bottom_bar/bottom_bar.dart';

class AuthWrapper extends StatelessWidget {
  AuthWrapper({Key? key}) : super(key: key);

  // Initialize AuthService here instead of using Get.find
  final AuthService _authService = Get.put(AuthService(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _authService.currentUser.value != null 
          ? const BottomBar() 
          : const LoginScreen();
    });
  }
}