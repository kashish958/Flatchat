import 'package:flutter/material.dart';
import 'Signup.dart';
import 'Auth.dart';
import 'Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'savinglocalsharepref.dart';
import 'chatroom.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(
MaterialApp(
home: Myapp()
)
  );



}


class Myapp extends StatefulWidget{


  @override
   State<StatefulWidget>createState(){
    return Myappstate();
  }
}
class Myappstate extends State<Myapp>{
 //bool userIsLoggedIn=false;
  @override
  void initState() {
   // getLoggedInState();
    super.initState();
  }


  @override
  Widget build(BuildContext context) => MaterialApp(
debugShowCheckedModeBanner: false,
        home: Scaffold(
        body:  StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, userSnapshot) {
                if (userSnapshot.hasData) {
                  return Home() ;
                }
                return Login();
              }),
        )



    );
}
