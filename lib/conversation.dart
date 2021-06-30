import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flatchat/Searchsreen.dart';
import 'package:flatchat/Signup.dart';
import 'package:flatchat/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'Auth.dart';
import 'ChatScreen.dart';
import 'chatroom.dart';
import 'db.dart';
import 'package:path/path.dart';
import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'FirebaseApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController messagecontroller = TextEditingController();
  File imgfile;
  String messager;
  final picker = ImagePicker();
  var iurl;
  Stream chatMessagesStream;
  Stream imgstream;

  QuerySnapshot t;
  bool hh = false;
  UploadTask task;
  File file;
  UploadTask tt;
  VideoPlayerController _controller;

  Future<void> _initializeVideoPlayerFuture;
  // final picker = ImagePicker();
  File vi;

  @override
  Widget ChatMessageList() {
    //  print("iuhuih");
//    print(chatMessagesStream.length);

    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        //  print("fvf");
        // print(snapshot.data);
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    snapshot.data.docs[index]["message"],
                    snapshot.data.docs[index]["sendby"] == Constants.myName,
                    snapshot.data.docs[index]["time"],
                    snapshot.data.docs[index]["type"],
                  );
                })
            : Container(child: CircularProgressIndicator());
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
                        child: Column(
                          //isSendByMe?
                          crossAxisAlignment: snapshot.data.docs[index]
                                      ["sendby"] ==
                                  Constants.myName
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            // Text(" ${time.toDate().hour} :"  "${time.toDate().minute } ",style: TextStyle(color: Colors.black),),

                            Material(
                              borderRadius: snapshot.data.docs[index]
                                          ["sendby"] ==
                                      Constants.myName
                                  ? BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0),
                                      bottomRight: Radius.circular(30.0))
                                  : BorderRadius.only(
                                      bottomLeft: Radius.circular(30.0),
                                      bottomRight: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                    ),
                              elevation: 5.0,
                              color: snapshot.data.docs[index]["sendby"] ==
                                      Constants.myName
                                  ? Color(0xFFDCF8C6)
                                  : Colors.white,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: Image.network(
                                    snapshot.data.docs[index]["imgurl"],
                                    height: 110,
                                  )),
                            ),
                          ],
                        ));

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
    return imgfile;
  }

//for sending image
  sendimg(int i, String ii) {
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

  sendvid(int i, String vv) {
    print(vv);
    sendMessage(i, vv);
  }

  final user = FirebaseAuth.instance.currentUser;
  sendMessage(int i, String msgg) {
    print(user.uid);

    Map<String, dynamic> messageMap = {
      "message": msgg,
      "sendby": Constants.myName,
      "time": DateTime.now(),
      "type": i
    };
    d.addConversationMessages(widget.chatRoomId, messageMap);
    FirebaseFirestore.instance
        .collection('Userss')
        .doc(widget.userName)
        .update({
      'lastmsg': messagecontroller.text,
      "lasttime": DateTime.now(),
      // "name": widget.name,
    });
    messagecontroller.clear();
  }

  // getlast() {
  //   print("fetchiii");
  //
  //     Map<String, dynamic> lastdata = {
  //       "lastmsg": messagecontroller.text,
  //       "lasttime": DateTime.now()
  //     };
  //     d.updatelastmsgtime(widget.chatRoomId, lastdata);
  //  //  messagecontroller.clear();
  //
  // }

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
                              sendimg(0, value);

                              ChatimageList();
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
                    onTap: () {
                      chooseimg(ImageSource.gallery).then((value) => {
                            addimg(value).then((value) {
                              sendimg(0, value);

                              ChatimageList();
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
                    onTap: () {
                      pickvideo().then((value) {
                        // _controller= VideoPlayerController.network(message)..initialize().then((value) {
                        //   setState(() {
                        //     _initializeVideoPlayerFuture=_controller.initialize();
                        //   });
                        //   _controller.play();

                        sendvid(2, value);
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
                  )
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
                    onTap: () {
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
                    onTap: () {
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

  pickvideo() async {
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
    print("hhhuhuhuhuhuh" + urlDownload);
    // _controller= VideoPlayerController.network(urlDownload)..initialize().then((value) {
    //   setState(() {
    //     _initializeVideoPlayerFuture=_controller.initialize();
    //   });
    //   _controller.play();});

    return urlDownload;
  }

  @override
  void initState() {
    d.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
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
    final fileName = file != null ? basename(file.path) : 'No File Selected';
    return Stack(children: [
      Image.asset(
        "assets/whbg.jpg",
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leadingWidth: 30,
          backgroundColor: Color(0xff075E54),
          title: Row(
            children: [
              //   IconButton(onPressed: (){
              //     Navigator.pushReplacement(context,
              // MaterialPageRoute(builder: (context) => Home() ));
              //   }, icon: Icon(Icons.arrow_back),)
              //   ,
//Icon(Icons.arrow_back),

              CircleAvatar(
                  foregroundColor: Color(0xff075E54),
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                    t.docs[0]["URL"],
                  )),
//  CircularProgressIndicator(),

              Text("  ${widget.userName}"),

              Spacer(),

              IconButton(
                icon: Icon(
                  Icons.call,
                  color: Colors.white,
                ),
              ),
              IconButton(
                  icon: Icon(
                Icons.video_call,
                color: Colors.white,
              )),

              IconButton(
                  icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              )),
            ],
          ),
        ),
        body: Stack(
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
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
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
                        //Spacer(),

                        FlatButton(
                          minWidth: 40,
                          height: 10,
                          onPressed: () {
                            //  addMessage();
                            print("press");
                            messager = messagecontroller.text;
                            sendMessage(1, messager);
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
    ]);
  }
}

class MessageTile extends StatefulWidget {
  final String message;
  final int type;
  final bool isSendByMe;
  final Timestamp time;

  MessageTile(this.message, this.isSendByMe, this.time, this.type);

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  VideoPlayerController _controller;

  Future<void> _initializeVideoPlayerFuture;
  static VoidCallback listener;

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      _controller = VideoPlayerController.network(widget.message)
        ..addListener(listener = () {
          setState(() {});
        })
        ..setVolume(1.0)
        ..initialize().then((value) {
          setState(() {});

          _initializeVideoPlayerFuture = _controller.initialize();
          _controller.play();
        });
    }
//     _controller= VideoPlayerController.network(widget.message)..initialize().then((value) {
//       setState(() {
// print("hhhopopo");
//       });
//
//
//
//       _controller.play();});

    return Container(
      padding: EdgeInsets.only(
          left: widget.isSendByMe ? 0 : 24, right: widget.isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment:
          widget.isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        //isSendByMe?
        crossAxisAlignment: widget.isSendByMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            " ${widget.time.toDate().hour} :" "${widget.time.toDate().minute} ",
            style: TextStyle(color: Colors.black),
          ),
          Material(
            borderRadius: widget.isSendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: widget.isSendByMe ? Color(0xFFDCF8C6) : Colors.white,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 11.0, horizontal: 13.0),
                child: Column(children: [
                  if (widget.type == 0)
                    Container(
                        // padding: EdgeInsets.all(40),
                        height: 150,
                        width: 130,
                        child: Image.network(
                          widget.message,
                          fit: BoxFit.fill,
                        )),
                  if (widget.type == 1) Text(widget.message),
                  if (widget.type == 2)
                    Stack(
                      children: [
                        Container(
                          height: 150,
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
                        )
                      ],
                    ),
                ])),
          )
        ],
      ),
    );
  }
}
