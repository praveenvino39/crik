import 'package:crik/models/post.dart';
import 'package:crik/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'comment_widget.dart' as Comment;

class CommentList extends StatelessWidget {
  const CommentList(
      {Key? key,
      required this.commentTextController,
      required this.post,
      required this.homeProvider})
      : super(key: key);

  final TextEditingController commentTextController;
  final PostModel post;
  final HomeProvider homeProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: commentTextController,
            maxLines: 3,
            decoration: const InputDecoration(hintText: "Write a comment..."),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  homeProvider.comment(
                      commentMessage: commentTextController.text,
                      imageId: post.id,
                      context: context);
                },
                child: Text("Post comment")),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: post.comments.length,
              itemBuilder: (context, index) => Comment.Comment(
                userImage: post.comments[index]["userImage"],
                userName: post.comments[index]["name"],
                comment: post.comments[index]["comment"],
                commentedOn: post.comments[index]["commentedOn"],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
