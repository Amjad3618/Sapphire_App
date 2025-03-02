// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:genrator_11/screens/login_screen.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/useer_model.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Rx<User?> currentUser = Rx<User?>(null);
  
  @override
  void onInit() {
    currentUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

 Future<UserModel?> signUp({
  required String name,
  required String email,
  required String password,
}) async {
  try {
    // Create user with email and password
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      // Create user model
      UserModel newUser = UserModel(
        name: name,
        email: email,
        userId: userCredential.user!.uid,
      );

      // Debug log
      print('Creating user with name: $name');
      print('User model name value: ${newUser.name}');
      final jsonData = newUser.toJson();
      print('JSON data to be saved: $jsonData');

      // Save user data to Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(jsonData);

      return newUser;
    }
  } on FirebaseAuthException catch (e) {
    // Error handling code unchanged
  }
  return null;
}
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          return UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
        }
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided.';
          break;
        default:
          message = 'An error occurred. Please try again.';
      }
      Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.offAll(LoginScreen()); // Navigate to login screen
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign out. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}