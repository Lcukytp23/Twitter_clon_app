import 'package:aplicaccion_2/components/my_button.dart';
import 'package:aplicaccion_2/components/my_loading_circle.dart';
import 'package:aplicaccion_2/components/my_text_field.dart';
import 'package:aplicaccion_2/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({
    super.key, 
    required this.onTap});

  
  @override
  State<LoginPage> createState() => _LoinPageSatae();
  }



class _LoinPageSatae extends State<LoginPage>{
  final _auth = AuthService();
  final TextEditingController emialController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  void login() async{

    showLoadingCircle(context);

    try{
      await _auth.loginEmialPassword(emialController.text, pwController.text);

     if (mounted) hideLoadingCircle(context);
    }

    catch (e) {
      if (mounted) hideLoadingCircle(context);
        
      if (mounted){
          showDialog(
            context: context, 
            builder: (context) => AlertDialog(
              title: Text(e.toString()),
            ),
            );
        }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
          
                Icon(
                  Icons.lock_open_rounded, 
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                  ),
                const SizedBox(height: 50),
          
                Text(
                  "Welcome back, you've been missed ", 
                style: TextStyle(color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                ),
                ),
                const SizedBox(height: 25),
          
                MyTextField(controller: emialController, 
                hintText: "Enter email", 
                obscureTex: false
                ),
                
                const SizedBox(height: 10),
          
                MyTextField(controller: pwController, 
                hintText: "Enter password", 
                obscureTex: true),

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text("Forgot Password?", 
                  style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold
                  ),
                  ),
                ),

                const SizedBox(height: 15),

                MyButton(
                  text: "Login", 
                  onTap: login,
                  ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member?", 
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),),

                    const SizedBox(width: 5,),

                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text("Register now",
                      style: TextStyle(color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                )
          
              ],
            ),
          ),
        ),
      ),
    );
  }
}