import 'package:flutter/material.dart';
import 'package:random_a_v/screens/chatroom_screen.dart';
import 'package:random_a_v/screens/find_friend.dart';
import 'package:random_a_v/screens/friend_request.dart';
import 'package:random_a_v/screens/friends_screen.dart';
import 'package:random_a_v/screens/home_screen.dart';
import 'package:random_a_v/screens/mailbox_screen.dart';
import 'package:random_a_v/screens/profile_screen.dart';
import 'package:random_a_v/screens/settings_Screen.dart';
import 'package:random_a_v/screens/signup_screen.dart';
import 'package:random_a_v/screens/splash_screen.dart';

Map<String, WidgetBuilder> routes = {
  '/': (context) => const SplashScreen(),
  '/signup': (context) => const SignUp(),
  '/home': (context) => const HomeScreen(),
  '/profile': (context) => const Profile(),
  '/findfriend': (context) => const FindFriendScreen(),
  '/mailbox': (context) => const MailBox(),
  '/chat': (context) => const Chat(),
  '/friends': (context) => const FriendScreen(),
  '/settings': (context) => const SettingScreen(),
  '/friendrequest': (context) => const FriendRequestsScreen(),
};
