// ignore_for_file: depend_on_referenced_packages
import 'package:chat_it/app/modules/home/controllers/home_controller.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

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
    return GestureDetector(
      onTap: () async {
        await controller.markAsRead(room);
        Get.toNamed(Routes.CHAT, arguments: room);
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
    );
  }
}
