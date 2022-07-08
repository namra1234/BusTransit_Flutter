import 'package:email_validator/email_validator.dart';

class Validation {

  static bool validateEmail(String email) {
    return EmailValidator.validate(email);
  }

  static bool validatePassword(String password) {
    // password should contain Capital character,Small character, number, special character and less than 15 and greater than 8 
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,15}$';
        RegExp regExp = new RegExp(pattern);
        return regExp.hasMatch(password);
  }

  static bool validateMobile(String mobileNo) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    // String pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    RegExp regExp = new RegExp(pattern);
    // if (value.length == 0) {
    //   return 'Please enter mobile number';
    // } else if (!regExp.hasMatch(value)) {
    //   return 'Please enter valid mobile number';
    // }
    return regExp.hasMatch(mobileNo);
  }
}
