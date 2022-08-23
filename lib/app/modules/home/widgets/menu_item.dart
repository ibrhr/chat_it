import '../../../../constants/exports.dart';
import '../controllers/home_controller.dart';

class MyMenuItem extends StatelessWidget {
  const MyMenuItem({
    Key? key,
    required this.selectedView,
    required this.text,
  }) : super(key: key);

  final SelectedView selectedView;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Flexible(
          child: InkWell(
            onTap: () => controller.updateView(selectedView),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(48.h),
                ),
                color: controller.selectedView == selectedView
                    ? ColorManager.backgroundColor
                    : ColorManager.secondaryColor,
              ),
              constraints: const BoxConstraints.expand(),
              child: Center(
                child: PrimaryText(
                  text,
                  color: controller.selectedView == selectedView
                      ? Colors.white
                      : Colors.grey,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
