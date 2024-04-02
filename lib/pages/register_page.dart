import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:trendcraft/services/auth/auth_service.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //Sign up user
  void signUp() async{
    if(passwordController.text != confirmPasswordController.text)
      {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
        return;
      }

    //get auth instance
    final authService = Provider.of<AuthService>(context,listen: false);
    try
    {
      await authService.signUpWithEmailAndPassword(emailController.text,passwordController.text);
    }
    catch(e)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
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
                          height: 200,
                          margin: const EdgeInsets.only(bottom: 25),
                          child: Lottie.asset('assets/animations/register.json')
                      ),
                      //Welcome back Message
                      const Text("Let's create an account for you!",
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

                      const SizedBox(height: 10),

                      //Confirm Password TextField
                      MyTextField(controller: confirmPasswordController, hintText: 'Confirm your password', obscureText: true),

                      const SizedBox(height: 25),

                      //Sign up button
                      MyButton(onTap: signUp, text:'Sign Up'),

                      const SizedBox(height: 25),

                      //Not a member? Register now
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already a member?'),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                                'Login now',
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
