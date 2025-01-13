import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/useer_model.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Rx<UserModel?> _user = Rx<UserModel?>(null);

  UserModel? get user => _user.value;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user.value = null;
    } else {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      _user.value = UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    User? firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      UserModel newUser = UserModel(
        name: name,
        email: email,
        userId: firebaseUser.uid,
      );
      await _firestore.collection('users').doc(firebaseUser.uid).set(newUser.toJson());
      _user.value = newUser;
    }
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user.value = null;
  }
}