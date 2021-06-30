import 'package:flatchat/Auth.dart';
import 'package:flatchat/Login.dart';
import 'package:flatchat/Newsbloc.dart';
import 'package:flutter/material.dart';
import 'CameraScreen.dart';
import 'ChatScreen.dart';
import 'CallsScreen.dart';
import 'GroupScreen.dart';
import 'constants.dart';
import 'Searchsreen.dart';
import 'grplist.dart';
import 'savinglocalsharepref.dart';
import 'db.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'gc.dart';


import 'package:flutter/material.dart';

class Home extends StatefulWidget{


  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home>
    with SingleTickerProviderStateMixin {
  TabController  _tabController;
  // bool showFab = true;
  NewsBloc nb = NewsBloc();
  Authenti a = new Authenti();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, initialIndex: 1, length: 3);
   // nb.getNews("entertainment");
  }

  @override
  Widget build(BuildContext context) {
    //debugShowCheckedModeBanner: false,

    return Scaffold(
      //debugShowCheckedModeBanner: false,
     // home: Scaffold(

        appBar: AppBar(

          backgroundColor: Color(0xff075E54),
          title: Text("WhatsApp"),

          elevation: 0.7,
          bottom: new TabBar(controller: _tabController,
            indicatorColor: Colors.white,
            tabs: <Widget>[
             // new Tab(icon:new Icon(Icons.camera_alt) ,),
              new Tab(text:"CHATS",),
              new Tab(text:"GROUPS" ,),
              new Tab(text:"CALLS" ,),




            ],
          ),

          actions:<Widget> [
        IconButton( icon:
                    Icon(Icons.search),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Searchscreen()));
                    },
                  ),
      SizedBox(width: 20,),
      GestureDetector(
                    onTap: () {
                      a.signout();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Login() )
                      );

                    },
                    child: Icon(Icons.more_vert))
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
           // new CameraScreen(),
            new ChatScreen(),
            new GroupList(),

            new News()


          ],
        ),
        floatingActionButton :new FloatingActionButton(

          backgroundColor: Colors.green,
          child: new Icon(Icons.message,color: Colors.white,),
    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Gc()));
                    },
        ),
     // ),
    );
  }
}
























