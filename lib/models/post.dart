import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crik/widgets/post_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostModel {
  final int id;
  final String filePath;
  final String caption;
  final String user;
  final String displayName;
  final String profilePicture;
  final Timestamp createAt;
  late int likeCount;
  late int dislikeCount;
  List<dynamic> likes = [];
  List<dynamic> disLikes = [];
  List<dynamic> comments = [];

  PostModel(
      this.id,
      this.filePath,
      this.caption,
      this.user,
      this.createAt,
      this.displayName,
      this.profilePicture,
      this.likeCount,
      this.dislikeCount,
      this.likes,
      this.disLikes,
      this.comments);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'filePath': filePath,
      'caption': caption,
      'user': user,
      'createAt': createAt,
      'displayName': displayName,
      'profilePicture': profilePicture,
      'likeCount': likeCount,
      'dislikeCount': dislikeCount,
      'likes': likes,
      'dislikes': disLikes,
      'comments': comments
    };
  }

  static PostModel fromMap({required QueryDocumentSnapshot data}) {
    var comments = data.get("comments") as List;
    var sortedComments = comments.reversed;
    final postModel = PostModel(
        data.get("id"),
        data.get("filePath"),
        data.get("caption"),
        data.get("user"),
        data.get("createAt"),
        data.get("displayName"),
        data.get("profilePicture"),
        data.get("likeCount"),
        data.get("dislikeCount"),
        data.get("likes"),
        data.get("dislikes"),
        sortedComments.toList());
    return postModel;
  }

  isLiked() {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    return likes.contains(userId);
  }

  isDisliked() {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    return disLikes.contains(userId);
  }

  int commentCount() {
    return comments.length;
  }
}

class Comment {
  final userId;
  final name;
  final comment;
  final userImage;
  final Timestamp commentedOn;

  Comment(
      {required this.userId,
      required this.name,
      required this.comment,
      required this.userImage,
      required this.commentedOn});

  static Comment fromJson(comment) {
    return Comment(
        userId: comment["id"],
        name: comment["name"],
        userImage: comment["userImage"],
        comment: comment["comment"],
        commentedOn: comment["commentedOn"]);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'name': this.name,
      'comment': this.comment,
      'userImage': this.userImage,
      'commentedOn': commentedOn
    };
  }
}
