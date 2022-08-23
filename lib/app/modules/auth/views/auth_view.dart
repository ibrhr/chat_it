import 'package:chat_it/app/routes/app_pages.dart';
import 'package:chat_it/constants/exports.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PrimaryText(
              'Chat It',
              fontSize: 24,
              color: Colors.white,
            ),
            SizedBox(
              height: 100.h,
            ),
            SignInButton(
              Buttons.Google,
              padding: const EdgeInsets.symmetric(vertical: 8),
              onPressed: () async {
                await controller.signInWithGoogle();
                if (controller.user != null) {
                  Get.offAndToNamed(Routes.HOME);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
