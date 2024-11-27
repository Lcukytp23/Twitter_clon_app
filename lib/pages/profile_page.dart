import 'package:aplicaccion_2/components/my_bio_box.dart';
import 'package:aplicaccion_2/components/my_input_alert_box.dart';
import 'package:aplicaccion_2/components/my_post_title.dart';
import 'package:aplicaccion_2/helper/navigate_pages.dart';
import 'package:aplicaccion_2/models/user.dart';
import 'package:aplicaccion_2/services/auth/auth_service.dart';
import 'package:aplicaccion_2/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);
  UserProfile? user;
  String currentUserId = AuthService().getCurrenUid();
  final bioTextController = TextEditingController();
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    user = await databaseProvider.userProfile(widget.uid);
    setState(() {
      _isLoading = false;
    });
  }

  void _showEditBioBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
          textController: bioTextController,
          hintText: "Edit bio..",
          onPressed: saveBio,
          onPressedText: "Save"),
    );
  }

  Future<void> saveBio() async {
    setState(() {
      _isLoading = true;
    });
    await databaseProvider.updateBio(bioTextController.text);
    await loadUser();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allUserPosts = listeningProvider.filterUserPosts(widget.uid);
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text(_isLoading ? '' : user!.name),
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: ListView(
          children: [
            Center(
              child: Text(
                _isLoading ? '' : '@${user!.username}',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(25),
                child: Icon(
                  Icons.person,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bio",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: _showEditBioBox,
                    child: Icon(Icons.settings,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            MyBioBox(text: _isLoading ? '...' : user!.bio),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 25),
              child: Text(
                "Posts",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            allUserPosts.isEmpty
                ? const Center(
                    child: Text("No posts yet..."),
                  )
                : ListView.builder(
                    itemCount: allUserPosts.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final post = allUserPosts[index];
                      return MyPostTitle(
                        post: post,
                        onUserTap: () {},
                        onPostTap: () => goPostPage(context, post),
                      );
                    },
                  )
          ],
        ));
  }
}
