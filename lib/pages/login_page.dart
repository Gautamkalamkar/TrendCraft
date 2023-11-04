import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trendcraft/components/my_button.dart';
import 'package:trendcraft/components/my_text_field.dart';
import 'package:trendcraft/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key,required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async{
    //get the auth service
    final authService = Provider.of<AuthService>(context,listen: false);

    try
    {
      await authService.signInWithEmailAndPassword(emailController.text, passwordController.text);
    }
    catch(e)
    {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
        e.toString(),
      ),),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const SizedBox(height: 50),

                  //logo
                  Container(
                    height: 140,
                    child: Image.asset('assets/images/logo.png')
                  ),

                  //Create account message
                  const Text("Welcome back, You have been missed!",
                      style: TextStyle(
                        fontSize: 16
                      ),
                  ),

                  const SizedBox(height: 25),

                  //Email TextField
                  MyTextField(controller: emailController, hintText: 'Write your Email Here', obscureText: false),

                  const SizedBox(height: 10),

                  //Password TextField
                  MyTextField(controller: passwordController, hintText: 'Enter your password here', obscureText: true),

                  const SizedBox(height: 25),

                  //Sign Up button
                  MyButton(onTap: signIn, text:'Sign In'),

                  const SizedBox(height: 25),

                  //Already a member? Login now
                  Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text('Not a member?'),
                     SizedBox(width: 4),
                     GestureDetector(
                       onTap: widget.onTap,
                       child: const Text(
                         'Register now',
                          style: TextStyle(fontWeight: FontWeight.bold,)
                       ),
                     )
                   ],
                  )
                ]
                ),
            ),
          ),
        ),
      )
      );
  }
}
