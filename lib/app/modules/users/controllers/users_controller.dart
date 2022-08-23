import 'package:chat_it/app/routes/app_pages.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../../../constants/exports.dart';

class UsersController extends GetxController {
  final users = FirebaseChatCore.instance.users();

  void createChat(types.User otherUser) async {
    final room = await FirebaseChatCore.instance.createRoom(otherUser);
    FirebaseChatCore.instance
        .getFirebaseFirestore()
        .collection('rooms')
        .doc(room.id)
        .update({
      'metadata': {
        'lastMessage': ' ',
        room.users[0].id: {'unread': 0},
        room.users[1].id: {'unread': 0}
      }
    });
    Get.toNamed(Routes.CHAT, arguments: room);
  }
}
