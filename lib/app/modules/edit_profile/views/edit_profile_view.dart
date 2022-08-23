import 'package:chat_it/constants/exports.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
      builder: (controller) => DefaultScreen(
          top: Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 8),
              const PrimaryText(
                'Profile',
                fontSize: 20,
                color: Colors.white,
              ),
            ],
          ),
          bottom: Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 96.w,
                      foregroundImage: NetworkImage(
                        controller.photoUrl!,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: ElevatedButton(
                        onPressed: () async => await controller.updateImage(),
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
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ListTile(
                  onTap: () => controller.onNameTap(),
                  leading: Icon(
                    Icons.person,
                    color: ColorManager.iconColor,
                  ),
                  title: PrimaryText(
                    'Name',
                    color: ColorManager.iconColor,
                  ),
                  trailing: Icon(
                    Icons.edit,
                    color: ColorManager.iconColor,
                  ),
                  subtitle: PrimaryText(
                    controller.name!,
                  ),
                ),
                ListTile(
                  onTap: () => controller.onAboutTap(),
                  leading: Icon(
                    Icons.info_outline,
                    color: ColorManager.iconColor,
                  ),
                  title: PrimaryText(
                    'About',
                    color: ColorManager.iconColor,
                  ),
                  subtitle: PrimaryText(
                    controller.about!,
                  ),
                  trailing: Icon(
                    Icons.edit,
                    color: ColorManager.iconColor,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.email_sharp,
                    color: ColorManager.iconColor,
                  ),
                  title: PrimaryText(
                    'Email',
                    color: ColorManager.iconColor,
                  ),
                  subtitle: PrimaryText(
                    controller.email!,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
