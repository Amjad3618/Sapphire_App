import 'package:get/get_rx/src/rx_types/rx_types.dart';

class UserModel {
  final RxString _name = ''.obs;
  final RxString _email = ''.obs;
  final RxString _userId = ''.obs;

  // Getters
  String get name => _name.value;
  String get email => _email.value;
  String get userId => _userId.value;

  // Setters
  set name(String value) => _name.value = value;
  set email(String value) => _email.value = value;
  set userId(String value) => _userId.value = value;

  UserModel({
    required String name,
    required String email,
    required String userId,
  }) {
    _name.value = name;
    _email.value = email;
    _userId.value = userId;
  }

  // From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'userId': userId,
      'email': email,
      'name': name,
    };
    return data;
  }
}