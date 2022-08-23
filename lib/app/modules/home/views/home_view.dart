import 'package:chat_it/app/routes/app_pages.dart';
import 'package:chat_it/constants/exports.dart';
// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/home_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../widgets/chat_list_item.dart';
import '../widgets/menu_item.dart';

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
              color: Colors.white,
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
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Logout',
                    child: PrimaryText(
                      'Logout',
                    ),
                  ),
                ],
                onChanged: (String? value) {
                  value! == 'Profile'
                      ? Get.toNamed(Routes.EDIT_PROFILE)
                      : Get.find<AuthController>().signOut();
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
                children: const [
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
            const SizedBox(height: 16),
            Expanded(
              child: GetBuilder<HomeController>(builder: (controller) {
                return StreamBuilder<List<types.Room>>(
                  stream: FirebaseChatCore.instance.rooms(),
                  initialData: const [],
                  builder: (BuildContext context,
                      AsyncSnapshot<List<types.Room>> snapshot) {
                    if (snapshot.data == null) {
                      return const Center(
                        child: PrimaryText('NO CHATS'),
                      );
                    } else {
                      if (controller.selectedView == SelectedView.read) {
                        return ListView.builder(
                          padding: const EdgeInsets.all(0),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, i) {
                            final room = snapshot.data![i];
                            return room.metadata![controller.user.id]
                                        ['unread'] ==
                                    0
                                ? ChatListItem(
                                    room: room,
                                    user: controller.user,
                                  )
                                : Container();
                          },
                        );
                      } else if (controller.selectedView ==
                          SelectedView.unread) {
                        return ListView.builder(
                          padding: const EdgeInsets.all(0),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, i) {
                            final room = snapshot.data![i];
                            return room.metadata![controller.user.id]
                                        ['unread'] !=
                                    0
                                ? ChatListItem(
                                    room: room,
                                    user: controller.user,
                                  )
                                : Container();
                          },
                        );
                      } else {
                        return ListView.builder(
                          padding: const EdgeInsets.all(0),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, i) {
                            final room = snapshot.data![i];
                            return ChatListItem(
                              room: room,
                              user: controller.user,
                            );
                          },
                        );
                      }
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(Routes.USERS);
          },
          child: const Icon(Icons.messenger_outline)),
    );
  }
}
