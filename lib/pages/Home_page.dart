import 'package:chat/components/Mydrawer.dart';
import 'package:chat/components/usertile.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/services/Auth/Authservice.dart';
import 'package:chat/services/chatservices/chat_services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({
    super.key,
  });

  final chatservice = ChatServices();
  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text('U S E R S'), // Customize the app bar title
      ),
      drawer: const MyDrawer(),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatservice.getuserexcludeblocked(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("ERROR"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No users available."));
          }
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userdata) => _buildUserListItem(userdata, context))
                .toList(),
          );
        },
      ),
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userdata, BuildContext context) {
    if (userdata['email'] != auth.currentuser()?.email) {
      return UserTile(
        userId: userdata['uid'],
        unreadmessages: userdata['unreadCount'].toString(),
        text: userdata['name'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => chat_page(
                recivername: userdata['name'],
                reciveremail: userdata["email"],
                reciverid: userdata['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
