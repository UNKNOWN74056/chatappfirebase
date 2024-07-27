import 'package:chat/components/chat_bubble.dart';
import 'package:chat/components/text_field.dart';
import 'package:chat/services/Auth/Authservice.dart';
import 'package:chat/services/chatservices/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class chat_page extends StatefulWidget {
  final String recivername;
  final String reciveremail;
  final String reciverid;
  const chat_page(
      {super.key,
      required this.reciveremail,
      required this.reciverid,
      required this.recivername});

  @override
  State<chat_page> createState() => _chat_pageState();
}

class _chat_pageState extends State<chat_page> {
  final TextEditingController messagecontorller = TextEditingController();

  final AuthService _auth = AuthService();
  final auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final ChatServices _chatservice = ChatServices();

  FocusNode myfocusnode = FocusNode();

  @override
  void initState() {
    super.initState();
    ChatServices().resetUnreadCount(widget.reciverid);
    _setActiveChat(widget.reciverid);
    myfocusnode.addListener(() {
      if (myfocusnode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrolldown());
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () => scrolldown());
  }

  @override
  void dispose() {
    myfocusnode.dispose();
    messagecontorller.dispose();
    _setInactiveChat();
    // TODO: implement dispose
    super.dispose();
  }

  void _setActiveChat(String receiverId) {
    final String currentUserId = auth.currentUser!.uid;
    _firestore.collection('user').doc(currentUserId).update({
      'activeChat': receiverId,
    });
  }

  void _setInactiveChat() {
    final String currentUserId = auth.currentUser!.uid;
    _firestore.collection('user').doc(currentUserId).update({
      'activeChat': FieldValue.delete(),
    });
  }

  final ScrollController _scrollController = ScrollController();

  void scrolldown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  void sendmessage() async {
    if (messagecontorller.text.isNotEmpty) {
      await _chatservice.sendmessage(widget.reciverid, messagecontorller.text);
      messagecontorller.clear();
    }
    scrolldown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                widget.recivername,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: _chatservice.getUserStatus(widget.reciverid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const SizedBox(); // Hide if there's an error
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const SizedBox(); // Hide if document doesn't exist
                }

                final documentData =
                    snapshot.data!.data() as Map<String, dynamic>;

                if (!documentData.containsKey('activeChat')) {
                  return const SizedBox(); // Hide if field doesn't exist
                }

                bool isActive =
                    documentData['activeChat'] == auth.currentUser!.uid;
                return isActive
                    ? const Icon(Icons.circle, color: Colors.green, size: 14)
                    : const SizedBox(); // Hide if not active
              },
            ),
          ],
        ),
        actions: const [
          Icon(
            CupertinoIcons.phone,
            size: 30,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              CupertinoIcons.video_camera,
              size: 35,
            ),
          ),
        ],
      ),
      body: Column(
        children: [Expanded(child: _buildmessagelist()), builsuserinput()],
      ),
    );
  }

  Widget _buildmessagelist() {
    String senderid = _auth.currentuser()!.uid;
    return StreamBuilder(
        stream: _chatservice.getMessages(widget.reciverid, senderid),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("ERROR"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildusermessage(doc))
                .toList(), // Use toList() instead of tolist()
          );
        });
  }

  Widget _buildusermessage(QueryDocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderId'] == _auth.currentuser()!.uid;
    final alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          chat_bubble(
            text: data['message'],
            iscurrentuser: isCurrentUser,
            messageid: doc.id,
            userid: data['senderId'],
          ),
        ],
      ),
    );
  }

  Widget builsuserinput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Row(
        children: [
          Expanded(
              child: textfield_widget(
            focusNode: myfocusnode,
            obsecuretext: false,
            hinttext: 'send message',
            controller: messagecontorller,
          )),
          Container(
            margin: const EdgeInsets.only(right: 25),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            child: IconButton(
                onPressed: sendmessage,
                icon: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}
