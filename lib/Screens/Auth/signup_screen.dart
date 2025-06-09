import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/Consts/text_style.dart';
import 'package:heybuddy/Screens/Auth/login_screen.dart';
import 'package:heybuddy/Consts/colored_text.dart';
import 'package:stroke_text/stroke_text.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String fName = '';
  String lName = '';
  String password = '';
  bool isObscure1 = true;
  bool isObscure2 = true;
  bool isSigningup = false;
  String gender = 'Male';
  String date = 'Date of Birth';
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
  }

  void datePicker() async {
    final pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime(1950),
        lastDate: DateTime(DateTime.now().year - 15));
    DateTime dt = DateTime.now();
    // date
    final day = dt.day < 10 ? '0${dt.day}' : '${dt.day}';
    final month = dt.month < 10 ? '0${dt.month}' : '${dt.month}';

    if (pickedDate != null) {
      setState(() {
        date = '$day/$month/${dt.year}';
      });
    }
  }

  void signup() async {
    FocusScope.of(context).unfocus();
    bool isValid = formKey.currentState!.validate();

    if (isValid && date != 'Date of Birth') {
      formKey.currentState!.save();
      setState(() {
        isSigningup = true;
      });
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        await FirebaseFirestore.instance
            .collection('userData')
            .doc(credential.user!.uid)
            .set({
          'DOB': date,
          'accountType': 'Public',
          'chatNotification': [],
          'coverImg': '',
          'disLikedPosts': [],
          'disLikedVideos': [],
          'emailId': email,
          'name': '$fName $lName',
          'friendList': [],
          'gender': gender,
          'image': '',
          'isActive': '',
          'likedPosts': [],
          'likedVideos': [],
          'myPosts': [],
          'myVideo': [],
          'notification': [],
          'othersRequest': [],
          'yourRequest': [],
          'token': '',
        });
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ));
        }
      } on FirebaseAuthException catch (error) {
        if (mounted) {
          setState(() {
            isSigningup = false;
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
  void dispose() {
    passwordController.dispose();
    
    super.dispose();
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
          h15,
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                          child: coloredText(
                              text1: 'Sign', text2: 'up', fontSize: 35.0)),
                      h20,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          width: double.infinity,
                          height: 500,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: container,
                          ),
                          child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  const Spacer(),
                                  // First name and gender
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      w10,
                                      // First name
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                10,
                                        child: TextFormField(
                                          textCapitalization:
                                              TextCapitalization.words,
                                          cursorColor: bgColor,
                                          decoration: InputDecoration(
                                              filled: true,
                                              fillColor: textField,
                                              hintText: 'Enter first name',
                                              hintStyle: roboto(fontSize: 15),
                                              errorStyle: const TextStyle(
                                                  color: Colors.red,
                                                  fontFamily: 'Roboto'),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 0),
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              )),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'First name is required';
                                            } else if (value.length < 3) {
                                              return 'Name length must be greater than 2';
                                            } else {
                                              return null;
                                            }
                                          },
                                          onSaved: (newValue) {
                                            fName = newValue.toString();
                                          },
                                        ),
                                      ),
                                      const Spacer(),
                                      // Gender
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    3 +
                                                10,
                                        height: 48,
                                        decoration: BoxDecoration(
                                            color: textField,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                          child: DropdownButton(
                                            value: gender,
                                            items: const [
                                              DropdownMenuItem(
                                                value: 'Male',
                                                child: Text('Male'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'Female',
                                                child: Text('Female'),
                                              )
                                            ],
                                            onChanged: (value) => setState(() {
                                              gender = value!;
                                            }),
                                          ),
                                        ),
                                      ),
                                      w10
                                    ],
                                  ),
                                  const Spacer(),
                                  // Last name and DOB
                                  Row(
                                    children: [
                                      w10,
                                      // Last name
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                10,
                                        child: TextFormField(
                                          cursorColor: bgColor,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          decoration: InputDecoration(
                                              filled: true,
                                              fillColor: textField,
                                              hintText: 'Enter last name',
                                              hintStyle: roboto(fontSize: 15),
                                              errorStyle: const TextStyle(
                                                  color: Colors.red,
                                                  fontFamily: 'Roboto'),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 0),
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              )),
                                          validator: (value) {
                                            return null;
                                          },
                                          onSaved: (newValue) {
                                            lName = newValue.toString();
                                          },
                                        ),
                                      ),
                                      const Spacer(),
                                      // DOB
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    3 +
                                                10,
                                        height: 48,
                                        decoration: BoxDecoration(
                                            color: textField,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                            child: TextButton.icon(
                                          onPressed: datePicker,
                                          label: Text(
                                            date,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: date == 'Date of Birth'
                                                    ? Colors.red
                                                    : Colors.purple),
                                          ),
                                          icon:
                                              const Icon(Icons.calendar_month),
                                        )),
                                      ),
                                      w10
                                    ],
                                  ),
                                  const Spacer(),
                                  // Email
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      cursorColor: bgColor,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: textField,
                                          hintText: 'Enter email',
                                          hintStyle: roboto(fontSize: 15),
                                          errorStyle: const TextStyle(
                                              color: Colors.red,
                                              fontFamily: 'Roboto'),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 0),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          )),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Email is required';
                                        } else if (!value[0]
                                            .contains(RegExp(r'[a-z]'))) {
                                          return 'First letter must be in lowercase';
                                        } else if (!value.contains('@')) {
                                          return 'Email must contain "@"';
                                        } else if (value
                                                .allMatches('@')
                                                .length >
                                            1) {
                                          return 'Email must contain only 1 "@"';
                                        } else if (!value.contains(
                                            value.contains('.com')
                                                ? '.com'
                                                : '.in')) {
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: TextFormField(
                                      controller: passwordController,
                                      cursorColor: bgColor,
                                      obscureText: isObscure1,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: textField,
                                          hintText: 'Enter password',
                                          hintStyle: roboto(fontSize: 15),
                                          errorStyle: const TextStyle(
                                              color: Colors.red,
                                              fontFamily: 'Roboto'),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 0),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isObscure1 = !isObscure1;
                                              });
                                            },
                                            icon: FaIcon(isObscure1
                                                ? FontAwesomeIcons.solidEye
                                                : FontAwesomeIcons
                                                    .solidEyeSlash),
                                          )),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
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
                                  const Spacer(),
                                  // Confirm password
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: TextFormField(
                                      cursorColor: bgColor,
                                      obscureText: isObscure2,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: textField,
                                          hintText: 'Enter password',
                                          hintStyle: roboto(fontSize: 15),
                                          errorStyle: const TextStyle(
                                              color: Colors.red,
                                              fontFamily: 'Roboto'),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 0),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isObscure2 = !isObscure2;
                                              });
                                            },
                                            icon: FaIcon(isObscure2
                                                ? FontAwesomeIcons.solidEye
                                                : FontAwesomeIcons
                                                    .solidEyeSlash),
                                          )),
                                      validator: (value) {
                                        if (value != passwordController.text) {
                                          return 'Password does not match';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (newValue) {
                                        password = newValue.toString();
                                      },
                                    ),
                                  ),
                                  const Spacer(),
                                  Center(
                                    child: InkWell(
                                      onTap: signup,
                                      child: Container(
                                        width: 140,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: neonBlue,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                          child: isSigningup
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: neonGreen,
                                                  ))
                                              : StrokeText(
                                                  text: 'Signup',
                                                  textStyle: jotiOne(
                                                      color: neonGreen,
                                                      fontSize: 25),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen(),
                                          ));
                                        },
                                        child: Text(
                                          "Don't have account?",
                                          style: roboto(
                                              fontSize: 12, color: white),
                                        )),
                                  )
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
