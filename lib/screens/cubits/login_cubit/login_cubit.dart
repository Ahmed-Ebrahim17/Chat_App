import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginUser(
      {required String email, required String password}) async {
    emit(LoginLoading());
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
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
  }
}
