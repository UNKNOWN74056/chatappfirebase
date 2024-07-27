import 'package:chat/services/Auth/Authservice.dart';
import 'package:chat/components/My_button.dart';
import 'package:chat/components/text_field.dart';
import 'package:flutter/material.dart';

class Login_page extends StatelessWidget {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController Passwordcontroller = TextEditingController();
  void Function()? onTap;

  Login_page({super.key, required this.onTap});
  void login(BuildContext context) async {
    final authservice = AuthService();
    try {
      await authservice.signInWithEmailAndPassword(
          emailcontroller.text, Passwordcontroller.text,);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Login"),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
          Text(
            "Welcom back , you have been missed",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(
            height: 25,
          ),
          textfield_widget(
            hinttext: "Email",
            obsecuretext: false,
            controller: emailcontroller,
          ),
          const SizedBox(
            height: 10,
          ),
          textfield_widget(
            hinttext: "Password",
            obsecuretext: true,
            controller: Passwordcontroller,
          ),
          const SizedBox(
            height: 25,
          ),
          MyButton(text: "Login", onTap: () => login(context)),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Not a member? ",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  "Register Now",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}
