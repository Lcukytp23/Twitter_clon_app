import 'package:aplicaccion_2/pages/account_settings_page.dart';
import 'package:aplicaccion_2/pages/home_page.dart';
import 'package:aplicaccion_2/pages/post_page.dart';
import 'package:aplicaccion_2/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/post.dart';
import '../pages/blocked_users_page.dart';

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

void goBlockedUsersPage(BuildContext contex) {
  Navigator.push(
    contex,
    MaterialPageRoute(builder: (contex) => BlockedUsersPage()),
  );
}

void goAccountSettingsPage(BuildContext contex) {
  Navigator.push(
    contex,
    MaterialPageRoute(builder: (contex) => AccountSettingsPage()),
  );
}

void goHomePage(BuildContext contex) {
  Navigator.pushAndRemoveUntil(
    contex,
    MaterialPageRoute(
      builder: (contex) => HomePage(),
    ),
    (route) => route.isFirst,
  );
}
