import 'package:crik/providers/login_provider.dart';
import 'package:crik/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' as FlutterSvg;
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final loginProvider = LoginProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                FlutterSvg.SvgPicture.asset(
                  "assets/images/welcome.svg",
                  width: 200,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "One stop cricket news destination",
                  style: TextStyle(
                      fontFamily: "Poppins", fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      loginProvider.signInWithGoogle(context: context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlutterSvg.SvgPicture.asset(
                          'assets/images/google.svg',
                          width: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Sign in with google',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 55.0),
                  child: Text(
                    "By creating an account, I accept, Crik's \n Terms of Service & Privacy Policy",
                    style: TextStyle(fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
