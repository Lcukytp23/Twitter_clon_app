import 'package:aplicaccion_2/models/post.dart';
import 'package:aplicaccion_2/models/user.dart';
import 'package:aplicaccion_2/services/database/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class DatabaseProvider extends ChangeNotifier {
  final _db = DatabaseService();

  Future<UserProfile?> userProfile(String uid) => _db.getUserFromFirebase(uid);

  Future<void> updateBio(String bio) => _db.updateUserBioInFirebase(bio);

  List<Post> _allPosts = [];

  List<Post> get allPosts => _allPosts;

  Future<void> postMessage(String message) async {
    await _db.postMessageInFirebase(message);

    await loadAllPosts();
  }

  Future<void> loadAllPosts() async {
    final allPosts = await _db.getAllPostsFromFirebase();

    _allPosts = allPosts;

    notifyListeners();
  }
}
