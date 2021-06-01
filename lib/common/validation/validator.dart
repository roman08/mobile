// ignore: avoid_classes_with_only_static_members
class RegExValidator {
  static RegExp _emailRegEx = RegExp(
      r'(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  /// Phone Number regex
  /// Must started by either, "0", "+", "+XX <X between 2 to 4 digit>", "(+XX <X between 2 to 3 digit>)"
  /// Can add whitespace separating digit with "+" or "(+XX)"
  /// Example: 05555555555, +555 5555555555, (+123) 5555555555, (555) 5555555555, +5555 5555555555
  static RegExp _phoneRegEx = RegExp(
      r'^(0|\+|(\+[0-9]{2,4}|\(\+?[0-9]{2,4}\)) ?)([0-9]*|\d{2,4}-\d{2,4}(-\d{2,4})?)$');

  static RegExp _passwordRegEx = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~+]).{8,}$',
  );

  static bool isEmail(String s) => _emailRegEx.hasMatch(s);

  static bool isPhoneNumber(String s) => _phoneRegEx.hasMatch(s);

  static bool isValidPassword(String password) =>
      _passwordRegEx.hasMatch(password);
}
