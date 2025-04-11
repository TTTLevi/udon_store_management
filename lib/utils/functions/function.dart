import 'package:intl/intl.dart';

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Vui lòng nhập địa chỉ email';
  }

  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  RegExp regExp = RegExp(pattern);

  if (!regExp.hasMatch(value)) {
    return 'Địa chỉ email không hợp lệ';
  }

  return null;
}

// String? validatePassword(String? value) {
//   if (value == null || value.isEmpty) {
//     return 'Vui lòng nhập mật khẩu';
//   }

//   String pattern =
//       r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]).{8,}$';
//   RegExp regExp = RegExp(pattern);

//   if (!regExp.hasMatch(value)) {
//     return 'Mật khẩu phải chứa ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt';
//   }

//   return null;
// }

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Vui lòng nhập mật khẩu';
  }

  if (value!.length < 8) {
    return 'Mật khẩu phải có ít nhất 8 ký tự';
  }

  final RegExp hasUpperCase = RegExp(r'[A-Z]');
  final RegExp hasLowerCase = RegExp(r'[a-z]');
  final RegExp hasDigit = RegExp(r'\d');
  final RegExp hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  if (!hasUpperCase.hasMatch(value)) {
    return 'Mật khẩu phải có ít nhất 1 ký tự viết hoa';
  }
  if (!hasLowerCase.hasMatch(value)) {
    return 'Mật khẩu phải có ít nhất 1 ký tự viết thường';
  }
  if (!hasDigit.hasMatch(value)) {
    return 'Mật khẩu phải có ít nhất 1 số';
  }
  if (!hasSpecialChar.hasMatch(value)) {
    return 'Mật khẩu phải có ít nhất 1 ký tự đặc biệt';
  }

  return null;
}

String currencyFormat(double value) {
  final NumberFormat formatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
    decimalDigits: 0,
  );
  return formatter.format(value);
}

String extractLastName(String fullName) {
  if (fullName.trim().isEmpty) return '';
  List<String> parts = fullName.trim().split(' ');
  return parts.last;
}

String _twoDigits(int n) => n.toString().padLeft(2, '0');

String formatDateTime(String rawDateTime) {
  DateTime dateTime = DateTime.parse(rawDateTime);
  String formattedDate =
      "${_twoDigits(dateTime.day)}/${_twoDigits(dateTime.month)}/${dateTime.year}";
  String formattedTime =
      "${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}";
  return "$formattedDate - $formattedTime";
}
