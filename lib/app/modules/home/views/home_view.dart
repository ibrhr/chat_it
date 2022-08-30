import 'package:chat_it/app/routes/app_pages.dart';
import 'package:chat_it/constants/exports.dart';
import '../controllers/home_controller.dart';
import '../widgets/chats_list.dart';
import '../widgets/menu_item.dart';
import '../widgets/my_drop_down_button.dart';

class HomeView extends GetView<HomeController> {
   HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      top: Center(
        child: Row(
          children:  [
            PrimaryText(
              'Chat It',
              fontSize: 20,
              color: Colors.white,
            ),
            Spacer(),
            MyDropDownButton(),
          ],
        ),
      ),
      bottom: Padding(
        padding: EdgeInsets.only(top: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 40.h,
              width: Get.width - 100.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(48.h),
                ),
                color: ColorManager.secondaryColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  MyMenuItem(
                    selectedView: SelectedView.all,
                    text: 'All',
                  ),
                  MyMenuItem(
                    selectedView: SelectedView.read,
                    text: 'Read',
                  ),
                  MyMenuItem(
                    selectedView: SelectedView.unread,
                    text: 'Unread',
                  ),
                ],
              ),
            ),
             SizedBox(height: 16),
             Expanded(
              child: ChatsPageView(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.USERS);
        },
        child:  Icon(Icons.messenger_outline),
      ),
    );
  }
}

class ChatsPageView extends GetView<HomeController> {
   ChatsPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller.pageController,
      scrollDirection: Axis.horizontal,
      onPageChanged: (value) {
        if (!controller.isPageViewAnimating) {
          if (value == 0) {
            controller.updateView(SelectedView.all);
          } else if (value == 1) {
            controller.updateView(SelectedView.read);
          } else if (value == 2) {
            controller.updateView(SelectedView.unread);
          }
        }
      },
      children:  [
        ChatsList(page: SelectedView.all),
        ChatsList(page: SelectedView.read),
        ChatsList(page: SelectedView.unread),
      ],
    );
  }
}
