import 'package:chat_it/constants/exports.dart';
// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import '../controllers/home_controller.dart';
import '../widgets/chat_list_item.dart';

class ChatsList extends StatefulWidget {
   ChatsList({
    Key? key,
    required this.page,
  }) : super(key: key);
  final SelectedView page;

  @override
  State<ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return StreamBuilder<List<types.Room>>(
        stream: FirebaseChatCore.instance.rooms(),
        initialData:  [],
        builder:
            (BuildContext context, AsyncSnapshot<List<types.Room>> snapshot) {
          if (snapshot.data == null || snapshot.data == []) {
            return  Center(
              child: PrimaryText( LocaleKeys.no_chats.tr),
            );
          } else {
            switch (widget.page) {
              case SelectedView.all:
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    final room = snapshot.data![i];
                    return ChatListItem(
                      room: room,
                      user: controller.user,
                    );
                  },
                );
              case SelectedView.read:
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    final room = snapshot.data![i];
                    return room.metadata![controller.user.id]['unread'] == 0
                        ? ChatListItem(
                            room: room,
                            user: controller.user,
                          )
                        : Container();
                  },
                );
              case SelectedView.unread:
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    final room = snapshot.data![i];
                    return room.metadata![controller.user.id]['unread'] != 0
                        ? ChatListItem(
                            room: room,
                            user: controller.user,
                          )
                        : Container();
                  },
                );
            }
          }
        },
      );
    });
  }
}
