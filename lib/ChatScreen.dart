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


    d.getConversationMessages(chatRoomId).then((value) async{
     // setState(() {
        chatMessagesStream = value;

     // });

        print(chatRoomId);
       // print("jbvsdh");

     // print(chatMessagesStream);
     await   showlastmsg();

    });



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

                            foregroundColor:Color(0xff075E54),
                            backgroundColor:Colors.grey ,
                            backgroundImage: NetworkImage(
                               snapshot.data.docs[index]["URL"],
                                //fit: BoxFit.fitWidth,
//height: 70,
                                //width: 50,
                              )

                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:<Widget>[

                                TextButton(onPressed: (){
                                  setState(() {
                                    Searchstate().createchatroomandtalk(context,
                                        userName: snapshot.data.docs[index]["field1"]
                                    );
                                  });
                                }, child: Text(snapshot.data.docs[index]["field1"] ,
                                  style: TextStyle(fontWeight: FontWeight.bold  ,color: Colors.black,fontSize: 18) ,  ) ),
                                Text("04:30" ,style : TextStyle(color:Colors.grey,fontSize: 14)),



                    ]
                          ),
                          subtitle: Text("heyy no msg since..",style:TextStyle(color:Colors.grey,fontSize: 15) ,),
                        ),



                      ],
                    ) ;

                    // Text(snapshot.data.docs[index]["chatroomid"].toString());

//                         Card(
//                           elevation: 10,
//                           margin: EdgeInsets.symmetric(vertical: 5, ),
//
//                           child: ExpansionTile(
//
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
// //                             children : [
// //
// //
// //                                           RaisedButton(
// //                                             onPressed:() {
// // setState(() {
// //   Searchstate().createchatroomandtalk( context,
// //       userName:snapshot.data.docs[index]["field1"]
// //   );
// // }
// // );
// //
// //
// //                                             },
// //                                             child: Icon(Icons.message),
// //                                           ),
// //
// //                             ]
//                           ),
//
//
//
//
//
//                         );
                  })
              : CircularProgressIndicator();
        });
  }

 Future<Widget> showlastmsg() {
    print("aeee");
 //   print(chatMessagesStream.length);


      StreamBuilder(

      stream: chatMessagesStream,
      builder: (context, snapshot) {
        print("dekho");
        print(snapshot.data);
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
            print(snapshot.data.docs[index]["message"]);
           // return Text(snapshot.data.docs[0]["message"]);
             // return Text(
               //   snapshot.data.docs[index]["message"],);
                  //snapshot.data.docs[index]["sendby"] == Constants.myName,
                 // snapshot.data.docs[index]["time"]);
            })
            :
        Container(
          child: Text("noodata"),
        );
      },
    );
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

