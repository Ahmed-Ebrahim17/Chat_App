part of 'login_cubit.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  String msg;
  LoginSuccess({required this.msg});
}

class LoginFailure extends LoginState {
  String errorMessage;
  LoginFailure({required this.errorMessage});
}
