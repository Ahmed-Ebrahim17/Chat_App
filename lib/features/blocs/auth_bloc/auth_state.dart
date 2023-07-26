abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  String msg;
  LoginSuccess({required this.msg});
}

class LoginFailure extends AuthState {
  String errorMessage;
  LoginFailure({required this.errorMessage});
}

class Registerloading extends AuthState {}

class RegisterSuccess extends AuthState {
  String msg;
  RegisterSuccess({required this.msg});
}

class RegisterFailure extends AuthState {
  String errorMessage;
  RegisterFailure({required this.errorMessage});
}
