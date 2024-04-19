import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trendcraft/pages/chat_page.dart';
import 'package:trendcraft/services/auth/auth_service.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //create an auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isHome = true;
  int _selectedIndex = 0;
  Color iconColor = Colors.white;

  //Make a list of videos
  final List<String> videos = [
    'assets/videos/short1.mp4',
    'assets/videos/short2.mp4',
    'assets/videos/short3.mp4',
  ];
  int videoIndex = 0;
  late VideoPlayerController _controller;
  late PageController _pageController;
  Future<void>? _initializeVideoPlayerFuture;

  Future<void> initializeVideoPlayer() async {
    _controller = VideoPlayerController.asset(videos[videoIndex])
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.play();
        setState(() {
           _initializeVideoPlayerFuture = _controller.initialize();
        });
      });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    initializeVideoPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _pageController.dispose();
  }

  //sign out user
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  List<Widget> actionsButton() {
    if (isHome == true) {
      return [
        IconButton(
          onPressed: signOut,
          icon: const Icon(Icons.logout),
        ),
      ];
    } else {
      return [];
    }
  }

  Widget displayDrawer() {
    return Drawer(
      backgroundColor: Colors.cyan.shade200,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //The icon of the app
            DrawerHeader(
                child: Image.asset(
              'assets/images/logo.png',
              height: 130,
              width: 130,
            )),

            //ListTile for Settings
            const ListTile(
              leading: Icon(Icons.dark_mode_rounded),
              title: Text('Modes'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (isHome == true)
          ? AppBar(
              backgroundColor:
                  (isHome == true) ? Colors.green : Colors.transparent,
              title: (isHome == true) ? const Text('TrendCraft') : null,
              actions: actionsButton(),
            )
          : AppBar(
            title: Text('Reels',style: TextStyle(color: iconColor,fontSize:28),),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
      extendBodyBehindAppBar: true,
      drawer: (isHome == true) ? displayDrawer() : null,
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        items: const [
          Icon(Icons.chat_rounded),
          Icon(Icons.videocam_rounded),
        ],
        onTap: (index) {
          setState(() {
            if (index == 1) {
              isHome = false;
            } else {
              isHome = true;
            }
            _selectedIndex = index;
          });
        },
        backgroundColor: (Colors.blueGrey[200])!,
        color: Colors.cyan.shade500,
        animationCurve: Curves.ease,
      ),
      body: (isHome == true) ? _buildUserList() : reels(),
    );
  }

  //Implemented the logic to contain reels
  Widget reels() {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: videos.length,
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          videoIndex = index;
        });
        _controller.dispose();
        initializeVideoPlayer();
      },
      itemBuilder: (context, index) {
        return FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: GestureDetector(
                    onTap: () {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    },
                    child: Stack(children:[
                      VideoPlayer(_controller),
                      Container(
                        margin: const EdgeInsets.only(top: 70,right: 20),
                        alignment: Alignment.centerRight,
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite,color:iconColor,size: 30,),
                            const SizedBox(height: 30,),
                            Icon(Icons.share,color:iconColor,size: 30,),
                            const SizedBox(height: 30,),
                            Icon(Icons.comment,color:iconColor,size: 30,),
                            const SizedBox(height: 30,),
                          ],
                        ),
                      )
                    ],
                    )
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            });
      },
    );
  }

  //build a list of users except for the currently logged in user.
  Widget _buildUserList() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }

          // This is the waiting stage to load data from firebase
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('');
          }

          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        },
      ),
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
