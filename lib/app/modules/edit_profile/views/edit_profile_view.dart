import 'package:chat_it/app/modules/home/views/home_view.dart';
import 'package:chat_it/constants/exports.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
        top: Row(children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 8),
          const PrimaryText(
            'Profile',
            fontSize: 18,
          )
        ]),
        bottom: Column(
          children: [
            Stack(children: [
              CircleAvatar(
                radius: 96.w,
                foregroundImage: const NetworkImage(
                  'https://thumbs.dreamstime.com/z/closeup-photo-funny-excited-lady-raise-fists-screaming-loudly-celebrating-money-lottery-winning-wealthy-rich-person-wear-casual-172563278.jpg',
                ),
              ),
              Positioned(
                  right: 0,
                  bottom: 0,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            const CircleBorder())),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Icon(
                        Icons.image_outlined,
                        size: 32,
                      ),
                    ),
                  )),
            ])
          ],
        ));
  }
}
