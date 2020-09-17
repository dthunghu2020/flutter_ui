import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:learning_ui/bloc/login_bloc.dart';
import 'package:learning_ui/bloc/login_event.dart';
import 'package:learning_ui/bloc/login_states.dart';
import 'package:learning_ui/hive/person.dart';
import 'package:learning_ui/main.dart';

import 'shop_screen.dart';

class LoginHome extends StatefulWidget {
  @override
  _LoginHomeState createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  String infor = '';
  bool vLoading = false;

  LoginBloc _loginBloc;

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passWordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(LoginInitial());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          maintainBottomViewPadding: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Stack(
              children: [
                //mau do
                _redBar(),
                //Button Xanh
                _buttonSignUp(),
                //Ham giua
                _bodyMain(),
                //Hinh anh
                _imageAvatar(),
                BlocConsumer(
                    cubit: _loginBloc,
                    listenWhen: (previous, current) =>
                        current is LoginLoading ||
                        current is LoginSuccess ||
                        current is LoginError ||
                        current is LoginCreateAccount,
                    listener: (context, state) {
                      if (state is LoginLoading) {
                        vLoading = true;
                      } else if (state is LoginSuccess) {
                        vLoading = false;
                        infor = state.name;
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => ShopScreen()));
                      } else if (state is LoginError) {
                        vLoading = false;
                        _toast('Login Error');
                      } else if (state is LoginCreateAccount) {
                        showDialog(
                            context: context,
                            builder: (context) => AddPerson());
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is LoginLoading ||
                        current is LoginSuccess ||
                        current is LoginError,
                    builder: (context, LoginStates state) {
                      return Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              infor,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Visibility(
                                visible: vLoading,
                                child: CircularProgressIndicator()),
                          ),
                        ],
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageAvatar() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.6),
        child: Container(
          width: MediaQuery.of(context).size.width / 4,
          height: MediaQuery.of(context).size.width / 4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Center(
              child: Icon(
            Icons.account_box,
            color: Colors.red,
            size: MediaQuery.of(context).size.width / 7,
          )),
        ),
      ),
    );
  }

  Widget _bodyMain() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.6,
        margin: EdgeInsets.only(left: 12, right: 12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: Container(
          margin: EdgeInsets.fromLTRB(30, 40, 30, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'UserName',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Email',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Password',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  controller: _passWordController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.06,
                child: FlatButton(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    _loginBloc.add(CreateAccountEvent());
                  },
                  child: Text(
                    'CREATE ACCOUNT',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonSignUp() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.75),
        child: Container(
          margin: EdgeInsets.only(left: 42, right: 42),
          height: MediaQuery.of(context).size.height * 0.06,
          child: FlatButton(
              color: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                _loginBloc.add(CheckLoginEvent(
                    userName: _userNameController.text,
                    passWord: _passWordController.text,
                    mail: _emailController.text));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Sign Up with FaceBook',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget _redBar() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          )),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}

class AddPerson extends StatefulWidget {
  @override
  _AddPersonState createState() => _AddPersonState();
}

class _AddPersonState extends State<AddPerson> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passWordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(0),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          width: MediaQuery.of(context).size.width * 0.86,
          height: MediaQuery.of(context).size.height * 0.56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  )),
              Text(
                'UserName',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 12),
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              Text(
                'Email',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 12),
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              Text(
                'Password',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 12),
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  obscureText: true,
                  controller: _passWordController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.06,
                child: FlatButton(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    var person = Person(_userNameController.text,
                        _emailController.text, _passWordController.text);
                    addPerson(person);
                    _toast('Create account');
                  },
                  child: Text(
                    'CREATE ACCOUNT',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addPerson(Person person) {
    Box<Person> personBox = Hive.box<Person>(personBoxName);
    personBox.add(person);
    Navigator.of(context).pop();
  }
}

void _toast(String title) {
  Fluttertoast.showToast(
      msg: title,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0);
}
