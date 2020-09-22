import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:learning_ui/bloc/api_bloc.dart';
import 'package:learning_ui/bloc/api_state.dart';
import 'package:learning_ui/bloc/detail_bloc.dart';
import 'package:learning_ui/bloc/detail_state.dart';
import 'package:learning_ui/bloc/shop_bloc.dart';
import 'package:learning_ui/bloc/shop_event.dart';
import 'package:learning_ui/bloc/shop_state.dart';
import 'package:learning_ui/hive/item.dart';
import 'package:learning_ui/view/detail_screen.dart';
import 'package:learning_ui/view/test_api_screen.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  ShopBloc _shopBloc;
  Box<Item> _itemBox;

  List _valNames = ['population', 'hot', 'new', 'normal'];
  String _dropVal, _itemName;
  bool _loadingVisible = false;
  bool _showAnimation = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _shopBloc = BlocProvider.of<ShopBloc>(context);
    _shopBloc.add(LoadingDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.pink[200],
          leading: GestureDetector(
            onTap: () {
              Fluttertoast.showToast(
                  msg: "menu",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => ApiBloc(ApiInitial()),
                      child: TestApiScreen(),
                    ),
                  ));
            },
            child: Icon(
              Icons.menu,
              color: Colors.black,
            ),
          ),
          centerTitle: false,
          title: Text(
            'elab.in',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Fluttertoast.showToast(
                    msg: "shop cart",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
              child: Icon(
                Icons.add_shopping_cart,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        body: SafeArea(
            child: BlocConsumer(
          cubit: _shopBloc,
          listenWhen: (previous, current) => current is ShopUpdateAnimation,
          listener: (context, state) {
            if (state is ShopUpdateAnimation) {
              _showAnimation = state.showAnimation;
            }
          },
          buildWhen: (previous, current) => current is ShopUpdateAnimation,
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    _search(),
                    _title(),
                    _searchTool(),
                    _listItem(),
                  ],
                ),
                _floatButton(),
                _widgetAnimation(),
              ],
            );
          },
        )),
      ),
    );
  }

  Widget _floatButton() => Container(
        margin: EdgeInsets.only(right: 10),
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          onPressed: () {
           _shopBloc.add(UpdateAnimationEvent(!_showAnimation));
          },
          child: Icon(Icons.add),
        ),
      );

  Widget _widgetAnimation() => AnimatedPositioned(
        duration: Duration(milliseconds: 400),
        top: _showAnimation
            ? MediaQuery.of(context).size.height * 0.08
            : MediaQuery.of(context).size.height,
        child: Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.topRight,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.8,
          color: Colors.blueGrey,
          child: GestureDetector(
              onTap: () {
                _shopBloc.add(UpdateAnimationEvent(!_showAnimation));
              },
              child: Icon(Icons.close)),
        ),
      );

  Widget _search() => Container(
        alignment: Alignment.topCenter,
        color: Colors.pink[200],
        height: MediaQuery.of(context).size.height * 0.08,
        child: Container(
          margin: EdgeInsets.only(left: 20, top: 4, right: 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.046,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    color: Colors.black45,
                    offset: Offset(0, 3),
                    spreadRadius: 1,
                    blurRadius: 2)
              ]),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Search'),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: "Search",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 1),
                            blurRadius: 1,
                            spreadRadius: 1,
                          )
                        ]),
                    child: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _title() => Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.08,
        child: Text(
          'Man\'s Fashion > T-Shirt',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _searchTool() => Row(
        children: [
          Expanded(
            flex: 6,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height * 0.036,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.2),
                    borderRadius: BorderRadius.circular(4)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    style: TextStyle(fontSize: 12, color: Colors.black),
                    hint: Text('Select'),
                    value: _dropVal,
                    onChanged: (value) {
                      setState(() {
                        _dropVal = value;
                      });
                    },
                    items: _valNames
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Row(
                children: [
                  Icon(Icons.filter_list),
                  Text('Filter'),
                ],
              ),
            ),
          ),
          Expanded(
              flex: 1, child: Center(child: Icon(Icons.picture_in_picture_alt)))
        ],
      );

  Widget _listItem() => Expanded(
        child: BlocConsumer(
          cubit: _shopBloc,
          listenWhen: (previous, current) =>
              current is ShopLoading ||
              current is ShopInitial ||
              current is ShopGoToDetailSuccess ||
              current is ShopGoToDetailError,
          listener: (context, state) async {
            if (state is ShopLoading) {
              _loadingVisible = true;
            } else if (state is ShopInitial) {
              _loadingVisible = false;
              _itemBox = state.itemBox;
            } else if (state is ShopGoToDetailSuccess) {
              Fluttertoast.showToast(
                  msg: "Item ${state.id} clicked ",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0);
              bool _result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlocProvider(
                          create: (context) => DetailBloc(DetailInitial()),
                          child: DetailScreen(idItem: state.id))));
              if (_result) {
                _shopBloc.add(UpdateDataEvent(state.id));
              }
            } else if (state is ShopGoToDetailError) {
              Fluttertoast.showToast(
                  msg: "Error",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          },
          buildWhen: (previous, current) =>
              current is ShopLoading || current is ShopInitial,
          builder: (context, state) {
            if (_itemBox != null) {
              return Container(
                margin: EdgeInsets.only(top: 10),
                child: GridView.count(
                  childAspectRatio: ((MediaQuery.of(context).size.width / 2) /
                      (MediaQuery.of(context).size.height * 0.34)),
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  children: _itemBox.values
                      .map((item) => GestureDetector(
                            onTap: () {
                              _shopBloc.add(GoToDetailEvent(item.id));
                            },
                            child: BlocConsumer(
                              cubit: _shopBloc,
                              listenWhen: (previous, current) =>
                                  current is ShopUpdateItem,
                              listener: (context, state) {
                                if (state is ShopUpdateItem) {
                                  _itemName = state.name;
                                }
                              },
                              buildWhen: (previous, current) =>
                                  current is ShopUpdateItem,
                              builder: (context, state) => Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    //hình ảnh
                                    Expanded(
                                      flex: 8,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Image(
                                          image: AssetImage(item.image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    //tên
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: Text(
                                          _itemName = item.name,
                                          style: TextStyle(fontSize: 12.6),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    //tiền
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        width: double.infinity,
                                        child: Text(
                                          item.cost,
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    //bottom
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Icon(
                                                Icons.star,
                                                size: 18,
                                                color: Colors.orangeAccent,
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Icon(
                                                Icons.star,
                                                size: 18,
                                                color: Colors.orangeAccent,
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Icon(
                                                Icons.star,
                                                size: 18,
                                                color: Colors.orangeAccent,
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Icon(
                                                Icons.star,
                                                size: 18,
                                                color: Colors.orangeAccent,
                                              )),
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(),
                                          ),
                                          Expanded(
                                              flex: 5,
                                              child: GestureDetector(
                                                onTap: () {
                                                  var x = item.id;
                                                  Fluttertoast.showToast(
                                                      msg: "Add $x",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.grey,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Add to cart',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.red),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey,
                                                            blurRadius: 1,
                                                            offset:
                                                                Offset(0, 1))
                                                      ]),
                                                ),
                                              )),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              );
            } else {
              return Align(
                  alignment: Alignment.center,
                  child: Visibility(
                      visible: _loadingVisible,
                      child: CircularProgressIndicator()));
            }
          },
        ),
      );
}
