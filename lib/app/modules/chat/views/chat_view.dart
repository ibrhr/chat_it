import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:chat_it/constants/exports.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import '../controllers/chat_controller.dart';
import '../widgets/bubble.dart';
// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final types.Room room = Get.arguments;
    controller.initData(room);
    return WillPopScope(
      onWillPop: () async {
        controller.markAsRead();
        return true;
      },
      child: GetBuilder<ChatController>(builder: (controller) {
        return DefaultScreen(
          top: Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 4),
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  controller.otherUser!.imageUrl!,
                ),
              ),
              const SizedBox(width: 8),
              PrimaryText(
                controller.otherUser!.firstName!,
                fontSize: 16,
                color: Colors.white,
              ),
            ],
          ),
          bottom: StreamBuilder<types.Room>(
            initialData: room,
            stream: FirebaseChatCore.instance.room(room.id),
            builder: (context, snapshot) => StreamBuilder<List<types.Message>>(
              initialData: const [],
              stream: FirebaseChatCore.instance.messages(snapshot.data!),
              builder: (context, snapshot) => Chat(
                bubbleBuilder: (child,
                        {required message, required nextMessageInGroup}) =>
                    MyBubble(
                  message: message,
                  nextMessageInGroup: nextMessageInGroup,
                  child: child,
                ),
                disableImageGallery: true,
                messages: snapshot.data ?? [],
                onAttachmentPressed: controller.handleAtachmentPressed,
                onMessageTap: controller.handleMessageTap,
                onPreviewDataFetched: controller.handlePreviewDataFetched,
                onSendPressed: controller
                    .handleSendPressed, //   showUserAvatars: true, //    showUserNames: true,
                emojiEnlargementBehavior: EmojiEnlargementBehavior.single,
                user: controller.user,
              ),
            ),
          ),
        );
      }),
    );
  }
}
