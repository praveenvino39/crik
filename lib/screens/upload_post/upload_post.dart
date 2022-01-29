import 'package:crik/providers/upload_post_provider.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class UploadPost extends StatelessWidget {
  UploadPost({Key? key, required this.pickedImage}) : super(key: key);
  late File pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        title: const Text(
          "Upload post",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SafeArea(
          child: ChangeNotifierProvider(
            create: (context) => UploadPostProvider(imageFile: pickedImage),
            builder: (context, widget) => Consumer<UploadPostProvider>(
              builder: (context, value, child) => Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image(
                          height: 70,
                          image: FileImage(value.imageFile!),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: value.caption,
                            maxLines: 3,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                                hintText: "Write something..."),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        value.uploadFile(context);
                      },
                      child: const Text(
                        "Post",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const Expanded(flex: 1, child: SizedBox())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
