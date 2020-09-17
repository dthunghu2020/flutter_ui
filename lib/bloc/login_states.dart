import 'package:learning_ui/model/model_login.dart';

class LoginStates {}

class LoginInitial extends LoginStates {}

class LoginLoading extends LoginStates {}

class LoginSuccess extends LoginStates {
  String name;

  LoginSuccess({this.name});
}

class LoginError extends LoginStates {}

class LoginCreateAccount extends LoginStates{}
