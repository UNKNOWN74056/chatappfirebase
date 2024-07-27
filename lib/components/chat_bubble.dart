import 'package:chat/services/chatservices/chat_services.dart';
import 'package:chat/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class chat_bubble extends StatelessWidget {
  final String text;
  final bool iscurrentuser;
  final String messageid;
  final String userid;
  const chat_bubble(
      {super.key,
      required this.text,
      required this.iscurrentuser,
      required this.messageid,
      required this.userid});

  //option for to report
  void _showoption(BuildContext context, String messageid, String userid) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text("Report"),
                onTap: () {
                  Navigator.pop(context);
                  _reportcontent(context, messageid, userid);
                },
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text("Block"),
                onTap: () {
                  Navigator.pop(context);
                  _blocktheuser(context, userid);
                },
              ),
              ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text("Cancel"),
                  onTap: () => Navigator.pop(context)),
            ],
          ));
        });
  }

//report the message
  void _reportcontent(BuildContext context, String messageid, String userid) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Report Message"),
              content:
                  const Text("Are you sure your want to report this message?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("No")),
                TextButton(
                    onPressed: () {
                      ChatServices().report(messageid, userid);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Message Reported")));
                    },
                    child:
                        const Text("Yes", style: TextStyle(color: Colors.red))),
              ],
            ));
  }

  //block the user
  void _blocktheuser(BuildContext context, String userid) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Block User"),
              content: const Text("Are you sure your want to block this user?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("No")),
                TextButton(
                    onPressed: () {
                      ChatServices().blockuser(userid);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("user is blocked")));
                    },
                    child: const Text(
                      "Block",
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    bool isdarkmode =
        Provider.of<ThemeProvider>(context, listen: false).isdarkmode;

    return GestureDetector(
      onLongPress: () {
        if (!iscurrentuser) {
          _showoption(context, messageid, userid);
        } else {}
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        decoration: BoxDecoration(
            color: iscurrentuser
                ? (isdarkmode ? Colors.green.shade600 : Colors.green.shade500)
                : (isdarkmode ? Colors.grey.shade800 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12)),
        child: Text(
          text,
          style: TextStyle(
              color: iscurrentuser
                  ? Colors.white
                  : (isdarkmode ? Colors.white : Colors.black)),
        ),
      ),
    );
  }
}
