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
radius: 28,

                            backgroundImage: NetworkImage(
                               snapshot.data.docs[index]["URL"],


                              )

                          ),
                          title:
                           Row(
                             children: [

                               //  margin: EdgeInsets.only(right: ),
                                 GestureDetector(
                                   onTap: (){

                                       setState(() {
                                         Searchstate().createchatroomandtalk(context,
                                             userName: snapshot.data.docs[index]["field1"]
                                         );
                                       });

                                   }
                                   ,child: Text(snapshot.data.docs[index]["field1"] ,
                                          style: TextStyle(fontWeight: FontWeight.bold  ,color: Colors.black,fontSize: 18) ,  ),
                                 ) ,

Spacer(),
                               Container(
                                 margin: EdgeInsets.only(left: 145),
                                 child: Text(" ${snapshot.data.docs[index]["lasttime"].toDate().hour} :"
                                     "${snapshot.data.docs[index]["lasttime"].toDate().minute }" ,style : TextStyle(color:Colors.grey,fontSize: 14)),
                               )
                             ],
                           ),
                         subtitle: Container(
                             padding: EdgeInsets.only(left: 7),
                             child: Text(snapshot.data.docs[index]["lastmsg"])),

                        ),



                      ],
                    ) ;


                  })
              :
          CircularProgressIndicator();
        });
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

            body:

            showlist(),

    );
  }
}

