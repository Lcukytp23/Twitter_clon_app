import 'package:aplicaccion_2/components/my_user_title.dart';
import 'package:aplicaccion_2/models/user.dart';
import 'package:aplicaccion_2/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowListPage extends StatefulWidget {
  final String uid;
  const FollowListPage({super.key, required this.uid});

  @override
  State<FollowListPage> createState() => _FollowListPageState();
}

class _FollowListPageState extends State<FollowListPage> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();

    loadFollowerList();

    loadFollowingList();
  }

  Future<void> loadFollowerList() async {
    await databaseProvider.loadUserFollowerProfiles(widget.uid);
  }

  Future<void> loadFollowingList() async {
    await databaseProvider.loadUserFollowingProfiles(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final followers = listeningProvider.getListOfFollowersProfile(widget.uid);
    final following = listeningProvider.getListOfFollowingProfile(widget.uid);

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            foregroundColor: Theme.of(context).colorScheme.primary,
            bottom: TabBar(
                dividerColor: Colors.transparent,
                labelColor: Theme.of(context).colorScheme.inversePrimary,
                unselectedLabelColor: Theme.of(context).colorScheme.primary,
                indicatorColor: Theme.of(context).colorScheme.secondary,
                tabs: const [
                  Tab(text: "Followers"),
                  Tab(text: "Following"),
                ]),
          ),
          body: TabBarView(children: [
            _builderUserList(followers, "No followes.."),
            _builderUserList(following, "No following.."),
          ]),
        ));
  }

  Widget _builderUserList(List<UserProfile> userList, String emptyMessage) {
    return userList.isEmpty
        ? Center(
            child: Text(emptyMessage),
          )
        : ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];

              return MyUserTitle(user: user);
            },
          );
  }
}
