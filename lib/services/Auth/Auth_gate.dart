import 'package:chat/services/Auth/login_or_registration.dart';
import 'package:chat/pages/Home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth_gate extends StatelessWidget {
  const Auth_gate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, Snapshot) {
          if (Snapshot.hasData) {
            return  HomePage();
          } else {
            return const login_or_register();
          }
        },
      ),
    );
  }
}
