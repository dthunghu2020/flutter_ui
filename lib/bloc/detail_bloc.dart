import 'package:bloc/bloc.dart';
import 'package:learning_ui/bloc/detail_event.dart';
import 'package:learning_ui/bloc/detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc(DetailState initialState) : super(DetailInitial());

  @override
  Stream<DetailState> mapEventToState(DetailEvent event) async* {
    if (event is EditingNameEvent) {
      yield DetailEditing(event.name);
    } else if (event is SaveNameEvent) {
      yield DetailSavedName(event.name);
    }
  }
}
