import '../../constants/exports.dart';

class DefaultScreen extends StatelessWidget {
   DefaultScreen({
    Key? key,
    required this.top,
    required this.bottom,
    this.floatingActionButton,
  }) : super(key: key);
  final Widget top;
  final Widget bottom;
  final FloatingActionButton? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: Get.mediaQuery.padding.top),
              padding:  EdgeInsets.all(12),
              height: 60.h,
              child: top,
            ),
            Expanded(
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: ColorManager.scaffoldColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32.w),
                  ),
                ),
                child: ClipRRect(
                    borderRadius:  BorderRadius.only(
                      topLeft: Radius.circular(48),
                      topRight: Radius.circular(48),
                    ),
                    child: bottom),
              ),
            ),
          ],
        ),
        floatingActionButton: floatingActionButton);
  }
}
