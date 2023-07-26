import 'package:chat_app/features/blocs/auth_bloc/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthLogin) {
        emit(LoginLoading());
        try {
          final credential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: event.email, password: event.password);
          emit(
            LoginSuccess(
              msg: 'Successful',
            ),
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            emit(
              LoginFailure(errorMessage: 'User not found'),
            );
          } else if (e.code == 'wrong-password') {
            emit(
              LoginFailure(
                errorMessage: 'Wrong password',
              ),
            );
          }
        } catch (e) {
          emit(
            LoginFailure(
              errorMessage: 'Something went wrong',
            ),
          );
        }
      } else if (event is AuthRegister) {
        emit(Registerloading());
        try {
          final credential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: event.email, password: event.password);
          emit(
            RegisterSuccess(
              msg: 'Successful',
            ),
          );
        } on FirebaseAuthException catch (ex) {
          if (ex.code == 'weak-password') {
            emit(
              RegisterFailure(
                  errorMessage: 'The password provided is too weak.'),
            );
          } else if (ex.code == 'email-already-in-use') {
            emit(
              RegisterFailure(
                errorMessage: 'The account already exists for that email.',
              ),
            );
          }
        } catch (e) {
          emit(
            RegisterFailure(
              errorMessage: 'Something went wrong',
            ),
          );
        }
      }
    });
  }
  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
