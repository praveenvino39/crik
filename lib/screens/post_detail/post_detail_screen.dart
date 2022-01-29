import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crik/models/post.dart';
import 'package:crik/providers/home_provider.dart';
import 'package:crik/providers/post_detail_provider.dart';
import 'package:crik/widgets/comment_list.dart';
import 'package:crik/widgets/post_action.dart';
import 'package:crik/widgets/post_owner.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostDetail extends StatelessWidget {
  PostDetail({Key? key, required this.postModel}) : super(key: key);
  final PostModel postModel;
  final TextEditingController commentTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PostDetailProvider(),
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          title: const Text(
            "Post detail",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("post")
                    .orderBy("createAt", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else if (snapshot.hasData) {
                    var post = snapshot.data!.docs.firstWhere(
                        (element) => element.get("id") == postModel.id);
                    var postObject = PostModel.fromMap(data: post);
                    return Consumer<HomeProvider>(
                      builder: (context, homeProvider, child) => Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          PostOwner(post: postObject),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 2,
                            child: Hero(
                              tag: "Image",
                              child: CachedNetworkImage(
                                imageUrl: postModel.filePath,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(postObject.caption),
                              ),
                            ),
                          ),
                          PostAction(
                              post: postObject,
                              commentTextController: commentTextController,
                              homeProvider: homeProvider),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
