import 'package:crik/models/post.dart';
import 'package:crik/widgets/comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class PostOwner extends StatelessWidget {
  const PostOwner({
    Key? key,
    required this.post,
  }) : super(key: key);

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Container(
          width: 30,
          height: 30,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Image.network(post.profilePicture),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(post.displayName),
        const SizedBox(
          width: 10,
        ),
        Dot(),
        const SizedBox(
          width: 10,
        ),
        Text(timeAgo.format(post.createAt.toDate()))
      ],
    );
  }
}
