import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:random_a_v/services/shared_prefrences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late bool? isLogin;
  void _getLoggedInState() async {
    // await Helper.saveUserloggedInSharedPreference(false);

    final login = await Helper.getUserLoggedInSharedPreference();
    final userId = await Helper.getUsernameSharedPreference();
    print(userId);
    setState(() {
      isLogin = login;
    });
  }

  @override
  void initState() {
    super.initState();
    _getLoggedInState();

    Timer(const Duration(seconds: 3), () {
      if (isLogin != null && isLogin == true) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/signup');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.pink,
          size: 50.0,
        ),
      ),
    );
  }
}
