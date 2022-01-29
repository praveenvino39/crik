import 'package:cached_network_image/cached_network_image.dart';
import 'package:crik/models/post.dart';
import 'package:crik/providers/home_provider.dart';
import 'package:crik/screens/post_detail/post_detail_screen.dart';
import 'package:crik/widgets/comment_list.dart';
import 'package:crik/widgets/post_action.dart';
import 'package:crik/widgets/post_owner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Post extends StatelessWidget {
  Post({Key? key, required this.post}) : super(key: key);
  final TextEditingController commentTextController = TextEditingController();

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) => SizedBox(
        width: double.infinity,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 13, vertical: 5),
          child: Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostDetail(
                              postModel: post,
                            )));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  PostOwner(post: post),
                  const SizedBox(
                    height: 10,
                  ),
                  Hero(
                    tag: "Image",
                    child: Image(
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                      image: CachedNetworkImageProvider(post.filePath),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      post.caption,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  PostAction(
                    post: post,
                    commentTextController: commentTextController,
                    homeProvider: homeProvider,
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
