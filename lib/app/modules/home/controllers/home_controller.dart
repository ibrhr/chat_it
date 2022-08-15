import 'package:get/get.dart';

enum SelectedView {
  all,
  read,
  unread,
}

class HomeController extends GetxController {
  Rx<SelectedView> selectedView = SelectedView.all.obs;
}
