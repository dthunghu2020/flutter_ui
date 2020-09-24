import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_ui/bloc/shop_bloc.dart';
import 'package:learning_ui/bloc/shop_state.dart';
import 'package:learning_ui/hive/item.dart';
import 'package:learning_ui/hive/person.dart';
import 'package:learning_ui/my_setting.dart';
import 'package:learning_ui/view/login_screen.dart';
import 'package:learning_ui/view/shop_screen.dart';
import 'package:random_string/random_string.dart';

const personBoxName = 'persons';
const itemBoxName = 'items';
const double fontSize = 12;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Person>(PersonAdapter());
  Hive.registerAdapter<Item>(ItemAdapter());
  await Hive.openBox<Person>(personBoxName);
  var box = await Hive.openBox<Item>(itemBoxName);
  /* if (!await MySetting().getFirstTime()) {
    MySetting().setFirstTime(true);
    _addItemsData();
  }*/
  _addItemsData(box);
  return runApp(MaterialApp(
    title: 'Login App',
    home: FutureBuilder(
      future: MySetting().getLogged(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data) {
            return BlocProvider(
                create: (context) => ShopBloc(ShopLoading()),
                child: ShopScreen());
          } else {
            return LoginHome();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    ),
  ));
}

void _addItemsData(Box<Item> box) {
  Random random = Random();
  List<String> sizes = ['xxl', 'xl', 'x', 's', 'xs'];
  for (int i = 0; i < 8; i++) {
    int min = random.nextInt(2);
    int max = random.nextInt(5);
    if (max <= min) {
      max = min + 1;
    }
    int cost = random.nextInt(20);
    List<String> size = [];
    for (int i = 0; i < sizes.length; i++) {
      if (i >= min && i <= max) {
        size.add(sizes[i]);
      }
    }
    Item  item = Item(
        i,
        "assets/Ao${(i + 1)}.jpg",
        "${randomAlpha(10)} shop ${randomAlpha(cost * 5)}",
        "\$${cost * 20}",
        size);

    //box.values.toList().add(item);
    box.put(i, item);

    print('$i - ${box.values.toList().length}');
  }
  print(box.values.toList().length);
}

void toast(String title) {
  Fluttertoast.showToast(
      msg: title,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0);
}
