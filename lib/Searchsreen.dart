import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flatchat/ChatScreen.dart';
import 'package:flatchat/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db.dart';
import 'package:flutter/material.dart';
import 'conversation.dart';

class Searchscreen extends StatefulWidget {


  @override
  State<StatefulWidget>createState(){
    return Searchstate();
  }
}



class Searchstate extends State<Searchscreen> {

  DB d = new DB();
TextEditingController searchname = TextEditingController();

QuerySnapshot searchsnapshot;









  initiateSearch() async {
    //if(searchEditingController.text.isNotEmpty){
     // setState(() {
        //isLoading = true;
      //});
      await d.getuserbyname(searchname.text)
          .then((value){
        searchsnapshot = value;
       // print("$searchResultSnapshot");
        setState(() {
         // isLoading = false;
          //haveUserSearched = true;
        }
        );
      });
    }


createchatroomandtalk(  BuildContext context,  {String userName}) async{
    print("${userName}");

    if(userName != Constants.myName){
  String chatRoomId = getChatRoomId(userName, Constants.myName);
  List<String> users = [userName, Constants.myName];
  Map<String, dynamic> chatRoomMap = {
    "users ": users,
    "chatroomid": chatRoomId,
    // "lastmsg" :"huhuh",
    // "lasttime":DateTime.now()

  };
  print("ayaya");
  await d.createChatRoom(chatRoomId, chatRoomMap);
  Navigator.push(context, MaterialPageRoute(builder: (context) => Conversation(chatRoomId,userName)
  ));
ChatScreenstate().getchatroomidformsg(chatRoomId);
}
    else{
      print("Dont text yourself");
    }
  }



Widget SearchTile( {String username,
   String useremail}){
 // SearchTile({  this.username,this.useremail  });


  return Container(
    child: Row(
      children: [
        Column(
          children: [
            Text(username ),
            Text(useremail  )
          ],
        ),
        Spacer(),
        GestureDetector(
          onTap: (){
            createchatroomandtalk( context,
              userName:username
            );
          },

          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5) ,
            color: Colors.green,
            child: Text("Message", style: TextStyle(backgroundColor: Colors.white),),
          ),
        )

      ],
    ),

  );

}

  Widget searchList(){
    return searchsnapshot!=null? ListView.builder(
itemCount: searchsnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
return SearchTile(
  username: searchsnapshot.docs[index]["field1"],

  useremail: searchsnapshot.docs[index]["field2"] ,
);
        }) :
        Container();
  }


@override
void initState(){
 // initiateSearch();

  super.initState();
}

//For making unique username1_username2
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }


  @override
  Widget build(BuildContext context) {
return MaterialApp(

  home:Scaffold(

    appBar: AppBar(title: Text("FlatChat"),
    backgroundColor: Color(0xff075E54),),
    body:
      Container (
        padding: EdgeInsets.symmetric(horizontal: 17,vertical: 19) ,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Row(
              children: <Widget>[
               Expanded(child: TextField(

controller: searchname,

          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)

            ),
            labelText: 'Search Name',
            filled: true,
           // fillColor: Colors.blueGrey,
               )
               ),

               )
    ,GestureDetector(
      child: Container(width: 40,
                      height: 40,
                      child: Icon(Icons.search_rounded,
                      )
                  ),
   onTap: (){
      initiateSearch();
   },
    )


              ],
            ),
            searchList()
          ],
        ),
      )


  )

);

  }

}


