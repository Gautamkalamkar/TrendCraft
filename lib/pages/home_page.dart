import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trendcraft/services/auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //sign out user
  void signOut()
  {
    final authService = Provider.of<AuthService>(context,listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page'),
        actions: [IconButton(
          onPressed: signOut, icon: const Icon(Icons.logout),
        )],
      ),
    );
  }
}
