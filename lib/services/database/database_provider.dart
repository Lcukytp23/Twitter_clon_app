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
  List<Post> _followingPosts = [];

  List<Post> get allPosts => _allPosts;
  List<Post> get followingPosts => _followingPosts;

  Future<void> postMessage(String message) async {
    await _db.postMessageInFirebase(message);

    await loadAllPosts();
  }

  Future<void> loadAllPosts() async {
    final allPosts = await _db.getAllPostsFromFirebase();
    final blockedUserIds = await _db.getBlockedUidsFromFirebase();

    _allPosts =
        allPosts.where((post) => !blockedUserIds.contains(post.uid)).toList();

    loadFollowingPosts();

    initializeLikeMap();

    notifyListeners();
  }

  List<Post> filterUserPosts(String uid) {
    return _allPosts.where((post) => post.uid == uid).toList();
  }

  Future<void> loadFollowingPosts() async {
    String currentUid = _auth.getCurrenUid();
    final followingUserIds = await _db.getFollowingUidsFromFirebase(currentUid);

    _followingPosts =
        _allPosts.where((post) => followingUserIds.contains(post.uid)).toList();

    notifyListeners();
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

  final Map<String, List<String>> _followers = {};
  final Map<String, List<String>> _following = {};
  final Map<String, int> _followerCount = {};
  final Map<String, int> _followingCount = {};

  int getFollowerCount(String uid) => _followerCount[uid] ?? 0;
  int getFollowingCount(String uid) => _followingCount[uid] ?? 0;

  Future<void> loadUserFollowers(String uid) async {
    final list0fFollowerUids = await _db.getFollowerUidsFromFirebase(uid);

    _followers[uid] = list0fFollowerUids;
    _followerCount[uid] = list0fFollowerUids.length;

    notifyListeners();
  }

  Future<void> loadUserFollowing(String uid) async {
    final list0fFollowingUids = await _db.getFollowingUidsFromFirebase(uid);

    _following[uid] = list0fFollowingUids;
    _followingCount[uid] = list0fFollowingUids.length;

    notifyListeners();
  }

  Future<void> followUser(String targetUserId) async {
    final currentUserId = _auth.getCurrenUid();

    _following.putIfAbsent(currentUserId, () => []);
    _followers.putIfAbsent(targetUserId, () => []);

    if (!_followers[targetUserId]!.contains(currentUserId)) {
      _followers[targetUserId]?.add(currentUserId);
      _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) + 1;

      _following[currentUserId]?.add(targetUserId);
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) + 1;
    }
    notifyListeners();

    try {
      await _db.followUserInFirebase(targetUserId);

      await loadUserFollowers(currentUserId);

      await loadUserFollowing(currentUserId);
    } catch (e) {
      _followers[targetUserId]?.remove(currentUserId);
      _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) - 1;

      _following[currentUserId]?.remove(targetUserId);
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) - 1;

      notifyListeners();
    }
  }

  Future<void> unfollowUser(String targetUserId) async {
    final currentUserId = _auth.getCurrenUid();

    _following.putIfAbsent(currentUserId, () => []);
    _followers.putIfAbsent(targetUserId, () => []);

    if (_followers[targetUserId]!.contains(currentUserId)) {
      _followers[targetUserId]?.remove(currentUserId);
      _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 1) - 1;

      _following[currentUserId]?.remove(targetUserId);
      _followingCount[currentUserId] = (_followerCount[currentUserId] ?? 1) - 1;
    }

    notifyListeners();

    try {
      await _db.unFollowUserInFirebase(targetUserId);

      await loadUserFollowers(currentUserId);

      await loadUserFollowing(currentUserId);
    } catch (e) {
      _followers[targetUserId]?.add(currentUserId);
      _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) + 1;

      _following[currentUserId]?.add(targetUserId);
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) + 1;

      notifyListeners();
    }
  }

  bool isFollowing(String uid) {
    final currentUserId = _auth.getCurrenUid();
    return _followers[uid]?.contains(currentUserId) ?? false;
  }

  final Map<String, List<UserProfile>> _followersProfile = {};
  final Map<String, List<UserProfile>> _followingProfile = {};

  List<UserProfile> getListOfFollowersProfile(String uid) =>
      _followersProfile[uid] ?? [];
  List<UserProfile> getListOfFollowingProfile(String uid) =>
      _followingProfile[uid] ?? [];

  Future<void> loadUserFollowerProfiles(String uid) async {
    try {
      final followerIds = await _db.getFollowerUidsFromFirebase(uid);

      List<UserProfile> followerProfiles = [];

      for (String followerId in followerIds) {
        UserProfile? followerProfile =
            await _db.getUserFromFirebase(followerId);

        if (followerProfile != null) {
          followerProfiles.add(followerProfile);
        }
      }

      _followersProfile[uid] = followerProfiles;

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadUserFollowingProfiles(String uid) async {
    try {
      final followingIds = await _db.getFollowingUidsFromFirebase(uid);

      List<UserProfile> followingProfiles = [];

      for (String followingId in followingIds) {
        UserProfile? followingProfile =
            await _db.getUserFromFirebase(followingId);

        if (followingProfile != null) {
          followingProfiles.add(followingProfile);
        }
      }

      _followingProfile[uid] = followingProfiles;

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  List<UserProfile> _searchResults = [];

  List<UserProfile> get searchResult => _searchResults;

  Future<void> searchUser(String searchTerm) async {
    try {
      final results = await _db.searchUserInFirebase(searchTerm);

      _searchResults = results;

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
