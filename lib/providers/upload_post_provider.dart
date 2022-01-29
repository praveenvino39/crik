import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crik/models/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

enum AppState {
  free,
  picked,
  cropped,
}

class UploadPostProvider extends ChangeNotifier {
  late AppState state;
  final TextEditingController caption = TextEditingController();
  File? imageFile;

  UploadPostProvider({required this.imageFile}) {
    state = AppState.picked;
    cropImage();
  }

  //Crop image
  void cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: null,
            toolbarColor: Colors.amber,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          title: null,
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      state = AppState.cropped;
      notifyListeners();
    }
  }

  //Upload file to firebase
  Future<void> uploadFile(BuildContext context) async {
    File file = File(imageFile!.path);
    try {
      showDialog(
          context: context,
          builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ));
      var newFile = await FirebaseStorage.instance
          .ref('post_image/${p.basename(file.path)}');
      var task = newFile.putFile(file);
      task.snapshotEvents.listen((event) {
        print(
            "Byte transfered ==>${event.bytesTransferred.toDouble() / event.totalBytes.toDouble()}");
      });
      task.whenComplete(() async {
        var post = PostModel(
            Random().nextInt(10000000),
            await task.snapshot.ref.getDownloadURL(),
            caption.text,
            FirebaseAuth.instance.currentUser!.uid,
            Timestamp.now(),
            FirebaseAuth.instance.currentUser!.displayName!,
            FirebaseAuth.instance.currentUser!.photoURL!,
            0,
            0, [], [], []);
        FirebaseFirestore.instance.collection("post").add(post.toMap());
        _clearImage();
        caption.clear();
        Navigator.pop(context);
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Post uploaded successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.greenAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
      // e.g, e.code == 'canceled'
    }
  }

  //Clear image
  void _clearImage() {
    imageFile = null;
    state = AppState.free;
    notifyListeners();
  }

  //Pick Image
  Future<Null> pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (imageFile != null) {
      cropImage();
      state = AppState.picked;
      notifyListeners();
    }
  }
}
