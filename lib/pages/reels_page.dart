import 'package:flutter/material.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {

  final List<String> videos = [
    '/assets/videos/short1.mp4',
    '/assets/videos/short2.mp4',
    '/assets/videos/short3.mp4'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reels Page"),),
    );
  }
}