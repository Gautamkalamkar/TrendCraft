import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trendcraft/pages/chat_page.dart';
import 'package:trendcraft/services/auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //create an auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign out user
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(Icons.chat_rounded),
          Icon(Icons.videocam_rounded),
        ],
        backgroundColor: Colors.purple,
        color: Colors.purple.shade200,
        animationCurve: Curves.ease,
      ),
      body: _buildUserList(),
    );
  }

  //build a list of users except for the currently logged in user.
  Widget _buildUserList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  //build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    //display all users except the currently logged in user
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
          title: Text(data['email']),
          onTap: () {
            //pass the clicked user's UID to the chat page
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                          receiverUserEmail: data['email'],
                          receiverUserID: data['uid'],
                        )));
          });
    } else {
      //return an empty container
      return Container();
    }
  }
}
