import 'package:bubble/bubble.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:chat_it/constants/exports.dart';
import '../controllers/chat_controller.dart';

class MyBubble extends GetView<ChatController> {
  const MyBubble({
    Key? key,
    required this.message,
    required this.nextMessageInGroup,
    required this.child,
  }) : super(key: key);
  final types.Message message;
  final bool nextMessageInGroup;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Bubble(
      color: controller.user.id != message.author.id ||
              message.type == types.MessageType.image
          ? ColorManager.secondaryColor
          : ColorManager.backgroundColor,
      padding: const BubbleEdges.all(0),
      radius: const Radius.circular(16),
      margin: nextMessageInGroup
          ? const BubbleEdges.symmetric(horizontal: 6)
          : null,
      nipHeight: 16.h,
      nipWidth: 4.w,
      nip: nextMessageInGroup
          ? BubbleNip.no
          : controller.user.id != message.author.id
              ? BubbleNip.leftBottom
              : BubbleNip.rightBottom,
      child: child,
    );
  }
}
