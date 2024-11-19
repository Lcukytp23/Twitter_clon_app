import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final _auth = FirebaseAuth.instance;

  User? getCurrenUser() => _auth.currentUser;
  String getCurrenUid() => _auth.currentUser!.uid;


  Future<UserCredential> loginEmialPassword(String email, password) async{
    try{
      final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }
    
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> registerEmialPassword(String email, password) async{
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }

    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
  
  Future<void> logout() async{
    await _auth.signOut();
  }
}