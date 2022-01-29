import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class Comment extends StatelessWidget {
  const Comment(
      {Key? key,
      required this.userImage,
      required this.userName,
      required this.comment,
      required this.commentedOn})
      : super(key: key);
  final String userImage;
  final String userName;
  final String comment;
  final Timestamp commentedOn;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey.withAlpha(30)),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: CachedNetworkImage(imageUrl: userImage),
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                userName,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
              const SizedBox(
                width: 6,
              ),
              Dot(),
              const SizedBox(
                width: 6,
              ),
              Text(
                timeago.format(commentedOn.toDate()),
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              )
            ],
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 35),
            child: Text(
              comment,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
    );
  }
}
