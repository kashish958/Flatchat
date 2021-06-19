import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'Auth.dart';


class DB{
static var url;

  getuserbyname(String name) async{
    
  return await  FirebaseFirestore.instance.collection("Userss").where("field1",isEqualTo: name).get();
  }









getuserbyemail(String email) async{

  return await  FirebaseFirestore.instance.collection("Userss").where("field2",isEqualTo: email).get();

}





  uploadinfo(String UserNameCtrl,String UserEmailCtrl ,String photo){
    print("lk");
    print(photo);
    Map <String,dynamic> data = {
      "field1" :UserNameCtrl,"field2" :UserEmailCtrl ,"URL" :photo
    };
    FirebaseFirestore.instance.collection("Userss").add(data);

  }

//chatRoomId = username1_username2
  //chatRoomMap= userskey value pair vala
//set({
//        "users ": users, //
//     "chatroomid": chatRoomId,
//     })

  // Future<void> updatelastmsgtime(String chatRoomId,Map<String,dynamic>data)
  // {
  //   FirebaseFirestore.instance.collection("Users").doc(chatRoomId).update(data).catchError((onError){
  //     print(onError.toString);
  //   });
  // }

Future<void>  createChatRoom(String chatRoomId ,Map<String,dynamic> chatRoomMap ){
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).set(chatRoomMap).catchError((onError){
      print(onError.toString);
    });
  }


  addConversationMessages(String chatRoomId, messageMap){
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).collection("Chats").add(messageMap)
        .catchError((onError){
      print(onError.toString);

    });

  }

  getConversationMessages(String chatRoomId) async {

   return await  FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).collection("Chats")
   .orderBy("time",descending: false)
   .snapshots();

  }



  getimgMessages(String chatRoomId) async {

    return await  FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).collection("Media")
        .orderBy("time",descending: false)
        .snapshots();

  }



 Future<Stream <QuerySnapshot>> getChatRooms(String userName) async{

   return await FirebaseFirestore.instance.collection("ChatRoom").where("users",arrayContains: userName)
    .snapshots();
  }





//TaskSnapshot taskSnapshot = await uploadTask.onComplete;





      //Show(url);



  //FirebaseFirestore.instance.collection('test').snapshots() ,

Future getuserlist () async{
    return await FirebaseFirestore.instance.collection("Userss").snapshots();
}

 // ChatRoom").doc(chatRoomId).collection("Chats").add(messageM
addingimage(String chatRoomId,imgMap)async{
return await FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).collection("Media").add(imgMap)
    .catchError((onError){
  print(onError.toString);

});

}
  // createChatRoom(String chatRoomId ,Map<String,dynamic> chatRoomMap ){
  //   FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).set(chatRoomMap).catchError((onError){
  //     print(onError.toString);
  //   });
  // }


Future<void> creategroup (String groupid,Map<String,dynamic>groupMap) async
{
    FirebaseFirestore.instance.collection("GroupRoom").doc(groupid)
        .set(groupMap)
        .catchError((onError){
      print(onError.toString());
    });

}




addgroupmsg(String groupid,Map<String,dynamic> msgmap){

    FirebaseFirestore.instance.collection("GroupRoom").doc(groupid).collection("grtalks").add(msgmap).catchError((onError)
       { print(onError.toString());});
}



  getgroupmsg(String groupid) async {

    return await  FirebaseFirestore.instance.collection("GroupRoom").doc(groupid).collection("grtalks")
        .orderBy("time",descending: false)
        .snapshots();

  }



  }