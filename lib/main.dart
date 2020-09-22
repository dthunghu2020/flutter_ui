import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_ui/api/movie_api_provider.dart';
import 'package:learning_ui/hive/item.dart';
import 'package:learning_ui/hive/person.dart';
import 'package:learning_ui/model/model_movie.dart';
import 'package:learning_ui/my_setting.dart';
import 'package:learning_ui/view/login_screen.dart';

const personBoxName = 'persons';
const itemBoxName = 'items';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Person>(PersonAdapter());
  Hive.registerAdapter<Item>(ItemAdapter());
  await Hive.openBox<Person>(personBoxName);
  await Hive.openBox<Item>(itemBoxName);
  if (!await MySetting().getFirstTime()) {
    MySetting().setFirstTime(true);
    addItemsData();
  }

  return runApp(MaterialApp(
    title: 'Login App',
    home: LoginHome(),
  ));
}

void addItemsData() {
  Box<Item> itemBox = Hive.box<Item>(itemBoxName);
  itemBox.add(Item(0, "assets/Ao1.jpg", "Basic-T-shirt-BlackT", "\$100",
      ['xl', 'x', 's', 'xs']));
  itemBox.add(Item(
      1,
      "assets/Ao2.jpg",
      "ao-phong-burberry-logo-print-cotton-t-shirt-mau-denAo2",
      "\$50",
      ['xxl', 'xl', 'x', 'xs']));
  itemBox.add(Item(
      2,
      "assets/Ao3.jpeg",
      "TheLuxeT-shirt OFFWhite đen xanh trời lưng",
      "\$120",
      ['xxl', 'xl', 'x', 's', 'xs']));
  itemBox.add(Item(3, "assets/Ao4.jpg", "colbertlateshow-com-t-shirt-7", "\$80",
      ['xl', 'x', 'xs']));
  itemBox.add(Item(
      4,
      "assets/Ao5.jpg",
      "ao-phong-dsquared2-64-twins-t-shirt-mau-den",
      "\$200",
      ['xxl', 'xl', 'x', 'xs']));
  itemBox.add(Item(5, "assets/Ao6.jpg", "tiedye-Ocean_1", "\$150",
      ['xxl', 'xl', 'x', 'xs']));
  itemBox.add(Item(6, "assets/Ao7.jpg", "T-SHIRT GRAPPHIC MICKEY ZARA", "\$180",
      ['xxl', 'xl', 'x', 'xs']));
  itemBox.add(Item(
      7,
      "assets/Ao8.jpg",
      "Mua Thrasher Magazine Flame Short Sleeve T-Shirt trên Amazon Mỹ chính hãng 2020 | Fado",
      "\$500",
      ['xxl', 'xl', 'x', 'xs']));
}
