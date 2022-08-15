import 'package:chat_it/app/routes/app_pages.dart';
import 'package:chat_it/constants/exports.dart';
import '../controllers/home_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      top: Center(
        child: Row(
          children: [
            const PrimaryText(
              'Chat It',
              fontSize: 20,
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search_outlined),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                customButton: const Icon(
                  Icons.more_vert_outlined,
                ),
                customItemsIndexes: const [3],
                customItemsHeight: 8,
                items: const [
                  DropdownMenuItem<String>(
                    value: 'Profile',
                    child: PrimaryText(
                      'Profile',
                      color: Colors.black,
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Logout',
                    child: PrimaryText(
                      'Logout',
                      color: Colors.black,
                    ),
                  ),
                ],
                onChanged: (String? value) {
                  value! == 'Profile' ? Get.toNamed(Routes.EDIT_PROFILE) : null;
                },
                itemHeight: 48,
                itemPadding: const EdgeInsets.only(left: 16, right: 16),
                dropdownWidth: 160,
                dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                dropdownElevation: 8,
                offset: const Offset(0, 8),
              ),
            ),
          ],
        ),
      ),
      bottom: Column(
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
              children: const [
                MenuItem(
                  selectedView: SelectedView.all,
                  text: 'All',
                ),
                MenuItem(
                  selectedView: SelectedView.read,
                  text: 'Read',
                ),
                MenuItem(
                  selectedView: SelectedView.unread,
                  text: 'Unread',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, i) => const ChatListItem()),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {}, child: const Icon(Icons.messenger_outline)),
    );
  }
}

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({
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
              padding: const EdgeInsets.all(12),
              height: 80.h,
              child: top,
            ),
            Expanded(
              child: Container(
                width: Get.width,
                padding: EdgeInsets.only(top: 16.h),
                decoration: BoxDecoration(
                  color: ColorManager.scaffoldColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32.w),
                  ),
                ),
                child: bottom,
              ),
            ),
          ],
        ),
        floatingActionButton: floatingActionButton);
  }
}

class ChatListItem extends StatelessWidget {
  const ChatListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 32,
            foregroundImage: NetworkImage(
              'https://thumbs.dreamstime.com/z/closeup-photo-funny-excited-lady-raise-fists-screaming-loudly-celebrating-money-lottery-winning-wealthy-rich-person-wear-casual-172563278.jpg',
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                PrimaryText(
                  'Maya Hawke',
                  color: Colors.black,
                  fontSize: 14,
                ),
                PrimaryText(
                  'Heeeeyyyy I missed you so much lately, how are you doing ?',
                  color: Colors.black54,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 11,
                  maxLines: 1,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
    required this.selectedView,
    required this.text,
  }) : super(key: key);

  final SelectedView selectedView;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) {
        return Flexible(
          child: InkWell(
            onTap: () => controller.selectedView.value = selectedView,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(48.h),
                ),
                color: controller.selectedView.value == selectedView
                    ? ColorManager.backgroundColor
                    : ColorManager.secondaryColor,
              ),
              constraints: const BoxConstraints.expand(),
              child: Center(
                child: PrimaryText(
                  text,
                  color: controller.selectedView.value == selectedView
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
