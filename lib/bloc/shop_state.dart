import 'package:hive/hive.dart';
import 'package:learning_ui/hive/item.dart';

class ShopState {}

class ShopInitial extends ShopState {
  List<Item> items;

  ShopInitial(this.items);
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

class ShopOpenDetailAnimation extends ShopState {
  int id;

  ShopOpenDetailAnimation(this.id);
}

class ShopCloseDetailAnimation extends ShopState {}

class ShopEditingDetailName extends ShopState {
  String name;

  ShopEditingDetailName(this.name);
}

class ShopSavedDetailName extends ShopState {
  String name;

  ShopSavedDetailName(this.name);
}

class ShopSearchName extends ShopState {
  List<Item> items;

  ShopSearchName(this.items);
}
