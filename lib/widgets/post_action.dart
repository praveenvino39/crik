import 'package:crik/models/post.dart';
import 'package:crik/providers/home_provider.dart';
import 'package:crik/widgets/comment_list.dart';
import 'package:flutter/material.dart';

class PostAction extends StatelessWidget {
  const PostAction(
      {Key? key,
      required this.post,
      required this.commentTextController,
      required this.homeProvider})
      : super(key: key);

  final PostModel post;
  final TextEditingController commentTextController;
  final HomeProvider homeProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              IconButton(
                  onPressed: () {
                    homeProvider.likeImage(imageId: post.id);
                  },
                  icon: post.isLiked()
                      ? const Icon(
                          Icons.thumb_up,
                          color: Colors.amber,
                        )
                      : const Icon(Icons.thumb_up_off_alt_outlined)),
              Text(post.likeCount.toString())
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              IconButton(
                  onPressed: () {
                    homeProvider.disLikeImage(imageId: post.id);
                  },
                  icon: post.isDisliked()
                      ? const Icon(
                          Icons.thumb_down,
                          color: Colors.amber,
                        )
                      : const Icon(Icons.thumb_down_alt_outlined)),
              Text(post.dislikeCount.toString())
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => CommentList(
                        commentTextController: commentTextController,
                        post: post,
                        homeProvider: homeProvider,
                      ),
                    );
                  },
                  icon: const Icon(Icons.message_outlined)),
              Text(post.commentCount().toString())
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              IconButton(
                  onPressed: () {
                    homeProvider.likeImage(imageId: post.id);
                  },
                  icon: const Icon(Icons.share_outlined)),
              const Text("")
            ],
          ),
        )
      ],
    );
  }
}
