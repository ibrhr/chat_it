// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import '../../../../constants/exports.dart';
import '../../auth/controllers/auth_controller.dart';

enum SelectedView {
  all,
  read,
  unread,
}

class HomeController extends GetxController {
  SelectedView selectedView = SelectedView.all;
  types.User user = Get.find<AuthController>().user!;

  void updateView(SelectedView newView) {
    selectedView = newView;
    update();
  }

  Future<void> markAsRead(types.Room room) async {
    room.metadata![user.id]['unread'] = 0;
    FirebaseChatCore.instance.updateRoom(room);
  }
}
