import 'package:aplicaccion_2/components/my_drawer.dart';
import 'package:aplicaccion_2/components/my_input_alert_box.dart';
import 'package:aplicaccion_2/components/my_post_title.dart';
import 'package:aplicaccion_2/helper/navigate_pages.dart';
import 'package:aplicaccion_2/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    loadAllPosts();
  }

  Future<void> loadAllPosts() async {
    await databaseProvider.loadAllPosts();
  }

  void _openPostMessageBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
        textController: _messageController,
        hintText: "What's on your mind?",
        onPressed: () async {
          await postMessage(_messageController.text);
        },
        onPressedText: "Post",
      ),
    );
  }

  Future<void> postMessage(String message) async {
    await databaseProvider.postMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text("H O M E"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openPostMessageBox,
        child: const Icon(Icons.add),
      ),
      body: _buildPostList(listeningProvider.allPosts),
    );
  }

  Widget _buildPostList(List<Post> posts) {
    return posts.isEmpty
        ? const Center(
            child: Text("Nothing here.."),
          )
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return MyPostTitle(
                post: post,
                onUserTap: () => goUserPage(context, post.uid),
                onPostTap: () => goPostPage(context, post),
              );
            },
          );
  }
}
