import 'dart:io';
import 'package:better_open_file/better_open_file.dart';
import 'package:chat_it/app/modules/auth/controllers/auth_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart' show rootBundle;
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
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  handleFileSelection();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Cancel'),
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
        setAttachmentUploading(false);
      } finally {
        setAttachmentUploading(false);
      }
    }
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

  void handleSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.sendMessage(
      message,
      room!.id,
    );
    setLastMessage(message.text);
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
