import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/r.dart';
import '../../../helpers/preference_helper.dart';
import '../../../models/network_response.dart';
import '../../../models/user_by_email.dart';
import '../../../providers/edit_profile_provider.dart';
import '../../../repository/auth_api.dart';
import '../../../view/login_page.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);
  static String route = "register_page";
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final emailController = TextEditingController();
  final schoolNameController = TextEditingController();
  final fullNameController = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final data = Provider.of<EditProfileProvider>(context, listen: false);
      emailController.text = data.userEmail;
      schoolNameController.text = data.school;
      fullNameController.text = data.fullname;
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    fullNameController.dispose();
    schoolNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xfff0f3f5),
      appBar: AppBar(
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //         bottomLeft: Radius.circular(25.0),
        //         bottomRight: Radius.circular(25.0))),
        elevation: 0,
        // backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Edit Akun",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: ButtonLogin(
            radius: 8,
            onTap: () async {
              final data =
                  Provider.of<EditProfileProvider>(context, listen: false);
              final json = {
                "email": emailController.text,
                "nama_lengkap": fullNameController.text,
                "nama_sekolah": schoolNameController.text,
                "kelas": data.selectedClass,
                "gender": data.gender,
                "foto": data.userPhotoUrl,
              };
              print(json);
              final result = await AuthApi().postUpdateUSer(json);
              if (result.status == Status.success) {
                final registerResult = UserByEmail.fromJson(result.data!);
                if (registerResult.status == 1) {
                  await PreferenceHelper().setUserData(registerResult.data!);
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(registerResult.message!),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Terjadi kesalahan, silahkan ulangi kembali"),
                  ),
                );
              }
            },
            backgroundColor: R.colors.primary,
            borderColor: R.colors.primary,
            child: Text(
              R.strings.perbaharuiAkun,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditProfileTextField(
                controller: emailController,
                hintText: 'Email Anda',
                title: "Email",
                enabled: false,
              ),
              EditProfileTextField(
                hintText: 'Nama Lengkap Anda',
                title: "Nama Lengkap",
                controller: fullNameController,
              ),
              const SizedBox(height: 5),
              Text(
                "Jenis Kelamin",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: R.colors.greySubtitle),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Consumer<EditProfileProvider>(
                        builder: (_, genderValue, __) => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: genderValue.gender.toLowerCase() ==
                                    "Laki-laki".toLowerCase()
                                ? R.colors.primary
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                  width: 1, color: R.colors.greyBorder),
                            ),
                          ),
                          onPressed: () {
                            genderValue.onTapGender(Gender.lakiLaki);
                          },
                          child: Text(
                            "Laki-laki",
                            style: TextStyle(
                              fontSize: 14,
                              color: genderValue.gender.toLowerCase() ==
                                      "Laki-laki".toLowerCase()
                                  ? Colors.white
                                  : const Color(0xff282828),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Consumer<EditProfileProvider>(
                        builder: (_, genderValue, __) => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: genderValue.gender == "Perempuan"
                                ? R.colors.primary
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                  width: 1, color: R.colors.greyBorder),
                            ),
                          ),
                          onPressed: () {
                            genderValue.onTapGender(Gender.perempuan);
                          },
                          child: Text(
                            "Perempuan",
                            style: TextStyle(
                              fontSize: 14,
                              color: genderValue.gender == "Perempuan"
                                  ? Colors.white
                                  : const Color(0xff282828),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                "Kelas",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: R.colors.greySubtitle),
              ),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: R.colors.greyBorder),
                ),
                child: Consumer<EditProfileProvider>(
                  builder: (_, classValue, __) => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        value: classValue.selectedClass,
                        items: classValue.classSlta
                            .map(
                              (e) => DropdownMenuItem<String>(
                                child: Text(e),
                                value: e,
                              ),
                            )
                            .toList(),
                        onChanged: (String? val) {
                          classValue.setClass(val);
                        }),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              EditProfileTextField(
                hintText: 'Nama Sekolah',
                title: "Nama Sekolah",
                controller: schoolNameController,
              ),
              // Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfileTextField extends StatelessWidget {
  const EditProfileTextField({
    Key? key,
    required this.title,
    required this.hintText,
    this.controller,
    this.enabled = true,
  }) : super(key: key);
  final String title;
  final String hintText;
  final bool enabled;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: R.colors.greySubtitle),
          ),
          const SizedBox(height: 5),
          TextField(
            enabled: enabled,
            controller: controller,
            decoration: InputDecoration(
                // border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: R.colors.greyHintText,
                )),
          ),
        ],
      ),
    );
  }
}
