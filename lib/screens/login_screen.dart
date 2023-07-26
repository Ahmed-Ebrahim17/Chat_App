import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../features/blocs/auth_bloc/auth_bloc.dart';
import '../features/blocs/auth_bloc/auth_event.dart';
import '../features/blocs/auth_bloc/auth_state.dart';
import '../helper/show _snackBar.dart';
import '../widgets/custom_textfield.dart';
import 'cubits/chat_cubit/chat_cubit.dart';

// ignore: must_be_immutable

class LoginScreen extends StatelessWidget {
  String? email;

  String? password;

  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          BlocProvider.of<ChatCubit>(context).getMessage();
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
        } else if (state is LoginFailure) {
          showSnackBar(context, state.errorMessage, Colors.red);
          isLoading = false;
        }
      },
      builder: (context, state) => ModalProgressHUD(
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
                            child:
                                Image.asset('assets/Person.jpg', width: 100)),
                        const SizedBox(
                          height: 30,
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
                            color: Colors.black,
                          ),
                          labeltext: "Password",
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        CustomButon(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              BlocProvider.of<AuthBloc>(context).add(AuthLogin(
                                  email: email!, password: password!));
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
                                child: const Text(
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
      ),
    );
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
