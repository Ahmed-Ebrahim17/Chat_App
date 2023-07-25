import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
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
}
