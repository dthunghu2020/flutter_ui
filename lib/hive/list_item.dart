
import 'package:hive/hive.dart';
import 'package:learning_ui/hive/item.dart';
part 'list_item.g.dart';

@HiveType(typeId: 2)
class ListItem {
  @HiveField(0)
  List<Item> items;

  ListItem(this.items);
}