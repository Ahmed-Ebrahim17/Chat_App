part of 'register_cubit.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class Registerloading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  String msg;
  RegisterSuccess({required this.msg});
}

class RegisterFailure extends RegisterState {
  String errorMessage;
  RegisterFailure({required this.errorMessage});
}
