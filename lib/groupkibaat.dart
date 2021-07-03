import 'package:flatchat/chatroom.dart';
import 'package:flutter/material.dart';

import'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flatchat/Searchsreen.dart';
import 'package:flatchat/Signup.dart';
import 'package:flatchat/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'Auth.dart';
import 'db.dart';
import 'package:path/path.dart';
import 'db.dart';
import 'FirebaseApi.dart';
import 'gc.dart';
import 'package:video_player/video_player.dart';


class Groupkibaat extends StatefulWidget {
  final String chatRoomId ;
  final List users;
  final String url;
  Groupkibaat(this.chatRoomId,this.users,this.url);

  @override
  GroupkibaatState createState() => GroupkibaatState();
}

class GroupkibaatState extends State<Groupkibaat> {
  DB d = new DB();
  //QuerySnapshot snapshot;
  TextEditingController messagecontroller = new TextEditingController();
  File imgfile;
  final picker = ImagePicker();
  var iurl;
  Stream chatMessagesStream;
  Stream imgstream;
  bool hh = false;
  UploadTask tt;
  VideoPlayerController _controller;

  Future<void> _initializeVideoPlayerFuture;
  // final picker = ImagePicker();
  File vi;

  @override
  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData

            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(snapshot.data.docs[index]["message"],
                      snapshot.data.docs[index]["sendby"] == Constants.myName,snapshot.data.docs[index]["sendby"],snapshot.data.docs[index]["time"],snapshot.data.docs[index]["type"]);
                })
            : Container();
      },
    );
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
    return imgfile;
  }

//for sending image
  sendimg(int i ,String ii ) {
    print(ii);
    sendMessage(0, ii);
    // if (imgfile != null) {
    //   Map<String, dynamic> imgMap = {
    //     "imgurl": ii,
    //     "sendby": Constants.myName,
    //     "time": DateTime.now()
    //   };
    //   d.addingimage(widget.chatRoomId, imgMap);
    // }
  }

  pickvideo()async{
    final video = await picker.getVideo(source: ImageSource.gallery);
    vi = File(video.path);

    //   Future selectFile() async {
    // final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    //
    // if (result == null) vireturn;
    // final path = result.files.single.path!;
    //
    // setState(() => file = File(path));


    if (vi == null) return;

    final fileName = basename(vi.path);
    final destination = 'videos/$fileName';


    tt = FirebaseApi.uploadFile(destination, vi);
    setState(() {});

    if (tt == null) return;

    final snapshot = await tt.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
    print("hhhuhuhuhuhuh"+urlDownload);
    // _controller= VideoPlayerController.network(urlDownload)..initialize().then((value) {
    //   setState(() {
    //     _initializeVideoPlayerFuture=_controller.initialize();
    //   });
    //   _controller.play();});

    return urlDownload;

  }



  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      chooseimg(ImageSource.camera).then((value) => {
                        addimg(value).then((value) {
                          sendimg(0,value);

                          //ChatimageList();
                        })
                      });
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.blueAccent[100],
                      child: Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.blueAccent[600],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.green[200],
                      child: Icon(
                        Icons.image,
                        size: 20,
                        color: Colors.blueGrey,
                      ),
                    ),
                    onTap: (){
                      chooseimg(ImageSource.gallery).then((value) =>{
                        addimg(value).then((value) {
                          sendimg(0,value);

                         // ChatimageList();
                        })
                      });
                      Navigator.of(context).pop();


                    },
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.red[200],
                      child: Icon(
                        Icons.video_call_outlined,
                        size: 20,
                        color: Colors.blueGrey,
                      ),
                    ),
                    onTap: (){
                     pickvideo().then((value){


                       sendvid(2,value);
                     });


                      // chooseimg(ImageSource.gallery).then((value) =>{
                      //   addimg(value).then((value) {
                      //     sendimg(0,value);
                      //
                      //     ChatimageList();
                      //   })
                      // });
                      Navigator.of(context).pop();


                    },
                  ),






                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // chooseimg(ImageSource.camera).then((value) => {
                      //   addimg(value).then((value) {
                      //     sendimg(0,value);
                      //
                      //     ChatimageList();
                      //   })
                      // });
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.deepPurpleAccent,
                      child: Icon(
                        Icons.contacts_sharp,
                        size: 20,
                        color: Colors.blueAccent[600],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.yellow[200],
                      child: Icon(
                        Icons.file_copy,
                        size: 20,
                        color: Colors.blueAccent[600],
                      ),
                    ),
                    onTap: (){
                      // chooseimg(ImageSource.gallery).then((value) =>{
                      //   addimg(value).then((value) {
                      //     sendimg(0,value);
                      //
                      //     ChatimageList();
                      //   })
                      // });
                      // Navigator.of(context).pop();


                    },
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.orange[200],
                      child: Icon(
                        Icons.location_on,
                        size: 20,
                        color: Colors.blueGrey[600],
                      ),
                    ),
                    onTap: (){
                      // pickvideo().then((value){
                      // _controller= VideoPlayerController.network(message)..initialize().then((value) {
                      //   setState(() {
                      //     _initializeVideoPlayerFuture=_controller.initialize();
                      //   });
                      //   _controller.play();

                      // sendvid(2,value);
                      //  });


                      // chooseimg(ImageSource.gallery).then((value) =>{
                      //   addimg(value).then((value) {
                      //     sendimg(0,value);
                      //
                      //     ChatimageList();
                      //   })
                      // });
                      Navigator.of(context).pop();


                    },
                  )

                ],
              ),




            )

          ],
        ),
      ),
    );
  }




  String  usersListToString;
  void listToString(){
    usersListToString = widget.users.reduce((value, element) => value + ', ' + element);

  }
  sendvid(int i ,String vv){
    print(vv);
    sendMessage(i, vv);

  }



   sendMessage(int i ,String msgg) {

      Map<String, dynamic> messageMap = {
        "message": msgg,
        "sendby": Constants.myName,
        "time": DateFormat.Hm().format(DateTime.now()),
        "type":i

      };
      d.addgroupmsg(widget.chatRoomId, messageMap);
      FirebaseFirestore.instance.collection('GroupRoom').doc(widget.chatRoomId).update({
        'lastmsg': messagecontroller.text,
        "lasttime":DateFormat.Hm().format(DateTime.now())
        // "name": widget.name,
      });
      messagecontroller.clear();
    }


  List li=[] ;

  @override
  void initState() {


    d.getgroupmsg(widget.chatRoomId).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    });



    listToString();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff075E54),

        title:    ListTile(
          title:  Text("${widget.chatRoomId}",
          style: TextStyle(color: Colors.white,fontSize: 19),),
          subtitle:   Text("${usersListToString}", style: TextStyle(color: Colors.white,fontSize: 12),)


        ),




        //Text("${widget.chatRoomId}"),

          leading: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    //a.signout();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Home() )
                    );

                  },
                  child: Icon(Icons.arrow_back)),

              Expanded(
                child: CircleAvatar(
radius: 25,
                    foregroundColor:Color(0xff075E54),
                    backgroundColor:Colors.grey ,
                    backgroundImage: NetworkImage(
                      widget.url,

                      //fit: BoxFit.fitWidth,
//height: 70,
                      //width: 50,
                    )

                ),
              ),
            ],
          ),
       actions: [
         Container(
padding: EdgeInsets.only(right: 15),
           child: Row(
             children: [
               Icon(Icons.call),
               Text("   "),
               Icon(Icons.more_vert),
             ],
           ),

         )




       ],
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
            //  ChatimageList(),

            //ChatimageList(),
            Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(

                // borderRadius: BorderRadius.all(Radius.circular(30))
              ),
              child:
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, ),
                decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius: BorderRadius.all(Radius.circular(30))
                ),
                //  color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50)),
                      width: 40,
                      height: 50,
                      child: Icon(
                        Icons.emoji_emotions,
                        color: Colors.grey[800],
                      ),
                    ),
                    Expanded(
//width: 164,
                      //height: 40,
                        child: TextField(
                          controller: messagecontroller,

                          //style: simpleTextStyle(),

                          decoration: InputDecoration(

                            fillColor: Colors.white,
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
                            // _displayDialog(context);
                            showModalBottomSheet(
                                elevation: 10,

                                isScrollControlled: true,
                                isDismissible: true,
                                enableDrag: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (builder) => bottomSheet(context));
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

                        GestureDetector(
                          onTap: () {
                            chooseimg(ImageSource.camera).then((value) => {
                              addimg(value).then((value) {
                                sendimg(0, value);

                             //   ChatimageList();
                              })
                            });
                            //Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.camera_alt,
                          ),
                        ),

                        //Spacer(),

                        FlatButton(
                          minWidth: 40,
                          height: 10,

                          onPressed: () {
                            //  addMessage();
                            print("press");
                          //  messager = messagecontroller.text;
                            sendMessage(1,messagecontroller.text);
                            //  getlast();
                            print("isshbot");


                            hh = false;
                          },
                          child: CircleAvatar(
                            backgroundColor: Color(0xff075E54),

                            child: Container(
                              height: 70,
                              width: 40,

                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.send_rounded,
                              ),
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


                                //// MSGTile///

class MessageTile extends StatefulWidget {
  final String message;
  final bool isSendByMe;
  String sender;
  final String time;
  final int type;


  MessageTile(this.message, this.isSendByMe, this.sender,this.time,this.type);

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  VideoPlayerController _controller;

  Future<void> _initializeVideoPlayerFuture;
  static VoidCallback listener;
  Widget build(BuildContext context) {

    if (_controller == null) {
      _controller =
      VideoPlayerController.network(widget.message)
        ..addListener(listener = () {
          setState(() {});
        })
        ..setVolume(1.0)
        ..initialize().then((value) {
          setState(() {

          });

          _initializeVideoPlayerFuture=_controller.initialize();
          _controller.play();
        });
    }



    return Container(
      padding: EdgeInsets.only(
          left: widget.isSendByMe ? 0 : 24, right: widget.isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery
          .of(context)
          .size
          .width,
      alignment: widget.isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        //isSendByMe?
        crossAxisAlignment: widget.isSendByMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [

          Text("From: "+widget.sender, style: TextStyle(fontSize: 10),),

          Material(
            borderRadius: widget.isSendByMe
                ? BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0))
                : BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            elevation: 5.0,
            color: widget.isSendByMe ? Color(0xFFDCF8C6) : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(children: [
                if (widget.type == 0)

                  Stack(
                    children: <Widget>[

                      Container(
                        //padding: EdgeInsets.all(40),
                          height: 170,
                          width: 180,
                          padding: EdgeInsets.only(right: 39),
                          child: Image.network(
                            widget.message,
                            fit: BoxFit.fill,
                          ))
                      ,
                      Positioned(
                        top: 160,
                        bottom: 0.0,

                        right: 0.0,
                        child: Row(
                          children: <Widget>[
                            Text(widget.time,
                              //'${DateFormat.Hm().format(widget.time.toDate())}',
                              style: TextStyle(color: Colors.black38 , fontSize: 10),
                            ),

                            //  SizedBox(height: 8.0),

                          ],
                        ),
                      )
                    ],
                  ),




                if (widget.type == 1)

                  Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 48.0),
                        child: Text(widget.message),
                      ),
                      Positioned(
                        top: 7,
                        bottom: 0.0,
                        right: 0.0,
                        child: Row(
                          children: <Widget>[
                            Text(widget.time,
                              //'${DateFormat.Hm().format(widget.time.toDate())}',
                              style: TextStyle(color: Colors.black38 , fontSize: 10),
                            ),
                            SizedBox(width: 3.0),

                          ],
                        ),
                      )
                    ],
                  ),


                if (widget.type == 2)
                  Stack(
                    children: [
                      Container(
                        height: 170,
                        width: 150,

                        // padding: EdgeInsets.all(0),

                        child: FutureBuilder(
                            future: _initializeVideoPlayerFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                print("okokok");
                                return Center(
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: VideoPlayer(_controller),
                                  ),
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                      ),
                      Container(
                        // padding: EdgeInsets.all(2),
                        padding: EdgeInsets.only(right: 30),
                        margin: EdgeInsets.only(right: 100),
                        child: FloatingActionButton(
                          backgroundColor: Color(0x00000000),
                          elevation: 50,
                          onPressed: () {
                            // Wrap the play or pause in a call to `setState`. This ensures the
                            // correct icon is shown.
                            setState(() {
                              // If the video is playing, pause it.
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                              } else {
                                // If the video is paused, play it.
                                _controller.play();
                              }
                            });
                          },
                          // Display the correct icon depending on the state of the player.
                          child: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 150,
                        bottom: 0.0,

                        right: 0.0,
                        child: Row(
                          children: <Widget>[
                            Text(widget.time,
                              //'${DateFormat.Hm().format(widget.time.toDate())}',
                              style: TextStyle(color: Colors.black38 , fontSize: 10),
                            ),

                            //  SizedBox(height: 8.0),

                          ],
                        ),
                      )
                    ],
                  ),
              ])
            ),
          )
        ],
      ),
    );
  }
}

