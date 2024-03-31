import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trendcraft/model/message.dart';

class ChatService extends ChangeNotifier{

  //get the instances of auth and firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //SEND messages
  Future<void> sendMessage(String receiverId,String message) async{
    //get current user info
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(senderId: currentUserId, senderEmail: currentUserEmail, receiverId: receiverId, message: message, timestamp: timestamp);


    //construct chat room id from current user id and receiver id(sorted to ensure uniqueness)
    List<String> ids = [currentUserId,receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    //add new messages to database
    await _fireStore.collection('chat_room').doc(chatRoomId).collection('messages').add(newMessage.toMap());
  }

  //GET messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId){
    //construct chat room id from userid (sorted to ensure that it matches the id used when sending messages)
    List<String> ids = [userId,otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _fireStore.collection('chat_room').doc(chatRoomId).collection('messages').orderBy('timestamp',descending: false).snapshots();

  }

}