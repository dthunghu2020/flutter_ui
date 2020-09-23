import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_ui/api/movie_api_provider.dart';
import 'package:learning_ui/hive/item.dart';
import 'package:learning_ui/hive/list_item.dart';
import 'package:learning_ui/hive/person.dart';
import 'package:learning_ui/model/model_movie.dart';
import 'package:learning_ui/my_setting.dart';
import 'package:learning_ui/view/login_screen.dart';
import 'package:random_string/random_string.dart';

const personBoxName = 'persons';
const itemBoxName = 'items';
const listItemBoxName = 'list_items';
const listItem = 'item_data';
const double fontSize = 12;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Person>(PersonAdapter());
  Hive.registerAdapter<ListItem>(ListItemAdapter());
  await Hive.openBox<Person>(personBoxName);
  await Hive.openBox<ListItem>(listItemBoxName);
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
  List<Item> _items = List();
  Random random = Random();
  List<String> sizes = ['xxl', 'xl', 'x', 's', 'xs'];
  for (int i = 0; i < 8; i++) {
    int min = random.nextInt(2);
    int max = random.nextInt(4);
    int cost = random.nextInt(10);
    List<String> size = [];
    for (int i = 0; i < sizes.length; i++) {
      if(i>=min&&i<=max){
        size.add(sizes[i]);
      }
    }
    _items.add(Item(
        i,
        "assets/Ao${(i + 1)}.jpg",
        "${randomAlpha(10)} shop ${randomAlpha(cost)}",
        "\$${cost * 20}",
        size));
  }
  ListItem _listItem = ListItem(_items);
  Hive.box<ListItem>(itemBoxName).put(listItem, _listItem);
}
