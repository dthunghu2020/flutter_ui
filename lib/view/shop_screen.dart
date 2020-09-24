import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:hive/hive.dart';
import 'package:learning_ui/bloc/api_bloc.dart';
import 'package:learning_ui/bloc/api_state.dart';
import 'package:learning_ui/bloc/detail_bloc.dart';
import 'package:learning_ui/bloc/detail_state.dart';
import 'package:learning_ui/bloc/shop_bloc.dart';
import 'package:learning_ui/bloc/shop_event.dart';
import 'package:learning_ui/bloc/shop_state.dart';
import 'package:learning_ui/hive/item.dart';
import 'package:learning_ui/main.dart';
import 'package:learning_ui/view/detail_screen.dart';
import 'package:learning_ui/view/test_api_screen.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  ShopBloc _shopBloc;

  List<Item> _itemSearchList = List();

  List _valNames = ['population', 'hot', 'new', 'normal'];
  String _dropVal, _name;
  int _itemId;
  bool _loadingVisible = false;
  bool _showAnimation = false;
  bool _editingName = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _shopBloc = BlocProvider.of<ShopBloc>(context);
    _shopBloc.add(LoadingDataEvent());
    //_itemSearchList = _itemBox.get();
  }

  @override
  Widget build(BuildContext context) {
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
                toast('Menu');
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
                  toast('Shop Cart');
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
            child: Stack(
              children: [
                Column(
                  children: [
                    _search(),
                    _title(),
                    _searchTool(),
                    _listItem(),
                  ],
                ),
                _widgetAnimation(),
              ],
            ),
          ),
        ));
  }

  Widget _widgetAnimation() => BlocConsumer(
        cubit: _shopBloc,
        listenWhen: (previous, current) =>
            current is ShopOpenDetailAnimation ||
            current is ShopCloseDetailAnimation,
        listener: (context, state) {
          if (state is ShopOpenDetailAnimation) {
            _showAnimation = !_showAnimation;
            _itemId = state.id;
            _name =  Hive.box<Item>(itemBoxName).values.toList()[_itemId].name;
          } else if (state is ShopCloseDetailAnimation) {
            _showAnimation = !_showAnimation;
            _editingName = false;
          }
        },
        buildWhen: (previous, current) =>
            current is ShopOpenDetailAnimation ||
            current is ShopCloseDetailAnimation,
        builder: (context, state) {
          if (_itemId != null) {
            return AnimatedPositioned(
                duration: Duration(milliseconds: 400),
                top: _showAnimation
                    ? MediaQuery.of(context).size.height * 0.08
                    : MediaQuery.of(context).size.height,
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.8,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                            onTap: () {
                              _shopBloc.add(CloseDetailAnimationEvent());
                            },
                            child: Icon(Icons.close)),
                      ),
                      _image(),
                      _cost(),
                      _chooseSize(),
                      _detailName(),
                      _starChoose(),
                      SizedBox(
                        height: 30,
                      ),
                      _text(),
                      SizedBox(
                        height: 10,
                      ),
                      _comment(),
                      SizedBox(
                        height: 4,
                      ),
                      _button(),
                    ],
                  ),
                ));
          } else {
            return Container();
          }
        },
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
                    controller: _searchController,
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Search'),
                    onChanged: (value) {
                      value = value.toLowerCase();
                      _shopBloc.add(SearchNameEvent(value));
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                   toast('Search');
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
              current is ShopGoToDetailError ||
              current is ShopSearchName,
          listener: (context, state) async {
            if (state is ShopLoading) {
              _loadingVisible = true;
            } else if (state is ShopInitial) {
              _loadingVisible = false;
              _itemSearchList = state.items;
            } else if (state is ShopGoToDetailSuccess) {
              toast('Item ${state.id} clicked');
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
              toast('Error');
            } else if (state is ShopSearchName) {
              _itemSearchList = state.items;
            }
          },
          buildWhen: (previous, current) =>
              current is ShopLoading ||
              current is ShopInitial ||
              current is ShopSearchName,
          builder: (context, state) {
            if (_itemSearchList != null) {
              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: _itemSearchList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            //_shopBloc.add(GoToDetailEvent(item.id));
                            _shopBloc.add(OpenDetailAnimationEvent(
                                _itemSearchList[index].id));
                          },
                          child: BlocBuilder(
                            cubit: _shopBloc,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.4,
                                      child: Image(
                                        image: AssetImage(
                                            _itemSearchList[index].image),
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
                                        _itemSearchList[index].name,
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
                                        _itemSearchList[index].cost,
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
                                                var x =
                                                    _itemSearchList[index].id;
                                                toast('Add $x');
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
                                                          offset: Offset(0, 1))
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
                        );
                      },
                      /* childAspectRatio: ((MediaQuery.of(context).size.width / 2) /
                        (MediaQuery.of(context).size.height * 0.34)),
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    children: _itemBox.values
                        .map((item) => )
                        .toList(),*/
                    ),
                  ),
                  Visibility(
                      visible: _loadingVisible,
                      child: Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ))
                ],
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

  Widget _image() => Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.width * 0.4,
        child: Image.asset( Hive.box<Item>(itemBoxName).values.toList()[_itemId].image),
      );

  Widget _cost() => Text(
        Hive.box<Item>(itemBoxName).values.toList()[_itemId].cost,
        style: TextStyle(
            color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
      );

  Widget _chooseSize() => Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.04,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Product: Size Option',
              style: TextStyle(fontSize: fontSize),
            ),
            RadioButtonGroup(
                itemBuilder: (Radio rb, Text txt, int i) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: 30,
                        child: rb,
                      ),
                      txt,
                      SizedBox(
                        width: 1.2,
                      )
                    ],
                  );
                },
                labelStyle: TextStyle(
                  fontSize: fontSize,
                ),
                orientation: GroupedButtonsOrientation.HORIZONTAL,
                labels:  Hive.box<Item>(itemBoxName).values.toList()[_itemId].size),
          ],
        ),
      );

  Widget _detailName() => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        child: BlocConsumer(
          cubit: _shopBloc,
          listenWhen: (previous, current) =>
              current is ShopInitial ||
              current is ShopEditingDetailName ||
              current is ShopSavedDetailName,
          listener: (context, state) {
            if (state is ShopInitial) {
              _editingName = false;
            }
            if (state is ShopEditingDetailName) {
              _editingName = !_editingName;
              _nameController.text = _name;
            } else if (state is ShopSavedDetailName) {
              _editingName = !_editingName;
              _name = state.name;
            }
          },
          buildWhen: (previous, current) =>
              current is ShopEditingDetailName ||
              current is ShopSavedDetailName,
          builder: (context, state) => Stack(
            alignment: Alignment.center,
            children: [
              Visibility(
                visible: !_editingName,
                child: GestureDetector(
                  onTap: () {
                    _shopBloc.add(EditingDetailNameEvent(_name));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text(
                      _name,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _editingName,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: double.infinity,
                        child: TextField(
                          style: TextStyle(
                            fontSize: fontSize,
                          ),
                          maxLines: 2,
                          controller: _nameController,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.width * 0.1,
                        child: RaisedButton(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              _shopBloc.add(SaveDetailNameEvent(
                                  _nameController.text ?? '', _itemId));
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _starChoose() => Container(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height * 0.026,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: Icon(
                  Icons.star,
                  size: 20,
                  color: Colors.orangeAccent,
                )),
            Expanded(
                flex: 1,
                child: Icon(
                  Icons.star,
                  size: 20,
                  color: Colors.orangeAccent,
                )),
            Expanded(
                flex: 1,
                child: Icon(
                  Icons.star,
                  size: 20,
                  color: Colors.orangeAccent,
                )),
            Expanded(
                flex: 1,
                child: Icon(
                  Icons.star,
                  size: 20,
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
                  toast('Add to Cart');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Add to cart',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 1,
                              offset: Offset(0, 1))
                        ]),
                  ),
                )),
          ],
        ),
      );

  Widget _text() => Container(
        padding: EdgeInsets.only(left: 20),
        width: MediaQuery.of(context).size.width,
        child: Text('Ask question about this Product'),
      );

  Widget _comment() => Container(
        height: MediaQuery.of(context).size.height * 0.1,
        margin: EdgeInsets.symmetric(horizontal: 40),
        child: TextField(
          maxLines: 2,
          style: TextStyle(fontSize: 12.6),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget _button() => Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () {
            toast('Ask');
          },
          child: Container(
            margin: EdgeInsets.only(right: 40, bottom: 10),
            height: MediaQuery.of(context).size.height * 0.03,
            width: MediaQuery.of(context).size.width * 0.2,
            alignment: Alignment.center,
            child: Text(
              'Ask',
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 1, offset: Offset(0, 1))
                ]),
          ),
        ),
      );
}
