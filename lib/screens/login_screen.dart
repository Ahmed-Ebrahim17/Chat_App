import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/show _snackBar.dart';
import '../widgets/custom_textfield.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;

  String? password;

  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      opacity: 0.1,
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPriamryColor,
          centerTitle: true,
          title: Text(
            'Login Screen',
            style: GoogleFonts.lato(color: Colors.black),
          ),
        ),
        body: Form(
          key: formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                          alignment: Alignment.topCenter,
                          child: Image.asset('assets/Person.jpg', width: 100)),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomTextField(
                        obscureText: false,
                        onChanged: (data) {
                          email = data;
                        },
                        prefix: Icon(
                          Icons.email_outlined,
                          size: 18,
                          color: Colors.black,
                        ),
                        labeltext: "Email",
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextField(
                        obscureText: true,
                        onChanged: (data) {
                          password = data;
                        },
                        prefix: Icon(
                          Icons.lock_outline,
                          size: 18,
                          color: Colors.black,
                        ),
                        labeltext: "Password",
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      CustomButon(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            isLoading = true;
                            setState(() {});
                            try {
                              await loginUser();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return ChatScreen(
                                      email: email!,
                                    );
                                  },
                                ),
                                (route) => false,
                              );
                              showSnackBar(context, 'Successful', Colors.green);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                showSnackBar(
                                    context,
                                    'No user found for that email.',
                                    Colors.red);
                              } else if (e.code == 'wrong-password') {
                                showSnackBar(
                                    context,
                                    'Wrong password provided for that user.',
                                    Colors.red);
                              }
                            }
                            isLoading = false;
                            setState(() {});
                          }
                        },
                        text: 'Sign in',
                        color: 0XfF337180,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account?'),
                          TextButton(
                              onPressed: () {
                                Navigator.push(context, _CreateRoute());
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(color: Color(0XfF337180)),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}

Route _CreateRoute() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => RegisterScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, 1);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      });
}
