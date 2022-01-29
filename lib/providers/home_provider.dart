import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crik/models/post.dart';
import 'package:crik/screens/upload_post/upload_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeProvider extends ChangeNotifier {
  File? imageFile;

  pickImage(BuildContext context) async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (imageFile != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UploadPost(
                    pickedImage: imageFile!,
                  )));
    }
  }

  void likeImage({required int imageId}) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    var querySnapshot =
        await FirebaseFirestore.instance.collection("post").get();
    var docSnapshot = querySnapshot.docs
        .firstWhere((element) => element.get("id") == imageId);
    var post = PostModel.fromMap(data: docSnapshot);

    if (post.likes.contains(userId)) {
      post.likeCount = post.likeCount - 1;
      post.likes.remove(userId);
    } else {
      post.likeCount = post.likeCount + 1;
      post.likes.add(userId);
      if (post.disLikes.contains(userId)) {
        post.disLikes.remove(userId);
        post.dislikeCount = post.dislikeCount - 1;
      }
    }
    docSnapshot.reference.update(post.toMap());
  }

  void disLikeImage({required int imageId}) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    var querySnapshot =
        await FirebaseFirestore.instance.collection("post").get();
    var docSnapshot = querySnapshot.docs
        .firstWhere((element) => element.get("id") == imageId);
    var post = PostModel.fromMap(data: docSnapshot);

    if (post.disLikes.contains(userId)) {
      post.dislikeCount = post.dislikeCount - 1;
      post.disLikes.remove(userId);
    } else {
      post.dislikeCount = post.dislikeCount + 1;
      post.disLikes.add(userId);
      if (post.likes.contains(userId)) {
        post.likes.remove(userId);
        post.likeCount = post.likeCount - 1;
      }
    }
    docSnapshot.reference.update(post.toMap());
  }

  void comment(
      {required String commentMessage,
      required int imageId,
      required BuildContext context}) async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection("post").get();
    var docSnapshot = querySnapshot.docs
        .firstWhere((element) => element.get("id") == imageId);
    var post = PostModel.fromMap(data: docSnapshot);

    var userId = FirebaseAuth.instance.currentUser!.uid;
    var name = FirebaseAuth.instance.currentUser!.displayName;
    var comment = Comment.fromJson({
      'userId': userId,
      'name': name,
      'userImage': FirebaseAuth.instance.currentUser!.photoURL,
      'comment': commentMessage,
      'commentedOn': Timestamp.now()
    });
    post.comments.add(comment.toMap());
    await docSnapshot.reference.update(post.toMap());
    Navigator.pop(context);
  }
}
