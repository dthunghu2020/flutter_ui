import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:learning_ui/bloc/detail_event.dart';
import 'package:learning_ui/bloc/detail_state.dart';
import 'package:learning_ui/hive/item.dart';
import 'package:learning_ui/main.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  Box<Item> itemBox = Hive.box<Item>(itemBoxName);
  DetailBloc(DetailState initialState) : super(DetailInitial());

  @override
  Stream<DetailState> mapEventToState(DetailEvent event) async* {
    if (event is EditingNameEvent) {
      yield DetailEditing(event.name);
    } else if (event is SaveNameEvent) {
      itemBox.getAt(event.id).name = event.name;
      yield DetailSavedName(event.name);
    }
  }
}
