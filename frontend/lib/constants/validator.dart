// Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";
const String kDateOfBirthNullError = "Please Enter your date of birth";
const String kTitleNullError = "Please Enter your title of task";
const String kNoteNullError = "Please Enter your note of task";

// Validators
String? emailValidator(String? value) {
  if (value!.isEmpty) {
    return kEmailNullError;
  } else if (!emailValidatorRegExp.hasMatch(value)) {
    return kInvalidEmailError;
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value!.isEmpty) {
    // addError(error: kPassNullError);
    return kPassNullError;
  } else if (value.length < 8) {
    // addError(error: kShortPassError);
    return kShortPassError;
  }
  return null;
}

String? confirmationPasswordValidator(String? value, String? password) {
  if (value!.isEmpty) {
    return kPassNullError;
  } else if (password != value) {
    // addError(error: kMatchPassError);
    return kMatchPassError;
  }
  return null;
}

String? dobValidator(String? value) {
  if (value!.isEmpty) {
    // addError(error: kDateOfBirthNullError);
    return kDateOfBirthNullError;
  }
  return null;
}

String? addressValidator(String? value) {
  if (value!.isEmpty) {
    // addError(error: kAddressNullError);
    return kAddressNullError;
  }
  return null;
}

String? phoneNumberValidator(String? value) {
  if (value!.isEmpty) {
    // addError(error: kPhoneNumberNullError);
    return kPhoneNumberNullError;
  }
  return null;
}

String? nameValidator(String? value) {
  if (value!.isEmpty) {
    // addError(error: kNamelNullError);
    return kNamelNullError;
  }
  return null;
}
