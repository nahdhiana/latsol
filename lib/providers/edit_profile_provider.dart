import 'package:flutter/material.dart';
import '../../../helpers/user_email.dart';
import '../../helpers/preference_helper.dart';
import '../../models/user_by_email.dart';

enum Gender { lakiLaki, perempuan }

class EditProfileProvider with ChangeNotifier {
  String _gender = 'Laki-Laki';
  final List<String> _classSlta = ["10", "11", "12"];
  String _selectedClass = "10";
  UserData? _user;

  EditProfileProvider() {
    initDataUser();
  }

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

  initDataUser() async {
    final data = await PreferenceHelper().getUserData();
    _user = data;
    notifyListeners();
  }

  String get userEmail {
    return UserEmail.getUserEmail()!;
  }

  String get fullname {
    return _user!.userName!;
  }

  String get school {
    return _user!.userAsalSekolah!;
  }

  String get userGender {
    return _user!.userGender!;
  }

  String get userPhotoUrl {
    return UserEmail.getUserPhotoUrl()!;
  }
}
