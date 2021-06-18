import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flatchat/Searchsreen.dart';
import 'package:flatchat/Signup.dart';
import 'package:flatchat/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'Auth.dart';
import 'db.dart';
import 'package:path/path.dart';


class Conversation extends StatefulWidget {
  final String chatRoomId;
  final String userName;
  Conversation(this.chatRoomId, this.userName);
  @override
  State<StatefulWidget> createState() {
    return Conversationstate();
  }
}

class Conversationstate extends State<Conversation> {
  DB d = new DB();
  //QuerySnapshot snapshot;
  TextEditingController messagecontroller = new TextEditingController();
  File imgfile;
  final picker = ImagePicker();
  var iurl;
  Stream chatMessagesStream;
  Stream imgstream;

  QuerySnapshot t;
  bool hh = false;
  @override
  Widget ChatMessageList() {
  //  print("iuhuih");
//    print(chatMessagesStream.length);

    return StreamBuilder(

      stream: chatMessagesStream,
      builder: (context, snapshot) {
       print("fvf");
        print(snapshot.data);
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      snapshot.data.docs[index]["message"],
                      snapshot.data.docs[index]["sendby"] == Constants.myName,
                      snapshot.data.docs[index]["time"]);
                })
            : Container(
          child :CircularProgressIndicator()
        );
      },
    );
  }

  @override
  Widget ChatimageList() {
    return StreamBuilder(
        stream: imgstream,
        builder: (context, snapshot) {
          //if (snapshot.hasData)
          //  {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(
                          left: snapshot.data.docs[index]["sendby"] ==
                                  Constants.myName
                              ? 0
                              : 24,
                          right: snapshot.data.docs[index]["sendby"] ==
                                  Constants.myName
                              ? 24
                              : 0),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      alignment: snapshot.data.docs[index]["sendby"] ==
                              Constants.myName
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: snapshot.data.docs[index]["sendby"] ==
                                        Constants.myName
                                    ? [Colors.yellow, Colors.pinkAccent]
                                    : [Colors.blue, Colors.blueAccent]),
                            borderRadius: snapshot.data.docs[index]["sendby"] ==
                                    Constants.myName
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(23),
                                    topRight: Radius.circular(23),
                                    bottomLeft: Radius.circular(23))
                                : BorderRadius.only(
                                    topLeft: Radius.circular(23),
                                    topRight: Radius.circular(23),
                                    bottomLeft: Radius.circular(23))),
                        child: Image.network(
                          snapshot.data.docs[index]["imgurl"],
                          height: 110,
                        ),
                      ),
                    );

                    //Container(height : 50,width: 40 ,child: Image.network(snapshot.data.docs[index]["imgurl"]));//Image.network(iurl);
                    // ;//Tile(snapshot.data.docs[index]["message"],
                  })
              : Container(
                  height: 0,
                  width: 0,
                );
          //    }
        });
  }

  @override
  Future addimg(File pickedimg) async {
    String fileName = basename(pickedimg.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(pickedimg);
    TaskSnapshot taskSnapshot = await (await uploadTask);
    await taskSnapshot.ref.getDownloadURL().then((value) {
      print("Done" + value);
      iurl = value;
    });

    return iurl;
  }

  @override
  Future chooseimg(ImageSource source) async {
    final pickedimage = await picker.getImage(source: source);

    setState(() {
      imgfile = File(pickedimage.path);
      print(imgfile.path);
    });
  }

//for sending image
  sendimg(String ii) {
    print(ii);
    if (imgfile != null) {
      Map<String, dynamic> imgMap = {
        "imgurl": ii,
        "sendby": Constants.myName,
        "time": DateTime.now().toString()
      };
      d.addingimage(widget.chatRoomId, imgMap);
    }
  }

  sendMessage() {
    if (messagecontroller.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messagecontroller.text,
        "sendby": Constants.myName,
        "time": DateTime.now().toString()
      };
      d.addConversationMessages(widget.chatRoomId, messageMap);
      messagecontroller.clear();
    }
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Send Image"),
            actions: <Widget>[
              Row(
                children: [
                  FlatButton(
                    child: Icon(Icons.camera_alt_outlined),
                    onPressed: () {
                      chooseimg(ImageSource.camera);
                      // Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Icon(Icons.filter),
                    onPressed: () {
                      chooseimg(ImageSource.gallery);
                      //   Navigator.of(context).pop();
                    },
                  ),
                  IconButton(
                      icon: Icon(Icons.send_rounded),
                      onPressed: () {
                        addimg(imgfile).then((value) {
                          sendimg(value);

                          ChatimageList();
                        });
                        Navigator.of(context).pop();
                      })
                ],
              ),
            ],
          );
        });
  }

  //for fetching user dpimage//
//   getuserimgvianame()async{
//
//    //  return await  FirebaseFirestore.instance.collection("Userss").where("field1",isEqualTo: widget.userName).get();
//   t=  await  FirebaseFirestore.instance.collection("Userss").where("field1",isEqualTo: widget.userName).snapshots();
//
//
// }

  @override
  void initState() {
    d.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    //  print("hvhihdvv");
     // print(chatMessagesStream);
    });

    d.getimgMessages(widget.chatRoomId).then((value) {
      setState(() {
        imgstream = value;
        print(imgstream);
      });
    });

    d.getuserbyname(widget.userName).then((value) {
 //Future.delayed(Duration.zero);
       t = value;
      // print("$searchResultSnapshot");
      setState(() {
        // isLoading = false;
        //haveUserSearched = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff075E54),
        title: Row(
          children: [
//            StreamBuilder(
//             stream:t ,//FirebaseFirestore.instance.collection("Userss").snapshots(),
//     builder: (context, snapshot) {
//     return snapshot.hasData?
//     CircleAvatar(
//
//         foregroundColor:Color(0xff075E54),
//         backgroundColor:Colors.grey ,
//         backgroundImage: NetworkImage(
//           snapshot.data.docs["URL"],
//           //fit: BoxFit.fitWidth,
// //height: 70,
//           //width: 50,
//         )
//
//     ):CircularProgressIndicator();
//              }

            CircleAvatar(
                foregroundColor: Color(0xff075E54),
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(
                        t.docs[0]["URL"],
                        //fit: BoxFit.fitWidth,

//height: 70,
                        //width: 50,
//         )
                      )),
//  CircularProgressIndicator(),

            Text("     ${widget.userName}"),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/whbg.jpg',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            //chatMessages(),
            ChatMessageList(),
            ChatimageList(),

            //ChatimageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: Color(0x54FFFFFF),
                child: Row(
                  children: [
                    Container(
                        height: 70,
                        width: 40,
                        color: Colors.transparent,
                        child: imgfile != null
                            ? Image.file(
                                imgfile,
                                fit: BoxFit.fill,
                              )
                            : Container()),
                    Expanded(
                        child: TextField(
                      controller: messagecontroller,

                      //style: simpleTextStyle(),

                      decoration: InputDecoration(
                        hintText: "Type a message",
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        filled: true,
                      ),
                    )),
                    Row(
                      children: [
                        FlatButton(
                          minWidth: 40,
                          height: 10,
                          onPressed: () {
                            //  addMessage();
                            print("press");
                            _displayDialog(context);

                            print("press");
                            //  sendMessage();
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 40,
                                width: 30,
                                padding: EdgeInsets.all(12),
                                child: Icon(
                                  Icons.attach_file,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FlatButton(
                          minWidth: 40,
                          height: 10,
                          onPressed: () {
                            //  addMessage();
                            print("press");

                            sendMessage();
                            hh = false;
                          },
                          child: Container(
                            height: 40,
                            width: 30,
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              Icons.send_rounded,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  final String time;
  MessageTile(this.message, this.isSendByMe, this.time);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: isSendByMe
                      ? [Colors.yellow, Colors.pinkAccent]
                      : [Colors.blue, Colors.blueAccent]),
              borderRadius: isSendByMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomLeft: Radius.circular(23))
                  : BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomLeft: Radius.circular(23))),
          child: Column(
            children: [Text(message), Text(time)],
          )),
    );
  }
}
