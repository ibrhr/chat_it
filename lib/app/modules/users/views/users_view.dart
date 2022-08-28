import 'package:chat_it/app/routes/app_pages.dart';
import 'package:chat_it/constants/exports.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../controllers/users_controller.dart';

class UsersView extends GetView<UsersController> {
  const UsersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      top: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 8),
          const PrimaryText(
            'Select User',
            fontSize: 20,
            color: Colors.white,
          ),
        ],
      ),
      bottom: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.white,
            child: InkWell(
              onTap: () => Get.toNamed(Routes.ADD_FRIEND),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: ColorManager.backgroundColor,
                  radius: 24.w,
                  child: Icon(
                    Icons.person_add,
                    color: Colors.white,
                    size: 24.w,
                  ),
                ),
                title: const PrimaryText(
                  'Add Friend',
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: PrimaryText('Friends on Chat It'),
          ),
          Expanded(
            child: StreamBuilder<List<types.User>>(
              stream: controller.users,
              initialData: const [],
              builder: (context, snapshot) {
                final Map<String, dynamic> friends =
                    controller.user.metadata!['friends'];
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) =>
                      friends.containsKey(snapshot.data![i].id)
                          ? UserChat(
                              user: snapshot.data![i],
                            )
                          : Container(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UserChat extends GetView<UsersController> {
  const UserChat({
    required this.user,
    this.isAddFriend = false,
    Key? key,
  }) : super(key: key);
  final types.User user;
  final bool isAddFriend;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () async => isAddFriend
            ? await controller.addFriend(user)
            : await controller.createChat(user),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 32,
                foregroundImage: NetworkImage(
                  user.imageUrl!,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      '${user.firstName!} ${user.lastName!}',
                      fontSize: 16,
                    ),
                    PrimaryText(
                      user.metadata!['about'],
                      overflow: TextOverflow.ellipsis,
                      fontSize: 11,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
