import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:image_picker/image_picker.dart';

import '../../../../constants/exports.dart';
import '../../auth/controllers/auth_controller.dart';

class EditProfileController extends GetxController {
  final users =
      FirebaseChatCore.instance.getFirebaseFirestore().collection('users');
  final auth = Get.find<AuthController>();
  types.User? _user;
  String? uid;
  String? name;
  String? email;
  String? photoUrl;
  String? about;

  final _nameFormKey = GlobalKey<FormState>();
  final _aboutFormKey = GlobalKey<FormState>();


  Future<void> updateImage() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final file = File(result.path);
      final name = result.name;

      final reference = FirebaseStorage.instance.ref(name);
      await reference.putFile(file);
      final uri = await reference.getDownloadURL();

      await users.doc(uid).update({'imageUrl': uri});
      await _reloadUserData();
    }
  }

  void onNameTap() => Get.bottomSheet(
        Container(
          decoration:  BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding:  EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _nameFormKey,
                  child: TextFormField(
                    initialValue: name,
                    decoration:  InputDecoration(
                      labelText: LocaleKeys.enter_name.tr,
                    ),
                    onSaved: (newValue) async => await _updateName(newValue!),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _nameFormKey.currentState!.save();
                        Get.back();
                      },
                      child: PrimaryText(
                        LocaleKeys.save.tr,
                        color: ColorManager.iconColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: PrimaryText(
                       LocaleKeys.cancel.tr,
                        color: ColorManager.iconColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );

  void onAboutTap() => Get.bottomSheet(Container(
        decoration:  BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: _aboutFormKey,
                child: TextFormField(
                  initialValue: about,
                  maxLines: 3,
                  decoration:  InputDecoration(
                    labelText: LocaleKeys.enter_about.tr,
                  ),
                  onSaved: (newValue) async => await _updateAbout(newValue!),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _aboutFormKey.currentState!.save();
                      Get.back();
                    },
                    child: PrimaryText(
                      LocaleKeys.save.tr,
                      color: ColorManager.iconColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: PrimaryText(
                      LocaleKeys.cancel.tr,
                      color: ColorManager.iconColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ));

  Future<void> _updateName(String name) async {
    await users.doc(uid).update({
      'firstName': name.split(' ').first,
      'lastName': name.split(' ').getRange(1, name.split(' ').length).join(' ')
    });
    await _reloadUserData();
  }

  Future<void> _updateAbout(String about) async {
    await users.doc(uid).update({
      'metadata': {'email': email, 'about': about}
    });
    await _reloadUserData();
  }

  Future<void> _reloadUserData() async {
    await auth.getUser();
    name = '${auth.user!.firstName!} ${auth.user!.lastName!}';
    email = auth.user!.metadata!['email'];
    photoUrl = auth.user!.imageUrl;
    about = auth.user!.metadata!['about'];
    update();
  }

  void _initUserData() {
    _user = auth.user!;
    uid = _user!.id;
    name = '${_user!.firstName!} ${_user!.lastName!}';
    email = _user!.metadata!['email'];
    photoUrl = _user!.imageUrl;
    about = _user!.metadata!['about'];
  }

  @override
  void onInit() {
    _initUserData();
    super.onInit();
  }
}
