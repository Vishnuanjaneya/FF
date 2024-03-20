import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../api/apis.dart';
import '../home_screen.dart'; // Assuming correct path

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  Future<void> _handleGoogleBtnClick() async {
    try {
      final UserCredential? userCredential = await _signInWithGoogle();
      if (userCredential != null) {
        log('\nUser: ${userCredential.user}');
        log('\nUserAdditionalInfo: ${userCredential.additionalUserInfo}');
        if (await APIs.userExists()) {
          _navigateToHome();
        } else {
          await APIs.createUser().then((value) {
            _navigateToHome();
          });
        }
      }
    } catch (error) {
      print("Error signing in with Google: $error");
      // Handle error accordingly, show snackbar or dialog
    }
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      // Handle error, show snackbar or dialog
      return null;
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('🎉Welcome❤️'),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/FF.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            AnimatedPositioned(
              top: MediaQuery.of(context).size.height * 0.15,
              right: _isAnimate
                  ? MediaQuery.of(context).size.width * .25
                  : -MediaQuery.of(context).size.width * .5,
              width: MediaQuery.of(context).size.width * 0.5,
              duration: const Duration(seconds: 1),
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Image.asset('images/firebase_logo.png'),
              ),
            ),
            AnimatedPositioned(
              top: MediaQuery.of(context).size.height * 0.15 + 18,
              right: _isAnimate
                  ? MediaQuery.of(context).size.width * .25
                  : -MediaQuery.of(context).size.width * .5,
              width: MediaQuery.of(context).size.width * 0.5,
              duration: const Duration(seconds: 1),
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Transform.scale(
                  scale: 1.2,
                  child: Image.asset('images/flutter_logo.png'),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.15,
              left: MediaQuery.of(context).size.width * 0.05,
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.07,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 241, 199, 250),
                  shape: const StadiumBorder(),
                  elevation: 1,
                ),
                onPressed: _handleGoogleBtnClick,
                icon: Image.asset('images/google.png'),
                label: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Color.fromRGBO(121, 4, 153, 1),
                      fontSize: 16,
                    ),
                    children: [
                      const TextSpan(text: 'Log In with '),
                      const TextSpan(
                        text: 'Google',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.15,
              right: MediaQuery.of(context).size.width * 0.05,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
