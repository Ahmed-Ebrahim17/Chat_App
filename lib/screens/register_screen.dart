import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/show _snackBar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? email;

  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

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
            'Register Screen',
            style: GoogleFonts.lato(color: Colors.black),
          ),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset('assets/Pic.jpg', width: 120)),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextField(
                      obscureText: false,
                      prefix: Icon(
                        Icons.person_outline,
                        size: 18,
                        color: Colors.black,
                      ),
                      labeltext: "Name",
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTextField(
                      obscureText: false,
                      prefix: Icon(
                        Icons.phone_outlined,
                        size: 18,
                        color: Colors.black,
                      ),
                      labeltext: "Phone",
                    ),
                    const SizedBox(
                      height: 8,
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
                        color: const Color.fromARGB(255, 10, 6, 6),
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
                            UserCredential user =
                                await createUser(email, password);
                            showSnackBar(context, "Successful", Colors.green);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ChatScreen(
                                    email: email!,
                                  );
                                },
                              ),
                              (route) => false,
                            );
                          } on FirebaseAuthException catch (ex) {
                            if (ex.code == 'weak-password') {
                              showSnackBar(
                                  context,
                                  'The password provided is too weak.',
                                  Colors.red);
                            } else if (ex.code == 'email-already-in-use') {
                              showSnackBar(
                                  context,
                                  'The account already exists for that email.',
                                  Colors.red);
                            }
                          }
                          isLoading = false;
                          setState(() {});
                        }
                      },
                      text: "Sign up",
                      color: 0XffE16B5A,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Have an account?'),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Log in',
                              style: TextStyle(color: Color(0XffE16B5A)),
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
    );
  }

  Future<UserCredential> createUser(String? email, String? password) async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
    return user;
  }
}
