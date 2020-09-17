import 'package:hive/hive.dart';
part 'person.g.dart';

@HiveType(typeId: 0)
class Person {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(3)
  String pass;

  Person(this.name, this.email, this.pass);
}
