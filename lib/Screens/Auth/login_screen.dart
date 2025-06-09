import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/Consts/text_style.dart';
import 'package:heybuddy/Root/hey_buddy.dart';
import 'package:heybuddy/Screens/Auth/signup_screen.dart';
import 'package:heybuddy/Consts/colored_text.dart';
import 'package:stroke_text/stroke_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isObscure = true;
  bool isLogingin = false;

  void login() async {
    FocusScope.of(context).unfocus();
    bool isValid = formKey.currentState!.validate();

    if (isValid) {
      setState(() {
        isLogingin = true;
      });
      formKey.currentState!.save();

      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const Heybuddy(i: 0,),
          ));
        }
      } on FirebaseAuthException catch (error) {
        if (mounted) {
          setState(() {
            isLogingin = false;
          });
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(error.message!)));
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
          child: Column(
        children: [
          // App bar
          Container(
            width: double.infinity,
            height: 60,
            color: appBarColor,
            child: Row(
              children: [
                w10,
                Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                      color: Color(0xff61FF00), shape: BoxShape.circle),
                  child: Center(
                    child: Image.asset(
                      'assets/icons/heyBuddy.png',
                      width: 45,
                      height: 45,
                    ),
                  ),
                ),
                w10,
                coloredText(text1: 'Hey ', text2: 'Buddy', fontSize: 22)
              ],
            ),
          ),
          // h15,
          // h15,
          const Spacer(),
          Center(child: coloredText(text1: 'Log', text2: 'in', fontSize: 35.0)),
          h20,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: container,
              ),
              child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      // Enter email
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          cursorColor: bgColor,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: textField,
                              hintText: 'Enter email',
                              hintStyle: roboto(fontSize: 15),
                              errorStyle: const TextStyle(
                                  color: Colors.red, fontFamily: 'Roboto'),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              )),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email is required';
                            } else if (!value[0].contains(RegExp(r'[a-z]'))) {
                              return 'First letter must be in lowercase';
                            } else if (!value.contains('@')) {
                              return 'Email must contain "@"';
                            } else if (value.allMatches('@').length > 1) {
                              return 'Email must contain only 1 "@"';
                            } else if (!value.contains(
                                value.contains('.com') ? '.com' : '.in')) {
                              return 'Email must contain ".com" or ".in"';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (newValue) {
                            email = newValue.toString();
                          },
                        ),
                      ),
                      const Spacer(),
                      // Enter password
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          cursorColor: bgColor,
                          obscureText: isObscure,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: textField,
                              hintText: 'Enter password',
                              hintStyle: roboto(fontSize: 15),
                              errorStyle: const TextStyle(
                                  color: Colors.red, fontFamily: 'Roboto'),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                                icon: FaIcon(isObscure
                                    ? FontAwesomeIcons.solidEyeSlash
                                    : FontAwesomeIcons.solidEye),
                              )),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Password is required';
                            } else if (value.length < 6) {
                              return 'Password length must be greater than 5';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (newValue) {
                            password = newValue.toString();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7.0),
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forget password?',
                              style: roboto(fontSize: 12, color: white),
                            )),
                      ),
                      const Spacer(),
                      Center(
                        child: InkWell(
                          onTap: login,
                          child: Container(
                            width: 140,
                            height: 40,
                            decoration: BoxDecoration(
                                color: neonBlue,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: isLogingin
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: neonGreen,
                                      ))
                                  : StrokeText(
                                      text: 'Login',
                                      textStyle: jotiOne(
                                          color: neonGreen, fontSize: 25),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ));
                            },
                            child: Text(
                              "Don't have account?",
                              style: roboto(fontSize: 12, color: white),
                            )),
                      )
                    ],
                  )),
            ),
          ),
          const Spacer()
        ],
      )),
    );
  }
}
