import 'package:chat_it/global_presentation/global_features/theme_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/modules/auth/bindings/auth_binding.dart';
import 'app/modules/auth/controllers/auth_controller.dart';
import 'app/routes/app_pages.dart';
import 'constants/exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put<AuthController>(AuthController(), permanent: true);
  if (FirebaseAuth.instance.currentUser != null) {
    await Get.find<AuthController>().getUser();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: ScreenUtil.defaultSize,
      splitScreenMode: false,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          title: 'Chat It',
          initialRoute: FirebaseAuth.instance.currentUser == null
              ? AppPages.INITIAL
              : Routes.HOME,
          locale: const Locale('en'),
          translationsKeys: AppTranslation.translations,
          getPages: AppPages.routes,
          initialBinding: AuthBinding(),
          debugShowCheckedModeBanner: false,
          theme: MyThemes.light,
        );
      },
    );
  }
}
