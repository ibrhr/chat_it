import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../../constants/exports.dart';
import '../controllers/chat_controller.dart';

class ChatDropDownButton extends GetView<ChatController> {
  const ChatDropDownButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.more_vert_outlined,
          ),
        ),
        customItemsIndexes: const [3],
        customItemsHeight: 8.h,
        items: [
          DropdownMenuItem<String>(
            value: 'remove',
            child: PrimaryText(
              LocaleKeys.remove_friend.tr,
            ),
          ),
        ],
        onChanged: (String? value) {
          controller.removeFriend(controller.otherUser!);
        },
        itemHeight: 48.h,
        itemPadding: const EdgeInsets.only(left: 16, right: 16),
        dropdownWidth: 160.w,
        dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        dropdownElevation: 8,
        offset: const Offset(0, 8),
      ),
    );
  }
}
