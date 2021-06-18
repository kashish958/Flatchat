
import 'package:flatchat/Login.dart';
import 'package:flatchat/Signup.dart';
import 'package:flutter/material.dart';


class Authenticate extends StatefulWidget {

  @override
  State<StatefulWidget>createState(){
    return Authenticatestate();
  }
}

class Authenticatestate extends State<Authenticate> {
bool showlogin = true;
void toggle(){
  setState(() {
    showlogin= !showlogin;
  });
}
@override
  Widget build(BuildContext context) {

if(showlogin)return Login();
else return Signup();

  }

}