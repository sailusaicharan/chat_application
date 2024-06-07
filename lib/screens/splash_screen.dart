import 'package:chat_application/api/apis.dart';
import 'package:chat_application/main.dart';
import 'package:chat_application/screens/auth/login_screen.dart';
import 'package:chat_application/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:chat_application/screens/home_screen.dart';
// import 'package:chat_application/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Splash Screen -- Implements google sign in or sign up feature for app
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
// bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      //exit full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(systemNavigationBarColor: Colors.white));

      if (Apis.auth.currentUser != null) {
           print('\nUser: ${FirebaseAuth.instance.currentUser}');
          
        //navigate to Home screen
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            ));
      } else {
        //navigate to Login screen
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //initilizing media query (for getting device screen size)
    mq = MediaQuery.of(context).size;

    return Scaffold(
      // app bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome to We Chat'),
      ),

      body: Stack(
        children: [
          Positioned(
              top: mq.height * .15,
              right: mq.width * .25,
              width: mq.width * .5,
              child: Image.asset('images/chat_icon.png')),

          // google login button
          Positioned(
              bottom: mq.height * .15,
              width: mq.width,
              child: const Text(
                'Made In India 🌞',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20, color: Colors.orange, letterSpacing: .5),
              )),
        ],
      ),
    );
  }
}
