
import 'package:hive/hive.dart';
part 'item.g.dart';

@HiveType(typeId: 1)
class Item{
  @HiveField(0)
  int id;

  @HiveField(1)
  String image;

  @HiveField(2)
  String name;

  @HiveField(3)
  String cost;

  @HiveField(4)
  List<String> size;

  Item(this.id, this.image, this.name, this.cost, this.size);
}