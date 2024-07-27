import 'package:chat/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatServices extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
//get all user
  Stream<List<Map<String, dynamic>>> getuserstream() {
    return _firestore.collection("user").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();

        return user;
      }).toList();
    });
  }

//getting all user excluding blocked once
  Stream<List<Map<String, dynamic>>> getuserexcludeblocked() {
    final curentuser = _auth.currentUser;
    return _firestore
        .collection("user")
        .snapshots()
        .asyncMap((usersnapshot) async {
      final blockedUsersSnapshot = await _firestore
          .collection("user")
          .doc(curentuser!.uid)
          .collection("blockeduser")
          .get();
      final blockedIds =
          blockedUsersSnapshot.docs.map((doc) => doc.id).toList();

      return usersnapshot.docs
          .where((doc) =>
              doc.data()['email'] != curentuser.email &&
              !blockedIds.contains(doc.id))
          .map((doc) => doc.data())
          .toList();
    });
  }

//to get user status
    Stream<DocumentSnapshot> getUserStatus(String userId) {
    return _firestore.collection('user').doc(userId).snapshots();
  }

//reset the unread count

  Future<void> resetUnreadCount(String userId) async {
    try {
      await _firestore.collection('user').doc(userId).update({
        'unreadCount': 0,
      });
    } catch (e) {
      print("Error updating unread count: $e");
    }
  }

//sending message to user
  Future<void> sendmessage(String reciverid, String message) async {
    final String currentuserid = _auth.currentUser!.uid;
    final String currentuseremail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    Message newmessage = Message(
      senderId: currentuserid,
      senderEmail: currentuseremail,
      receiverId: reciverid,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentuserid, reciverid];
    ids.sort();
    String chatrooms = ids.join('_');

    await _firestore
        .collection("chat_rooms")
        .doc(chatrooms)
        .collection("messages")
        .add(newmessage.toMap());

    // Check if the recipient is active in the chat
    DocumentSnapshot recipientSnapshot =
        await _firestore.collection('user').doc(reciverid).get();
    if (recipientSnapshot.exists) {
      Map<String, dynamic> recipientData =
          recipientSnapshot.data() as Map<String, dynamic>;
      if (recipientData['activeChat'] != currentuserid) {
        // Increment the unread message count
        await _firestore
            .collection("user")
            .doc(currentuserid)
            .update({"unreadCount": FieldValue.increment(1)});
      }
    }
  }


//gettting all the messages of user
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  //reporting the user
  Future<void> report(String messageid, String userid) async {
    final curentuser = _auth.currentUser;
    final report = {
      'reportedby': curentuser!.uid,
      'messageid': messageid,
      'messageownerid': userid,
      'timstamp': FieldValue.serverTimestamp()
    };
    await _firestore.collection("report").add(report);
  }
  //block the user

  Future<void> blockuser(String userid) async {
    final curentuser = _auth.currentUser;
    await _firestore
        .collection("user")
        .doc(curentuser!.uid)
        .collection("blockeduser")
        .doc(userid)
        .set({});
    notifyListeners();
  }

  //unblock user
  Future<void> unblock(String blockuserid) async {
    final curentuser = _auth.currentUser;
    await _firestore
        .collection("user")
        .doc(curentuser!.uid)
        .collection("blockeduser")
        .doc(blockuserid)
        .delete();
  }

  //get blocked user stream
  Stream<List<Map<String, dynamic>>> getblockeduserstream(String userid) {
    return _firestore
        .collection("user")
        .doc(userid)
        .collection("blockeduser")
        .snapshots()
        .asyncMap((snapshot) async {
      final blockeduderid = snapshot.docs.map((doc) => doc.id).toList();
      final userdoc = await Future.wait(blockeduderid
          .map((id) => _firestore.collection("user").doc(id).get()));

      return userdoc.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
