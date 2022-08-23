import 'package:chat_it/app/modules/auth/controllers/auth_controller.dart';
import 'package:chat_it/app/routes/app_pages.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../../../constants/exports.dart';

class UsersController extends GetxController {
  final users = FirebaseChatCore.instance.users();

  Future<void> createChat(types.User otherUser) async {
    final room =
        await FirebaseChatCore.instance.createRoom(otherUser, metadata: {
      'lastMessage': ' ',
      otherUser.id: {'unread': 0},
      Get.find<AuthController>().user!.id: {'unread': 0}
    });

    Get.toNamed(Routes.CHAT, arguments: room);
  }
}
