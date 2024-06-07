// import 'dart:math';

import 'dart:io';

import 'package:chat_application/api/apis.dart';
import 'package:chat_application/helper/dialogs.dart';
import 'package:chat_application/main.dart';
import 'package:chat_application/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// LoginScreen -- Implements google sign in or sign up feature for app
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }


  // handles google login button click
  _handleGoogleBtnClick() {
    // For showing Progress Bar
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async{
    // For Hiding Progress Bar
      Navigator.pop(context);
      if(user != null){
         print('\nUser: ${user.user}');
         print('\nUserAditionalInfo: ${user.additionalUserInfo}');

         if((await Apis.userExists())){

          Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));

         }else {
          await Apis.createUser().then((value) {
            Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));

          });
         }

      
      }
     
    });
    
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try{
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await Apis.auth.signInWithCredential(credential);
    }catch(e){
      print('\n_signInWithGoogle: $e');
      Dialogs.showSnackbar(context, 'Something Went Wrong ( Please your Check Internet !)');
      return null;

    }
  }

  // Sign out funtion
  // _signOut() async {
  //   await FirebaseAuth.instance.signOut();
  //   await GoogleSignIn().signOut();

  // }

  @override
  Widget build(BuildContext context) {
    //initilizing media query (for getting device screen size)
    // mq = MediaQuery.of(context).size;

    return Scaffold(
      // app bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // title: const Text('Welcome to We Chat'),
      ),

      body: Stack(
        children: [
          AnimatedPositioned(
              top: mq.height * .15,
              right: _isAnimate ? mq.width * .25 : -mq.width * .5,
              width: mq.width * .5,
              duration: const Duration(seconds: 1),
              child: Image.asset('images/chat_icon.png')),

          // google login button
          Positioned(
              bottom: mq.height * .15,
              left: mq.width * .05,
              width: mq.width * .9,
              height: mq.height * .06,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue[200],
                      shape: const StadiumBorder(),
                      elevation: 1),
                  onPressed: () {
                    
                    _handleGoogleBtnClick();
                      _signInWithGoogle();
                    
                  },
                  // google icon
                  icon: Image.asset(
                    'images/gooogle.png',
                    height: mq.height * .03,
                  ),
                  // google label
                  label: RichText(
                      text: const TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          children: [
                        TextSpan(text: 'Login with '),
                        TextSpan(
                            text: 'Google',
                            style: TextStyle(fontWeight: FontWeight.w500))
                      ])))),
        ],
      ),
    );
  }
}
