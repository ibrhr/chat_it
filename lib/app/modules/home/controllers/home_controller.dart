// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

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

  late PageController pageController;
  bool isPageViewAnimating = false;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  Future<void> updateView(SelectedView newView) async {
    isPageViewAnimating = true;
    selectedView = newView;
    update();
    Future.delayed(const Duration(milliseconds: 200));
    if (newView == SelectedView.all) {
      await pageController.animateToPage(0,
          duration: const Duration(milliseconds: 200), curve: Curves.ease);
    } else if (newView == SelectedView.read) {
      await pageController.animateToPage(1,
          duration: const Duration(milliseconds: 200), curve: Curves.ease);
    } else if (newView == SelectedView.unread) {
      await pageController.animateToPage(2,
          duration: const Duration(milliseconds: 200), curve: Curves.ease);
    }
    isPageViewAnimating = false;
    update();
  }

  Future<void> markAsRead(types.Room room) async {
    room.metadata![user.id]['unread'] = 0;
    FirebaseChatCore.instance.updateRoom(room);
  }
}
