import 'package:chat_it/app/modules/sign_in/bindings/sign_in_binding.dart';
import 'package:chat_it/global_presentation/global_features/theme_manager.dart';
import 'constants/exports.dart';
import 'app/routes/app_pages.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: ScreenUtil.defaultSize,
        builder: (BuildContext context, Widget? child) {
          return GetMaterialApp(
            title: 'Chat It',
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            initialBinding: SignInBinding(),
            debugShowCheckedModeBanner: false,
            theme: MyThemes.light,
            translationsKeys: AppTranslation.translations,
          );
        });
  }
}
