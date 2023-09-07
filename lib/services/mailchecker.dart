import 'package:flutter/foundation.dart';

bool validateEmail(String email) {
  // Regular expression for basic email format validation
  final RegExp emailRegExp =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

  return emailRegExp.hasMatch(email);
}

bool validatephone(String phone) {
  if (kDebugMode) {
    print(phone.length);
  }
  // Regular expression for basic email format validation
  if (phone.length == 11) {
    return true;
  } else {
    return false;
  }
}
