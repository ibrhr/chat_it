import 'package:chat_it/app/routes/app_pages.dart';
import 'package:chat_it/constants/exports.dart';
import 'package:lottie/lottie.dart';

import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              Image.asset('assets/icons/logo.png'),
              ElevatedButton.icon(
                icon: SizedBox(
                  height: 25.h,
                  width: 25.w,
                  child: Image.asset(
                    'assets/icons/google.png',
                    fit: BoxFit.scaleDown,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.all(14),
                    primary: Colors.purple.shade400),
                label:  PrimaryText(
                  LocaleKeys.sign_in_button.tr,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16,
                ),
                //   padding: const EdgeInsets.symmetric(vertical: 8),
                onPressed: () async {
                  await controller.signInWithGoogle();
                  if (controller.user != null) {
                    Get.offAndToNamed(Routes.HOME);
                  }
                },
              ),
              const Spacer(),
              SizedBox(
                height: Get.height / 3,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Lottie.asset(
                    'assets/lottie/chatting.json',
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
