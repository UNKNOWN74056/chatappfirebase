import 'package:flutter/material.dart';

class textfield_widget extends StatelessWidget {
  final String hinttext;
  final bool obsecuretext;
  final TextEditingController controller;
  final FocusNode? focusNode;
  const textfield_widget(
      {super.key,
      required this.hinttext,
      required this.obsecuretext,
      required this.controller,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: TextField(
          focusNode: focusNode,
          controller: controller,
          obscureText: obsecuretext,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.tertiary)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.tertiary)),
            fillColor: Theme.of(context).colorScheme.secondary,
            filled: true,
            hintText: hinttext,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ));
  }
}
