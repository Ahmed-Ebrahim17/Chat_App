import 'package:bloc/bloc.dart';
import 'package:chat_app/features/blocs/auth_bloc/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
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

  Future<void> createUser(
      {required String email, required String password}) async {
    emit(Registerloading());
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(
        RegisterSuccess(
          msg: 'Successful',
        ),
      );
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'weak-password') {
        emit(
          RegisterFailure(errorMessage: 'The password provided is too weak.'),
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

  @override
  void onChange(Change<AuthState> change) {
    // TODO: implement onChange
    super.onChange(change);
    print(change);
  }
}
