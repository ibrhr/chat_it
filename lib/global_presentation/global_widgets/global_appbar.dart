import 'package:chat_it/constants/exports.dart';

AppBar globalAppBar({String? title, List<Widget>? actions, Widget? leading}) {
  return AppBar(
    centerTitle: true,
    backgroundColor: ColorManager.white,
    elevation: 0,
    toolbarHeight: 90.h,
    title: title != null
        ? PrimaryText(
            title,
            fontSize: 21,
            color: ColorManager.primary,
            fontWeight: FontWeightManager.medium,
          )
        :  SizedBox(),
    leading: leading ??
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            height: 60.h,
            width: 60.w,
            decoration: BoxDecoration(
                color: ColorManager.grey6, shape: BoxShape.circle),
            child: Icon(Icons.arrow_back_rounded, color: (ColorManager.white)),
          ),
        ),
    actions: actions ?? [],
  );
}
