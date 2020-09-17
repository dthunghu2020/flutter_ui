import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:learning_ui/bloc/login_event.dart';
import 'package:learning_ui/bloc/login_states.dart';
import 'package:learning_ui/hive/person.dart';
import 'package:learning_ui/main.dart';

class LoginBloc extends Bloc<LoginEvent, LoginStates> {
  Box<Person> personBox = Hive.box<Person>(personBoxName);

  LoginBloc(LoginStates initialState) : super(initialState);

  @override
  Stream<LoginStates> mapEventToState(LoginEvent event) async* {

    if (event is CheckLoginEvent) {
      bool success = false;
      yield LoginLoading();
      await Future.delayed(Duration(seconds: 2));
      personBox.values.forEach((person) {
        if (person.name == event.userName &&
            person.email == event.mail &&
            person.pass == event.passWord) {
          success = true;
        } else {
          success = false;
        }
      });
      if (success == true) {
        yield LoginSuccess(name: "Success");
      } else {
        yield LoginError();
      }
    } else if (event is CreateAccountEvent) {
      yield LoginCreateAccount();
    }
  }
}
