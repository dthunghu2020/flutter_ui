import 'package:hive/hive.dart';
import 'package:learning_ui/hive/item.dart';

class ShopState {}

class ShopInitial extends ShopState {
  Box<Item> itemBox;

  ShopInitial(this.itemBox);
}

class ShopLoading extends ShopState {}

class ShopGoToDetailSuccess extends ShopState {
  int id;

  ShopGoToDetailSuccess(this.id);
}

class ShopGoToDetailError extends ShopState {}
class ShopUpdateItem extends ShopState {
  String name;

  ShopUpdateItem(this.name);
}
