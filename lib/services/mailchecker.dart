bool validateEmail(String email) {
  // Regular expression for basic email format validation
  final RegExp emailRegExp =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

  return emailRegExp.hasMatch(email);
}
