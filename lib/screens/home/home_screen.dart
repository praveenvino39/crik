import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crik/models/post.dart';
import 'package:crik/providers/home_provider.dart';
import 'package:crik/screens/upload_post/upload_post.dart';
import 'package:crik/widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: ChangeNotifierProvider(
        create: (context) => HomeProvider(),
        builder: (context, child) => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.amber,
            title: const Text(
              "Crik",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) => const Center(
                              child: CircularProgressIndicator(),
                            ));
                    await GoogleSignIn().signOut();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ))
            ],
          ),
          floatingActionButton: Consumer<HomeProvider>(
            builder: (context, homeProvider, widget) => FloatingActionButton(
                foregroundColor: Colors.white,
                child: Icon(Icons.add),
                onPressed: () {
                  homeProvider.pickImage(context);
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => UploadPost()));
                }),
          ),
          body: Column(
            children: [
              Expanded(
                flex: 1,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("post")
                        .orderBy("createAt", descending: true)
                        .snapshots(),
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.hasData) {
                        if ((asyncSnapshot.data as QuerySnapshot).size == 0) {
                          return const Center(
                            child: Text("No news to display"),
                          );
                        } else {
                          return ListView.builder(
                              itemCount:
                                  (asyncSnapshot.data as QuerySnapshot).size,
                              itemBuilder: (context, index) => Post(
                                  post: PostModel.fromMap(
                                      data:
                                          (asyncSnapshot.data as QuerySnapshot)
                                              .docs[index])));
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
