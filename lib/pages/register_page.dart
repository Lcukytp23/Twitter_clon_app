import 'package:aplicaccion_2/components/my_loading_circle.dart';
import 'package:aplicaccion_2/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({
    super.key, 
    required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _auth = AuthService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emialController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  void register() async{
    if (pwController.text == confirmPwController.text){
      showLoadingCircle(context);

      try{
        await _auth.registerEmialPassword(emialController.text, pwController.text);

        if (mounted) hideLoadingCircle(context);
      }
      catch (e){
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
    else{
      showDialog(
        context: context, 
        builder: (context) => const AlertDialog(
        title: Text("Password don't match!"),
          ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: SafeArea(
        child: SingleChildScrollView(
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
                    "Let's create an account for you", 
                  style: TextStyle(color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  ),
                  ),
                  const SizedBox(height: 25),
          
                  //Ingresar el nombre
                  MyTextField(controller: nameController, 
                  hintText: "Enter name", 
                  obscureTex: false
                  ),
                  
                  const SizedBox(height: 10),
          
                  //Ingresar correo electronico
                  MyTextField(controller: emialController, 
                  hintText: "Enter email", 
                  obscureTex: false
                  ),
                  
                  const SizedBox(height: 10),
          
                  //Ingresar una contraseña
                  MyTextField(controller: pwController, 
                  hintText: "Enter password", 
                  obscureTex: true),
          
                  const SizedBox(height: 10),
                  
                  //Confirmar contraseña
                  MyTextField(controller: confirmPwController, 
                  hintText: "Confirm password", 
                  obscureTex: true),
          
                  const SizedBox(height: 10),
          
          
                  //Registar usuario
                  MyButton(
                    text: "Register", 
                    onTap: register,
                    ),

                    const SizedBox(height: 10),
          
                    //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already a member?", 
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),),
          
                      const SizedBox(width: 5,),
          
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Loging now",
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
      ),
    );
  }
}