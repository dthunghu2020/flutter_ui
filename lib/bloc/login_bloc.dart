import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:learning_ui/bloc/login_event.dart';
import 'package:learning_ui/bloc/login_states.dart';
import 'package:learning_ui/hive/person.dart';
import 'package:learning_ui/main.dart';
import 'package:learning_ui/my_setting.dart';

class LoginBloc extends Bloc<LoginEvent, LoginStates> {
  LoginBloc(LoginStates initialState) : super(initialState);

  @override
  Stream<LoginStates> mapEventToState(LoginEvent event) async* {
    if (event is CheckLoginEvent) {
      //type check (0-EmptyText,1-Success,2-Error);
      int typeCheck;
      yield LoginLoading();
      await Future.delayed(Duration(seconds: 2));
      if (event.userName == '' || event.mail == '' || event.passWord == '') {
        typeCheck = 0;
      } else {Hive.box<Person>(personBoxName).values.toList().forEach((person) {
        print('??-${event.userName}');
        if (person.name == event.userName &&
            person.email == event.mail &&
            person.pass == event.passWord) {
          typeCheck = 1;
        } else {
          typeCheck = 2;
        }
      });}

      switch (typeCheck) {
        case 0:
          yield LoginEmpty();
          break;

        case 1:
          MySetting().setLogged(true);
          yield LoginSuccess(name: "Success");
          break;

        case 2:
        default:
          yield LoginError();
          break;
      }
    } else if (event is CreateAccountEvent) {
      yield LoginCreateAccount();
    }
  }
}
