import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/cubits/register_cubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/show _snackBar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class RegisterScreen extends StatelessWidget {
  String? email;

  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is Registerloading) {
          isLoading = true;
        } else if (state is RegisterSuccess) {
          showSnackBar(context, state.msg, Colors.green);
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
          isLoading = false;
        } else if (state is RegisterFailure) {
          showSnackBar(context, state.errorMessage, Colors.red);
          isLoading = false;
        }
      },
      builder: (context, state) {
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
                          prefix: const Icon(
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
                          prefix: const Icon(
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
                          prefix: const Icon(
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
                          prefix: const Icon(
                            Icons.lock_outline,
                            size: 18,
                            color: Color.fromARGB(255, 10, 6, 6),
                          ),
                          labeltext: "Password",
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        CustomButon(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              BlocProvider.of<RegisterCubit>(context)
                                  .createUser(
                                      email: email!, password: password!);
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
                                child: const Text(
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
      },
    );
  }
}
