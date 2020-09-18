import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:learning_ui/bloc/shop_event.dart';
import 'package:learning_ui/bloc/shop_state.dart';
import 'package:learning_ui/hive/item.dart';
import 'package:learning_ui/main.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  Box<Item> itemBox = Hive.box<Item>(itemBoxName);

  ShopBloc(ShopState initialState) : super(initialState);

  @override
  Stream<ShopState> mapEventToState(ShopEvent event) async* {
    if (event is GoToDetailEvent) {
      bool existData = false;
      for (int i = 0; i < itemBox.values.length; i++) {
        if (itemBox.getAt(i).id == event.id) {
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
      yield ShopInitial(itemBox);
    }
  }
}
