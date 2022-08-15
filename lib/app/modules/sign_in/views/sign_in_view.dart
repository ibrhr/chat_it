import 'package:chat_it/app/routes/app_pages.dart';
import 'package:chat_it/constants/exports.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import '../controllers/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({Key? key}) : super(key: key);
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
            ),
            SizedBox(
              height: 100.h,
            ),
            SignInButton(
              Buttons.Google,
              padding: const EdgeInsets.symmetric(vertical: 8),
              onPressed: () => Get.offAndToNamed(Routes.HOME),
            ),
          ],
        ),
      ),
    );
  }
}
