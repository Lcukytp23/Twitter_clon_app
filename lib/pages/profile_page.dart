import 'package:aplicaccion_2/components/my_bio_box.dart';
import 'package:aplicaccion_2/components/my_input_alert_box.dart';
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
  late final databaseProvider = 
  Provider.of<DatabaseProvider> (context, listen: false);

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

  void _showEditBioBox(){
    showDialog(
      context: context, 
      builder: (context) => MyInputAlertBox(
        textController: bioTextController, 
        hintText: "Edit bio..", 
        onPressed: saveBio, 
        onPressedText: "Save"
        ),
    );
  }

  Future<void> saveBio()async{
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(_isLoading ? '' : user!.name),
        foregroundColor: Theme.of(context).colorScheme.primary,
        ),


      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: ListView(
          children: [
            Center(child: Text(_isLoading ? '' : '@${user!.username}',
            style: TextStyle(color: Theme.of(context).colorScheme.primary), ),
            ),
        
            const SizedBox(height: 25),
        
            Center(
              child: Container(
                decoration: 
                 BoxDecoration(
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
        
            Row(
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
                  color: Theme.of(context).colorScheme.primary
                  ),
                ),
                ],
            ),

            const SizedBox(height: 10),
        
            MyBioBox(text: _isLoading ? '...' : user!.bio),
          ],
        ),
      )
    );
  }
}