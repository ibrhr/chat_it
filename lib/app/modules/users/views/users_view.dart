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
            'Users',
            fontSize: 20,
            color: Colors.white,
          ),
        ],
      ),
      bottom: StreamBuilder<List<types.User>>(
        stream: controller.users,
        initialData: const [],
        builder: (context, snapshot) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) => UserChat(
              user: snapshot.data![i],
            ),
          );
        },
      ),
    );
  }
}

class UserChat extends GetView<UsersController> {
  const UserChat({
    required this.user,
    Key? key,
  }) : super(key: key);
  final types.User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await controller.createChat(user),
      child: Container(
        margin: const EdgeInsets.all(8),
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
            )
          ],
        ),
      ),
    );
  }
}
