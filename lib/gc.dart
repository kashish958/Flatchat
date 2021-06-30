import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Searchsreen.dart';
import 'constants.dart';
import 'db.dart';
import 'groupkibaat.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:get/get_navigation/src/snackbar/snack.dart';
import 'Login.dart';
import 'db.dart';
import 'savinglocalsharepref.dart';
import'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';


class Gc extends StatefulWidget {
  String gname;

  @override
  GcState createState() => GcState();
}

class GcState extends State<Gc> {
  DB d = DB();
 // TextEditingController gname = TextEditingController();

  List<String> temp = [];

  bool flag = false;

  Widget showlist() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Userss").snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  //   shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return

                    Column(

                        children: [
                    Divider(
                        height: 10,
                    ),
                          ListTile(
                            //  child : SizedBox(height: 20,),
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
                                Text(snapshot.data.docs[index]["field1" ]
                                  ,
                                    style: TextStyle(fontWeight: FontWeight.bold  ,color:temp.contains(snapshot.data.docs[index]["field1"])?Colors.green: Colors.black,fontSize: 18) ,  ),





                                ]
                            ),

                          //  title: Text(snapshot.data.docs[index]["field1"]),


                            // leading :Text(snapshot.data.docs[index]["field2"]),

                            trailing: RaisedButton(
                              onPressed: () {
                                setState(
                                        () {

                                  temp.add(snapshot.data.docs[index]["field1"]);

                                }
                                );
                              },
                              onLongPress: (){
                                print("pppp");
                                setState(() {
                                  temp.remove(snapshot.data.docs[index]["field1"]);

                                });
                                print("ff");
                              },
                              child: Icon(Icons.add),
                            ),


                          ),
                        ],
                  //    ),
                    );
                  }
                  )
              : CircularProgressIndicator();
        });
  }
  static var iurl;
  @override
  Future addimg(File pickedimg) async
  {
    String fileName = basename(pickedimg.path);
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('groupdp/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(pickedimg);
    TaskSnapshot taskSnapshot = await (await uploadTask);
    await taskSnapshot.ref.getDownloadURL().then(
            (value) {
          print("Done" +value);
          iurl = value;
        }
    );

    return iurl;
  }





  File imgfile;
  final picker = ImagePicker();
  static var url;

  Future chooseimg(ImageSource source) async {
    final pickedimage = await picker.getImage(source: source);

    setState(() {
      imgfile = File(pickedimage.path);
      print(imgfile.path);
    });
  }


  creategroupandtalk(BuildContext context, {String userName}) async{
    print("${userName}");

    if (userName == Constants.myName) {
      String groupRoomId =
          widget.gname; //getChatRoomId(userName, Constants.myName);
     // List<String> users = temp;
      Map<String, dynamic> groupRoomMap = {
        "users": FieldValue.arrayUnion(temp),
        "grouproomid": groupRoomId,
        "URL" :iurl,
      // FirebaseFirestore.instance.collection('Userss').doc(widget.userName).update({
      'lastmsg': "",
      "lasttime": DateTime.now(),
      // "name": widget.name,
      // });


      };



      print("ayaya");

  await   d.creategroup(groupRoomId, groupRoomMap);
      print("vdvvfdv");



    //   Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => Groupkibaat(groupRoomId,users)));



      // Navigator.push(context, MaterialPageRoute(builder: (context) => Conversation(chatRoomId,userName)
      //  ));
    } else {
      print("Dont text without you");
    }
  }

  // getlist ()async{
  //   return  await temp;
  // }
//
// sendgrMessage() {
//   if(messagecontroller.text.isNotEmpty)
//   {
//     Map<String, dynamic>messageMap = {
//       "message": messagecontroller.text,
//       "sendby":Constants.myName,
//       "time":DateTime.now().microsecondsSinceEpoch
//     };
//     d.addConversationMessages(widget.chatRoomId,messageMap);
//     messagecontroller.clear();
//   }
// }

  _displaygname(BuildContext context) async {

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(

            title: Row(
              children: [
                Text('Group Name'),
                IconButton(
                  icon: Icon(Icons.camera_alt_outlined ,size: 1,),
                  onPressed: () { chooseimg(ImageSource.camera);
                    // Navigator.of(context).pop();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.filter),
                  onPressed: () {
                    chooseimg(ImageSource.gallery);
                    //   Navigator.of(context).pop();
                  },
                )
              ],
            ),
            content: TextField(
             onChanged: (val){
              setState(() {
                widget.gname = val;

              });
             },

              decoration: InputDecoration(hintText: "Enter group name"),
            //  onChanged: () ,
            ) ,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.done_outline),
                  onPressed: () {
addimg(imgfile).then((value) {
  creategroupandtalk(context, userName: Constants.myName);
});

                    Navigator.of(context).pop();
                  })
            ],
          );
        });



  }

  void initState(){
    // initiateSearch();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("Select Members"),

        backgroundColor:Color(0xff075E54),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,

        child: Icon(Icons.group),
        onPressed: () {
          print("hh");
          print(temp);
          _displaygname(context);
        },
      ),
      body: showlist(),
    ));
  }
}
