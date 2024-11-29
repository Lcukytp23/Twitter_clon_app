import 'package:aplicaccion_2/components/my_drawer_title.dart';
import 'package:aplicaccion_2/pages/profile_page.dart';
import 'package:aplicaccion_2/pages/search_page.dart';
import 'package:aplicaccion_2/pages/settings_page.dart';
import 'package:aplicaccion_2/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final _auth = AuthService();

  void logout() {
    _auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(
                height: 10,
              ),
              MyDrawerTitle(
                title: "H O M E",
                icon: Icons.home,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              MyDrawerTitle(
                  title: "P R O F I L E",
                  icon: Icons.person,
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfilePage(uid: _auth.getCurrenUid())));
                  }),
              MyDrawerTitle(
                  title: "S E A R C H",
                  icon: Icons.search,
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchPage(),
                      ),
                    );
                  }),
              MyDrawerTitle(
                  title: "S E T T I N G S",
                  icon: Icons.settings,
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                  }),
              const Spacer(),
              MyDrawerTitle(
                title: "L O G O U T",
                icon: Icons.logout,
                onTap: logout,
              )
            ],
          ),
        ),
      ),
    );
  }
}
