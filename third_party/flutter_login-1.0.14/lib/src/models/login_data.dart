import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

class LoginData {
  final String email;
  final String username;
  final String password;

  LoginData({
    @required this.email,
    this.username = '未命名',
    @required this.password,
  });

  @override
  String toString() {
    return '$runtimeType($email, $username, $password)';
  }

  bool operator ==(Object other) {
    if (other is LoginData) {
      return email == other.email && password == other.password;
    }
    return false;
  }

  int get hashCode => hash2(email, password);
}
