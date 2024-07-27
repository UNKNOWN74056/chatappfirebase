import 'package:chat/components/usertile.dart';
import 'package:chat/services/Auth/Authservice.dart';
import 'package:chat/services/chatservices/chat_services.dart';
import 'package:flutter/material.dart';

class Blockeduser extends StatelessWidget {
  Blockeduser({super.key});

  final ChatServices chatservice = ChatServices();
  final AuthService authservic = AuthService();
  void _showunblockbox(BuildContext context, String userid) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Unblock User"),
              content:
                  const Text("Are you sure you want to unblock this user?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("No")),
                TextButton(
                    onPressed: () {
                      ChatServices().unblock(userid);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("user is Unblocked")));
                    },
                    child: const Text("UnBlock",
                        style: TextStyle(color: Colors.green))),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final currentuser = authservic.currentuser()!.uid;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Blocked users"),
        actions: const [],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: chatservice.getblockeduserstream(currentuser),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error loading..."),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final blockeduder = snapshot.data ?? [];

            if (blockeduder.isEmpty) {
              return const Center(
                child: Text("No user found"),
              );
            }
            return ListView.builder(
                itemCount: blockeduder.length,
                itemBuilder: (context, index) {
                  final user = blockeduder[index];

                  return UserTile(
                      text: user['email'],
                      onTap: () => _showunblockbox(context, user['uid']));
                });
          }),
    );
  }
}
