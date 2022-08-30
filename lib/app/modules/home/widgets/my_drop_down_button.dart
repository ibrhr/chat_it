
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../../constants/exports.dart';
import '../../../routes/app_pages.dart';
import '../../auth/controllers/auth_controller.dart';

class MyDropDownButton extends StatelessWidget {
   MyDropDownButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton:  Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.more_vert_outlined,
          ),
        ),
        customItemsIndexes:  [3],
        customItemsHeight: 8,
        items:  [
          DropdownMenuItem<String>(
            value: 'Profile',
            child: PrimaryText(
              'Profile',
            ),
          ),
          DropdownMenuItem<String>(
            value: 'Logout',
            child: PrimaryText(
              'Logout',
            ),
          ),
        ],
        onChanged: (String? value) {
          value! == 'Profile'
              ? Get.toNamed(Routes.EDIT_PROFILE)
              : Get.find<AuthController>().signOut();
        },
        itemHeight: 48,
        itemPadding:  EdgeInsets.only(left: 16, right: 16),
        dropdownWidth: 160,
        dropdownPadding:  EdgeInsets.symmetric(vertical: 6),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        dropdownElevation: 8,
        offset:  Offset(0, 8),
      ),
    );
  }
}
