import 'package:aplicaccion_2/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({super.key});

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();

    loadBlockedUsers();
  }

  Future<void> loadBlockedUsers() async {
    await databaseProvider.loadBlockedUsers();
  }

  void _showUnblockConfirmationBox(String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Unblock User"),
              content:
                  const Text("Are you sure you want to unblock this user?"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),
                TextButton(
                  onPressed: () async {
                    await databaseProvider.unblockUser(userId);

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("User unblocked!")));
                  },
                  child: const Text("Unblock"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final blockedUsers = listeningProvider.blockedUsers;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Blocked Users"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: blockedUsers.isEmpty
          ? const Center(
              child: Text("No blocked users.."),
            )
          : ListView.builder(
              itemCount: blockedUsers.length,
              itemBuilder: (context, index) {
                final user = blockedUsers[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text('@${user.username}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.block),
                    onPressed: () => _showUnblockConfirmationBox(user.uid),
                  ),
                );
              },
            ),
    );
  }
}
