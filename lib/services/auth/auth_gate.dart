import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trendcraft/pages/home_page.dart';
import 'package:trendcraft/services/auth/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          //user is logged in
          if(snapshot.hasData) {
            return const HomePage();
            // return const ReelsPage(src: 'https://www.youtube.com/shorts/JsPrQ655hJA');
          } else {
            return const LoginOrRegister();
          }
          //user is not logged in
        }
      )
    );
  }
}
