import 'package:flutter/material.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/themes/decorations.dart';

// A custom app bar with avatar, greeting and settings icon.

// Implements PreferredSizeWidget to ensure the app bar works with Scaffold.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Handle null user (loading state or not logged in)
  final User? user;

  static const double horizontalPadding = 20.0;
  static const double verticalPadding = 20.0;
  static const double _statusBarHeight = 40.0;
  // Method to get the greeting based on the time of day.
  String _getTimebasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  // Constructor
  const CustomAppBar({super.key, this.user});

  // preferredSize is a required getter to implement PreferredSizeWidget.
  @override
  Size get preferredSize => const Size.fromHeight(
    kToolbarHeight + verticalPadding * 2 + _statusBarHeight,
  );

  @override
  Widget build(BuildContext context) {
    final String userName = user?.name ?? '';
    final String userImageUrl =
        user?.imageUrl ??
        'https://media.wired.com/photos/5f87340d114b38fa1f8339f9/master/w_1280,c_limit/Ideas_Surprised_Pikachu_HD.jpg';

    return Container(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        verticalPadding + _statusBarHeight,
        horizontalPadding,
        verticalPadding,
      ),
      decoration: AppDecorations.bottomBorderedBoxDecoration(context),
      child: Row(
        children: [
          // Avatar - Use the user avatar url if provided, otherwise use the initials.
          CircleAvatar(
            radius: 26,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            backgroundImage: userImageUrl.isNotEmpty
                ? NetworkImage(userImageUrl)
                : null,
            child: userImageUrl.isEmpty
                ? Text(userName.isNotEmpty ? userName[0].toUpperCase() : 'U')
                : null,
          ),
          // Greeting
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: _getTimebasedGreeting()),
                  TextSpan(
                    text: userName.isNotEmpty ? ', $userName' : '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '!'),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Settings icon
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.settings),
            iconSize: 32,
            onPressed: () {
              // TODO: Open settings
              print('Open settings');
            },
          ),
        ],
      ),
    );
  }
}
