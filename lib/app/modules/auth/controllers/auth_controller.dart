import 'package:chat_it/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import 'package:get/get.dart';

class AuthController extends GetxController {
  types.User? user;

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCredential.additionalUserInfo!.isNewUser) {
      user = types.User(
          firstName: userCredential.user!.displayName!.split(' ').first,
          id: userCredential.user!.uid, 
          imageUrl: userCredential.user!.photoURL,
          lastName: userCredential.user!.displayName!
              .split(' ')
              .getRange(1, userCredential.user!.displayName!.split(' ').length)
              .join(''),
          metadata: {
            'email': userCredential.user!.email,
            'about': 'Hi I am using chat it!'
          });
      await FirebaseChatCore.instance.createUserInFirestore(
        user!,
      );
    } else {
      await getUser();
    }

  }

  Future<void> getUser() async {
    final userData = await FirebaseChatCore.instance
        .getFirebaseFirestore()
        .collection('users')
        .doc(FirebaseChatCore.instance.firebaseUser!.uid)
        .get();

    user = types.User(
      firstName: userData['firstName'],
      id: userData.id,
      imageUrl: userData['imageUrl'],
      lastName: userData['lastName'],
      metadata: userData['metadata'],
    );
  }

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.AUTH);
    Get.deleteAll(force: true);
  }
}
