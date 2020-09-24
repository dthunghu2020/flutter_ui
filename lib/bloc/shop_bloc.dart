import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:learning_ui/bloc/shop_event.dart';
import 'package:learning_ui/bloc/shop_state.dart';
import 'package:learning_ui/hive/item.dart';
import 'package:learning_ui/main.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  ShopBloc(ShopState initialState) : super(initialState);

  @override
  Stream<ShopState> mapEventToState(ShopEvent event) async* {
    if (event is GoToDetailEvent) {
      bool existData = false;
      for (int i = 0; i < Hive.box<Item>(itemBoxName).values.length; i++) {
        if (Hive.box<Item>(itemBoxName).getAt(i).id == event.id) {
          existData = true;
          break;
        }
      }
      if (existData) {
        yield ShopGoToDetailSuccess(event.id);
      } else {
        yield ShopGoToDetailError();
      }
    } else if (event is LoadingDataEvent) {
      yield ShopLoading();
      await Future.delayed(Duration(seconds: 3));
      yield ShopInitial(Hive.box<Item>(itemBoxName).values.toList());
    } else if (event is UpdateDataEvent) {
      yield ShopUpdateItem(Hive.box<Item>(itemBoxName).getAt(event.id).name);
    } else if (event is OpenDetailAnimationEvent) {
      yield ShopOpenDetailAnimation(event.id);
    } else if (event is CloseDetailAnimationEvent) {
      yield ShopCloseDetailAnimation();
    } else if (event is EditingDetailNameEvent) {
      yield ShopEditingDetailName(event.name);
    } else if (event is SaveDetailNameEvent) {
      Item item = Hive.box<Item>(itemBoxName).getAt(event.id);
      item.name = event.name;
      Hive.box<Item>(itemBoxName).put(event.id, item);
      yield ShopSavedDetailName(event.name);
    }else if(event is SearchNameEvent){
      List<Item> items = Hive.box<Item>(itemBoxName).values.toList().where((item) {
        return item.name.toLowerCase().contains(event.value);
      }).toList();
      yield ShopSearchName(items);
    }
  }
}
