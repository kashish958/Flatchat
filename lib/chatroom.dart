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

    _tabController = TabController(vsync: this, initialIndex: 1, length: 4);
    nb.getNews("entertainment");
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //debugShowCheckedModeBanner: false,
     // home: Scaffold(
drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      DrawerHeader(
        child: Text("Categories"),
        decoration: BoxDecoration(color: Colors.black26),
      ),
      ListTile(
        title: Text("Entertainment"),
        leading: Image.network(
            'https://images.unsplash.com/photo-1522869635100-9f4c5e86aa37?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1500&q=80'),
        onTap: () {
          nb.getNews("entertainment");
          nb.eventinput.add(newsaction.fetch);
        },
      ),
      SizedBox(height: 30),
      ListTile(
        title: Text("Technology"),
        leading: Image.network(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_rbqRlg_dukeGDrtkk3R5Lfb_wsjjxd7how&usqp=CAU"),
        onTap: () {
          nb.getNews("science");
          nb.eventinput.add(newsaction.fetch);
        },
      ),
      SizedBox(height: 30),
      ListTile(
        title: Text("Sports"),
        leading: Image.network(
            "https://images.unsplash.com/photo-1495563923587-bdc4282494d0?ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80"),
        onTap: () {
          nb.getNews("sports");
          nb.eventinput.add(newsaction.fetch);
        },
      ),
      SizedBox(height: 30),
      ListTile(
        title: Text("Business"),
        leading: Image.network(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHxTjm-GuQ-mmukBwfTlD7a_Lvy8nvQtKG9g&usqp=CAU"),
        onTap: () {
          nb.getNews("business");
          nb.eventinput.add(newsaction.fetch);
        },
      ),
      SizedBox(height: 30),
      ListTile(
        title: Text("Political"),
        leading: Image.asset("assets/pol.jpg"),
        onTap: () {
          nb.getNews("politics");
          nb.eventinput.add(newsaction.fetch);
        },
      ),
      SizedBox(height: 30),
      ListTile(
        title: Text("Health"),
        leading: Image.network(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXmC4RxEvjJD-ynTIKXfDT5EJTF_tyLfd-WQ&usqp=CAU"),
        onTap: () {
          nb.getNews("health");
          nb.eventinput.add(newsaction.fetch);
        },
      ),
    ],
  ),
),
        appBar: AppBar(

          backgroundColor: Color(0xff075E54),
          title: Text("FlatChat"),

          elevation: 0.7,
          bottom: new TabBar(controller: _tabController,
            indicatorColor: Colors.white,
            tabs: <Widget>[
              new Tab(icon:new Icon(Icons.camera_alt) ,),
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
                    child: Icon(Icons.exit_to_app))
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            new CameraScreen(),
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

























// class Home extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return Homestate();
//   }
// }
//
// class Homestate extends State<Home> {
//   Authenti a = new Authenti();
//   DB d = new DB();
//
//
//
//
//   Widget showlist() {
//    return StreamBuilder(
//         stream: FirebaseFirestore.instance.collection("Userss").snapshots(),
//         builder: (context, snapshot) {
//           return snapshot.hasData
//               ? ListView.builder(
//                   itemCount: snapshot.data.docs.length,
//                   //   shrinkWrap: true,
//                   itemBuilder: (context, index) {
//
//                     return // Text(snapshot.data.docs[index]["chatroomid"].toString());
//
//                         Card(
//                           elevation: 10,
//                           margin: EdgeInsets.symmetric(vertical: 10, ),
//
//                           child: ExpansionTile(
//                           //  child : SizedBox(height: 20,),
//                               title : Text(snapshot.data.docs[index]["field1"]),
//
//                             leading:
//                                Image.network(
//                                snapshot.data.docs[index]["URL"],
//                                 fit: BoxFit.fitWidth,
// height: 70,
//                                 width: 50,
//                               ),
//
//                          // leading :Text(snapshot.data.docs[index]["field2"]),
//
//                             children : [
//
//
//                                           RaisedButton(
//                                             onPressed:() {
// setState(() {
//   Searchstate().createchatroomandtalk( context,
//       userName:snapshot.data.docs[index]["field1"]
//   );
// }
// );
//
//
//                                             },
//                                             child: Icon(Icons.message),
//                                           ),
//
//                             ]
//                           ),
//
//
//
//
//
//                         );
//                   })
//               : CircularProgressIndicator();
//         });
//   }
//
//
//   @override
//   void initState() {
//     getUserInfo();
//
//     super.initState();
//   }
//
//   getUserInfo() async {
//     Constants.myName = await HelperFunctions.getUserNameSharedPreference();
//
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//             appBar: AppBar(
//               title: Text("Your Contacts"),
//               backgroundColor: Colors.black,
//               actions: [
//                 GestureDetector(
//                     onTap: () {
//                       a.signout();
//                       Navigator.pushReplacement(context,
//                           MaterialPageRoute(builder: (context) => Login() )
//                       );
//
//                     },
//                     child: Icon(Icons.exit_to_app))
//               ],
//             ),
//
//             floatingActionButton: Container(
//
//               margin: EdgeInsets.only(top: 390),
//               child: Column(
//
//
//
//                 children: [
//
//                    FloatingActionButton(
//
//                     onPressed:(){
//                         Navigator.push(context,
//                           MaterialPageRoute(builder: (context) => GroupList()));
//
//                     }, child: Row(
//                     children: [
//                       Icon(Icons.arrow_forward_ios_rounded,size: 20, ),
//                       Text("Grps")
//                     ],
//                   ),
//                   ),
//
// SizedBox(height: 100,),
//                   FloatingActionButton(
//                     child: Icon(Icons.group_add),
//                     onPressed: () {
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (context) => Gc()));
//                     },
//                   ),
//
//
//                   FloatingActionButton(
//                     child: Icon(Icons.search),
//                     onPressed: () {
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (context) => Searchscreen()));
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             body: showlist(),
//
//
//
//         )
//     );
//   }
// }

