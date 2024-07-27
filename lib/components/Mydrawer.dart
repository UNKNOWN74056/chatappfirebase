import 'package:chat/services/Auth/Authservice.dart';
import 'package:chat/pages/Setting_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  logout(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Log out"),
              content: const Text("Are you sure you want to log out?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("No")),
                TextButton(
                    onPressed: () {
                      final auth = AuthService();
                      auth.signOut();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("You are log out")));
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Drawer header (you can customize this)
          DrawerHeader(
            child: Center(
                child: Icon(
              Icons.message,
              color: Theme.of(context).colorScheme.primary,
              size: 40,
            )),
          ),

          // List items (navigation options)
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: ListTile(
              leading: const Icon(
                Icons.home,
              ),
              title: const Text('H O M E'),
              onTap: () {
                Navigator.pop(context);
                // Handle navigation to home screen
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: ListTile(
              leading: const Icon(
                Icons.settings,
              ),
              title: const Text('S E T T I N G'),
              onTap: () {
                Navigator.pop(context);

                // Handle navigation to settings screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Setting()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: ListTile(
                leading: const Icon(
                  Icons.logout,
                ),
                title: const Text('L O G O U T'),
                onTap: () => logout(context)),
          ),
          // Add more list items as needed
        ],
      ),
    );
  }
}
