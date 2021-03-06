import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:hive/hive.dart';
import 'package:learning_ui/bloc/detail_bloc.dart';
import 'package:learning_ui/bloc/detail_event.dart';
import 'package:learning_ui/bloc/detail_state.dart';
import 'package:learning_ui/hive/item.dart';
import 'package:learning_ui/main.dart';

class DetailScreen extends StatefulWidget {
  int idItem;

  DetailScreen({Key key, this.idItem}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState(idItem);
}

class _DetailScreenState extends State<DetailScreen> {
  _DetailScreenState(this.idItem);

  Box<Item> items;
  DetailBloc _detailBloc;

  List _valNames = ['population', 'hot', 'new', 'normal'];
  List<Widget> _status = [];
  bool _editingName;
  bool _changed;
  double _fontSize = 12;
  int idItem;
  String _dropVal;
  String name = '';

  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _detailBloc = BlocProvider.of<DetailBloc>(context);
    items = Hive.box<Item>(itemBoxName);
    items.getAt(idItem).size.forEach((element) {
      _status.add(Text(
        element,
        style: TextStyle(fontSize: 12),
      ));
    });
    _nameController.text = items.getAt(idItem).name;
    _editingName = false;
    _changed = false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        _moveToLastScreen;
      },
      child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.pink[200],
              leading: GestureDetector(
                onTap: () {
                  _moveToLastScreen();
                },
                child: Icon(
                  Icons.arrow_back,
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
            body: SingleChildScrollView(
              child: SafeArea(
                  child: Column(
                children: [
                  _search(),
                  _title(),
                  _searchTool(),
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
              )),
            ),
          )),
    );
  }

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
        height: MediaQuery.of(context).size.height * 0.068,
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

  Widget _image() => Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.width * 0.4,
        child: Image.asset(items.getAt(idItem).image),
      );

  Widget _cost() => Text(
        items.getAt(idItem).cost,
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
              style: TextStyle(fontSize: _fontSize),
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
                  fontSize: _fontSize,
                ),
                orientation: GroupedButtonsOrientation.HORIZONTAL,
                labels: items.getAt(idItem).size),
          ],
        ),
      );

  Widget _detailName() => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        child: BlocConsumer(
          cubit: _detailBloc,
          listenWhen: (previous, current) =>
              current is DetailInitial ||
              current is DetailEditing ||
              current is DetailSavedName,
          listener: (context, state) {
            if (state is DetailInitial) {
              _editingName = false;
            }
            if (state is DetailEditing) {
              _editingName = !_editingName;
              name = state.name;
            } else if (state is DetailSavedName) {
              _editingName = !_editingName;
              name = state.name;
              _nameController.text = name;
            }
          },
          buildWhen: (previous, current) =>
              current is DetailEditing || current is DetailSavedName,
          builder: (context, state) => Stack(
            alignment: Alignment.center,
            children: [
              Visibility(
                visible: !_editingName,
                child: GestureDetector(
                  onTap: () {
                    _detailBloc.add(EditingNameEvent(name));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text(
                      items.getAt(idItem).name,
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
                            fontSize: _fontSize,
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
                              _changed = true;
                              _detailBloc.add(SaveNameEvent(
                                  _nameController.text ?? '', idItem));
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

  void _moveToLastScreen() {
    Navigator.pop(context,_changed);
    toast('Back');
  }
}
