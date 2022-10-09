import 'package:flutter/material.dart';
import '../../../helpers/user_email.dart';

enum Gender { lakiLaki, perempuan }

class RegUserProvider with ChangeNotifier {
  String _gender = 'Laki-Laki';
  final List<String> _classSlta = ["10", "11", "12"];
  String _selectedClass = "10";

  String get gender {
    return _gender;
  }

  String get selectedClass {
    return _selectedClass;
  }

  List<String> get classSlta {
    return _classSlta;
  }

  setClass(selClass) {
    _selectedClass = selClass;
    notifyListeners();
  }

  onTapGender(Gender genderInput) {
    if (genderInput == Gender.lakiLaki) {
      _gender = "Laki-laki";
    } else {
      _gender = "Perempuan";
    }
    notifyListeners();
  }

  String get userEmail {
    return UserEmail.getUserEmail()!;
  }

  String get userDisplayName {
    return UserEmail.getUserDisplayName()!;
  }

  String get userPhotoUrl {
    return UserEmail.getUserPhotoUrl()!;
  }
}
