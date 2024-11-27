import 'package:aplicaccion_2/pages/post_page.dart';
import 'package:aplicaccion_2/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/post.dart';

void goUserPage(BuildContext contex, String uid) {
  Navigator.push(
      contex,
      MaterialPageRoute(
          builder: (contex) => ProfilePage(
                uid: uid,
              )));
}

void goPostPage(BuildContext context, Post post) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => PostPage(
              post: post,
            )),
  );
}
