import 'dart:ui';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flatchat/Auth.dart';
import 'package:flatchat/Login.dart';
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

class ChatScreen extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return ChatScreenstate();
  }
}

class ChatScreenstate extends State<ChatScreen> {
  Authenti a = new Authenti();
  DB d = new DB();

Stream   chatMessagesStream;


  String chatRoomId;
//ChatScreen(this.chatRoomId);

  getchatroomidformsg(String val) {
    chatRoomId=val;



  }



  Widget showlist() {
   return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Userss").snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  //   shrinkWrap: true,
                  itemBuilder: (context, index) {

                    return Column(
                      children: <Widget>[
                        Divider(
                          height: 10,
                        ),
                        ListTile(
                          leading: CircleAvatar(

                            // foregroundColor:Color(0xff075E54),
                            // backgroundColor:Colors.grey ,
                            backgroundImage: NetworkImage(
                               snapshot.data.docs[index]["URL"],
                                //fit: BoxFit.fitWidth,
//height: 70,
                                //width: 50,
                              )

                          ),
                          title:
                           TextButton(onPressed: (){
                                  setState(() {
                                    Searchstate().createchatroomandtalk(context,
                                        userName: snapshot.data.docs[index]["field1"]
                                    );
                                  });
                                }, child: Text(snapshot.data.docs[index]["field1"] ,
                                  style: TextStyle(fontWeight: FontWeight.bold  ,color: Colors.black,fontSize: 18) ,  ) ),
                              //  Text("04:30" ,style : TextStyle(color:Colors.grey,fontSize: 14)),
                          subtitle:StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("ChatRoom").snapshots(),
                    builder: (context, snapshot) {
                      print(snapshot.data.docs[index]["lastmsg"].toString());
                      return Text(snapshot.data.docs[index]["lastmsg"].toString());
                    }
                          ) ,
                        ),



                      ],
                    ) ;


                  })
              : CircularProgressIndicator();
        });
  }

 Future<Widget> showlastmsg() {
    print("aeee");
 //   print(chatMessagesStream.length);



  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();

  }

  @override
  Widget build(BuildContext context) {
  //  return MaterialApp(
    //  debugShowCheckedModeBanner: false,
        return Scaffold(


        //    floatingActionButton: Container(

            //  margin: EdgeInsets.only(top: 390),
              // child: Column(
              //
              //
              //
              //   children: [
              //
              //      FloatingActionButton(
              //
              //       onPressed:(){
              //           Navigator.push(context,
              //             MaterialPageRoute(builder: (context) => GroupList()));

//                     }, child: Row(
//                     children: [
//                       Icon(Icons.arrow_forward_ios_rounded,size: 20, ),
//                       Text("Grps")
//                     ],
//                   ),
//                   ),
//
// SizedBox(height: 100,),
//                   // FloatingActionButton(
                  //   child: Icon(Icons.group_add),
                  //   onPressed: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => Gc()));
                  //   },
                  // ),

                  //
                  // FloatingActionButton(
                  //   child: Icon(Icons.search),
                  //   onPressed: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => Searchscreen()));
                  //   },
                  // ),
            //    ],
           //   ),
           // ),
            body:

            showlist(),
//show


        //)
    );
  }
}

