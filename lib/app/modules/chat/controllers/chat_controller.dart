import 'dart:io';
import 'package:better_open_file/better_open_file.dart';
import 'package:chat_it/app/modules/auth/controllers/auth_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chat_it/constants/exports.dart';

class ChatController extends GetxController {
  types.Room? room;
  types.User user = Get.find<AuthController>().user!;
  types.User? otherUser;
  bool isAttachmentUploading = false;

  Future<void> initData(types.Room? room) async {
    this.room = room;
    if (room!.users[0].id == user.id) {
      otherUser = room.users[1];
    } else {
      otherUser = room.users[0];
    }
  }

  Future<void> removeFriend(types.User friend) async {
    var metadata = user.metadata;
    Map<String, dynamic> friends = metadata!['friends'];
    friends.remove(friend.id);
    metadata.addAll({'friends': friends});

    await FirebaseChatCore.instance
        .getFirebaseFirestore()
        .collection('users')
        .doc(user.id)
        .update({'metadata': metadata});
    update();
  }

  void handleAtachmentPressed() {
    Get.bottomSheet(
      SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back();
                  handleImageSelection();
                },
                child:  Align(
                  alignment: Alignment.centerLeft,
                  child: PrimaryText(LocaleKeys.photo.tr),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  handleFileSelection();
                },
                child:  Align(
                  alignment: Alignment.centerLeft,
                  child: PrimaryText(LocaleKeys.file.tr),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child:  Align(
                  alignment: Alignment.centerLeft,
                  child: PrimaryText(LocaleKeys.cancel.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path!;
      final file = File(filePath);

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        FirebaseChatCore.instance.sendMessage(message, room!.id);
        await setLastMessage('Attachment');
        setAttachmentUploading(false);
      } finally {
        setAttachmentUploading(false);
      }
    }
  }

  void handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        FirebaseChatCore.instance.sendMessage(
          message,
          room!.id,
        );
        await setLastMessage('Attachment');
        setAttachmentUploading(false);
      } finally {
        setAttachmentUploading(false);
      }
    }
  }

  void onMessageLongPress(BuildContext context, types.Message message) {
    Get.dialog(
      AlertDialog(
        content:  PrimaryText(
          LocaleKeys.delete_message.tr,
          fontSize: 16,
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          ElevatedButton(
            onPressed: () {
              FirebaseChatCore.instance.deleteMessage(room!.id, message.id);
              Get.back();
            },
            child:  PrimaryText(
              LocaleKeys.yes.tr,
              fontSize: 14,
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(),
            child:  PrimaryText(
              LocaleKeys.no.tr,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final updatedMessage = message.copyWith(isLoading: true);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            room!.id,
          );

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final updatedMessage = message.copyWith(isLoading: false);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            room!.id,
          );
        }
      }

      await OpenFile.open(localPath);
    }
  }

  void handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, room!.id);
  }

  Future<void> handleSendPressed(types.PartialText message) async {
    FirebaseChatCore.instance.sendMessage(
      message,
      room!.id,
    );
    await setLastMessage(message.text);
  }

  void setAttachmentUploading(bool uploading) {
    isAttachmentUploading = uploading;
    update();
  }

  Future<void> setLastMessage(String message) async {
    room!.metadata!['lastMessage'] = message;
    final snapshot = await FirebaseChatCore.instance
        .getFirebaseFirestore()
        .collection('rooms')
        .doc(room!.id)
        .get();
    final Map<String, dynamic> metadata = snapshot.data()!['metadata'];
    room!.metadata![otherUser!.id]['unread'] =
        metadata[otherUser!.id]['unread'] + 1;
    FirebaseChatCore.instance.updateRoom(room!);
  }

  void markAsRead() {
    room!.metadata![user.id]['unread'] = 0;
    FirebaseChatCore.instance.updateRoom(room!);
  }
}
