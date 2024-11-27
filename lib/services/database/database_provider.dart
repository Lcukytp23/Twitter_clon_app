import 'package:aplicaccion_2/models/comment.dart';
import 'package:aplicaccion_2/models/post.dart';
import 'package:aplicaccion_2/models/user.dart';
import 'package:aplicaccion_2/services/auth/auth_service.dart';
import 'package:aplicaccion_2/services/database/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class DatabaseProvider extends ChangeNotifier {
  final _db = DatabaseService();
  final _auth = AuthService();

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

    initializeLikeMap();

    notifyListeners();
  }

  List<Post> filterUserPosts(String uid) {
    return _allPosts.where((post) => post.uid == uid).toList();
  }

  Future<void> deletePost(String postId) async {
    await _db.deletePostFromFirebase(postId);
    await loadAllPosts();
  }

  Map<String, int> _likeCounts = {};
  List<String> _likedPosts = [];

  bool isPostLikedByCurrentUser(String postId) => _likedPosts.contains(postId);
  int getLikeCount(String postId) => _likeCounts[postId] ?? 0;

  void initializeLikeMap() {
    final currentUserID = _auth.getCurrenUid();
    _likedPosts.clear();

    for (var post in _allPosts) {
      _likeCounts[post.id] = post.likeCount;
      if (post.likedBy.contains(currentUserID)) {
        _likedPosts.add(post.id);
      }
    }
  }

  Future<void> toggleLike(String postId) async {
    final likedPostsOriginal = _likedPosts;
    final likedCountsOriginal = _likeCounts;

    if (_likedPosts.contains(postId)) {
      _likedPosts.remove(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) - 1;
    } else {
      _likedPosts.add(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) + 1;
    }
    notifyListeners();

    try {
      await _db.togglelikeInFirebase(postId);
    } catch (e) {
      _likedPosts = likedPostsOriginal;
      _likeCounts = likedCountsOriginal;

      notifyListeners();
    }
  }

  final Map<String, List<Comment>> _comments = {};
  List<Comment> getComments(String postId) => _comments[postId] ?? [];

  Future<void> loadComments(String postId) async {
    final allComments = await _db.getCommentsFromFirebase(postId);

    _comments[postId] = allComments;

    notifyListeners();
  }

  Future<void> addComment(String postId, message) async {
    await _db.addCommentInFirebase(postId, message);
    await loadComments(postId);
  }

  Future<void> deleteComment(String commentId, postId) async {
    await _db.deleteCommentIFirebase(commentId);
    await loadComments(postId);
  }

  List<UserProfile> _blockedUsers = [];

  List<UserProfile> get blockedUsers => _blockedUsers;

  Future<void> loadBlockedUsers() async {
    final blockedUserIds = await _db.getBlockedUidsFromFirebase();
    final blockedUsersData = await Future.wait(
        blockedUserIds.map((id) => _db.getUserFromFirebase(id)));

    _blockedUsers = blockedUsersData.whereType<UserProfile>().toList();

    notifyListeners();
  }

  Future<void> blockUser(String userId) async {
    await _db.blockUserInfirebase(userId);

    await loadBlockedUsers();

    await loadAllPosts();

    notifyListeners();
  }

  Future<void> unblockUser(String blockedUserId) async {
    await _db.unblockUserInFirebase(blockedUserId);

    await loadBlockedUsers();

    await loadAllPosts();

    notifyListeners();
  }

  Future<void> reportUser(String postId, userId) async {
    await _db.reportUserInFirebase(postId, userId);
  }
}
