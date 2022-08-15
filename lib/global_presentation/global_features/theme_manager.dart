import '../../constants/exports.dart';

class MyThemes {
  static final light = ThemeData.light().copyWith(
    scaffoldBackgroundColor: ColorManager.backgroundColor,
    primaryColor: ColorManager.scaffoldColor,
    backgroundColor: ColorManager.backgroundColor,
    iconTheme: IconThemeData(color: ColorManager.white, size: 18.h),
  );
  static final dark = ThemeData.dark().copyWith(
    // main colors of the app
    primaryColor: ColorManager.primary,
    primaryColorLight: ColorManager.primaryOpacity70,
    disabledColor: ColorManager.grey,
    //   brightness: Brightness.dark,
    backgroundColor: ColorManager.scaffoldDarkColor,
    scaffoldBackgroundColor: ColorManager.scaffoldDarkColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    hintColor: ColorManager.grey6,

    // Text Theme
    textTheme: TextTheme(bodyLarge: TextStyle(color: ColorManager.grey7)),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) => ColorManager.scaffoldDarkColor))),

    //Icon Theme
    iconTheme: IconThemeData(color: ColorManager.white, size: 22.h),

    // App bar theme
    appBarTheme: AppBarTheme(
      color: ColorManager.scaffoldDarkColor,
      iconTheme: IconThemeData(color: ColorManager.white),
      elevation: 0,
      centerTitle: true,
    ),
  );
}
