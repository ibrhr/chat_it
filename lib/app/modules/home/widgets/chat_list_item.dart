// ignore_for_file: depend_on_referenced_packages
import 'package:chat_it/app/modules/home/controllers/home_controller.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import '../../../../constants/exports.dart';
import '../../../routes/app_pages.dart';

class ChatListItem extends GetView<HomeController> {
  const ChatListItem({
    Key? key,
    required this.room,
    required this.user,
  }) : super(key: key);
  final types.Room room;
  final types.User user;

  @override
  Widget build(BuildContext context) {
    final otherUser =
        room.users[0].id == user.id ? room.users[1] : room.users[0];
    return Material(
      color: Colors.white,
      child: InkWell(
        onLongPress: () => Get.dialog(AlertDialog(
          content: PrimaryText(
            '${LocaleKeys.delete_chat.tr} ${otherUser.firstName} ?',
            fontSize: 16,
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            ElevatedButton(
              onPressed: () {
                FirebaseChatCore.instance.deleteRoom(room.id);
                Get.back();
              },
              child:  PrimaryText(
                 LocaleKeys.yes.tr,
                fontSize: 14,
              ),
            ),
            ElevatedButton(
              onPressed: () => Get.back(),
              child:  PrimaryText(
                 LocaleKeys.no.tr,
                fontSize: 14,
              ),
            ),
          ],
        )),
        onTap: () async {
          Get.toNamed(Routes.CHAT, arguments: room);
          await controller.markAsRead(room);
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 32,
                foregroundImage: NetworkImage(
                  otherUser.imageUrl!,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      '${otherUser.firstName!} ${otherUser.lastName!}',
                      fontSize: 16,
                    ),
                    PrimaryText(
                      room.metadata!['lastMessage'],
                      overflow: TextOverflow.ellipsis,
                      fontSize: 11,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              room.metadata![user.id]['unread'] != 0
                  ? CircleAvatar(
                      backgroundColor: ColorManager.backgroundColor,
                      radius: 16,
                      child: PrimaryText(
                        room.metadata![user.id]['unread'].toString(),
                        color: Colors.white,
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
