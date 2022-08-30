import 'package:chat_it/app/modules/users/views/users_view.dart';
import 'package:chat_it/constants/exports.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import '../controllers/users_controller.dart';

class AddFriendView extends GetView<UsersController> {
   AddFriendView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      top: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon:  Icon(Icons.arrow_back),
          ),
           SizedBox(width: 8),
           PrimaryText(
            'Add Friend',
            fontSize: 20,
            color: Colors.white,
          ),
        ],
      ),
      bottom: GetBuilder<UsersController>(
        builder: (controller) => StreamBuilder<List<types.User>>(
          stream: FirebaseChatCore.instance.users(),
          initialData:  [],
          builder: (context, snapshot) {
            final Map<String, dynamic> friends =
                controller.user.metadata!['friends'];
            return ListView.builder(
              padding:  EdgeInsets.only(top: 16),
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, i) =>
                  friends.containsKey(snapshot.data![i].id)
                      ? Container()
                      : UserChat(
                          user: snapshot.data![i],
                          isAddFriend: true,
                        ),
            );
          },
        ),
      ),
    );
  }
}
