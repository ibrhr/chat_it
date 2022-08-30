import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:chat_it/constants/exports.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import '../controllers/chat_controller.dart';
import '../widgets/bubble.dart';
// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;


import '../../../../constants/exports.dart';
import '../widgets/chat_drop_down_button.dart';

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
               SizedBox(width: 4.w),
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  controller.otherUser!.imageUrl!,
                ),
              ),
               SizedBox(width: 8.w),
              PrimaryText(
                controller.otherUser!.firstName!,
                fontSize: 16,
                color: Colors.white,
              ),
              const Spacer(),
              const ChatDropDownButton(),
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
                isAttachmentUploading: controller.isAttachmentUploading,
                onMessageLongPress: (context, message) =>
                    controller.onMessageLongPress(context, message),
                disableImageGallery: true,
                messages: snapshot.data ?? [],
                onAttachmentPressed: controller.handleAtachmentPressed,
                onMessageTap: controller.handleMessageTap,
                onPreviewDataFetched: controller.handlePreviewDataFetched,
                onSendPressed: controller.handleSendPressed,
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
