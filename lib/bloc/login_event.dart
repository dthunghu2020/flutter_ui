class LoginEvent {}

class CheckLoginEvent extends LoginEvent {
  final String userName;
  final String mail;
  final String passWord;

  CheckLoginEvent({this.userName, this.mail, this.passWord});
}

class CreateAccountEvent extends LoginEvent{}
