import 'package:chat/services/Auth/Authservice.dart';
import 'package:chat/components/My_button.dart';
import 'package:chat/components/text_field.dart';
import 'package:flutter/material.dart';

class register_page extends StatelessWidget {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController Passwordcontroller = TextEditingController();
  TextEditingController confermPasswordcontroller = TextEditingController();
  void Function()? onTap;
  register_page({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    void register() async {
      final auth = AuthService();
      if (confermPasswordcontroller.text == Passwordcontroller.text) {
        try {
          auth.signUpWithEmailAndPassword(emailcontroller.text,
              Passwordcontroller.text, namecontroller.text);
        } catch (e) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(e.toString()),
                  ));
        }
      } else {
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text("password dont match"),
                ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Registration"),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.message,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
              Text(
                "Lets create an account for you",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(
                height: 25,
              ),
              textfield_widget(
                hinttext: "Name",
                obsecuretext: false,
                controller: namecontroller,
              ),
              const SizedBox(
                height: 10,
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
                height: 10,
              ),
              textfield_widget(
                hinttext: "confirm Password",
                obsecuretext: true,
                controller: confermPasswordcontroller,
              ),
              const SizedBox(
                height: 25,
              ),
              MyButton(text: "Register", onTap: register),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Allready have account? ",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "Login Now",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
