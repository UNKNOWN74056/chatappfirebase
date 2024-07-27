import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final String? unreadmessages;
  final String? userId; // Add userId field
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.text,
    this.userId, // Add userId parameter
    required this.onTap,
    this.unreadmessages,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //  await ChatServices().resetUnreadCount(userId!);
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Align items to both ends
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24, // Adjust the avatar size as needed
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  text,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              padding:
                  const EdgeInsets.all(8.0), // Adjust the padding as needed
              decoration: const BoxDecoration(
                color: Colors.green, // Change to desired background color
                shape: BoxShape.circle,
              ),
              child: Text(
                unreadmessages ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Change text color as needed
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
