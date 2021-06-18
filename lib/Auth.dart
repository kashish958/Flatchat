
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flatchat/Login.dart';
import 'package:flutter/material.dart';
import 'user.dart';

class Authenti{
  //final FirebaseAuth  _auth = FirebaseAuth.instance();
final  FirebaseAuth _auth = FirebaseAuth.instance;
final googleSignIn = GoogleSignIn();
static UserCredential result;
Giveuser _userfromfirebase(User user){

  return user!=null ?Giveuser(user.uid):null;
}



Future signingoogle()async
{


  final user = await googleSignIn.signIn();
  if(user== null)return CircularProgressIndicator();

  else{
    final googleAuth = await user.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
     User currentUser   = (await  FirebaseAuth.instance.signInWithCredential(credential)).user ;

    //currentUser = (await _auth.signInWithCredential(credential)).user;


   FirebaseFirestore.instance
        .collection("Userss")
        .doc(currentUser.uid)
        .set({
      "field1": currentUser.displayName,
     "URL": currentUser.photoURL,
      'field2': currentUser.email,
    });


  }



}


Future login(String email,String password) async{

  try{
    UserCredential result =await _auth.signInWithEmailAndPassword(email: email, password: password);
//User firebaseuser = result.user;
//return _userfromfirebase(firebaseuser);


    //.then((value) => Get.offAll(Home()))
        //.catchError((onError)=>
        //Get.snackbar("Error in logging  user ", onError.message,snackPosition: SnackPosition.BOTTOM));


  }
  catch(e)
  {
   // Get.snackbar("Error agya login m ", e.message,snackPosition: SnackPosition.BOTTOM);
print(e.toString());
  }
}



Future createuser(String email,String password) async{

  try{
  result  =await _auth.createUserWithEmailAndPassword(email: email, password: password);
    //User firebaseuser = result.user;
    //return _userfromfirebase(firebaseuser);


    // .then((value) => Get.offAll(Login()))// of all navigate to that class and ignore all previous routes
        //.catchError((error)=>
        //Get.snackbar("Error in creating user ", error.message,snackPosition: SnackPosition.BOTTOM),

    //Get.offAll(Signindone());
  }
  catch(e)
  {
print(e.toString());
//Get.snackbar("Error agya create m  ", e.message,snackPosition: SnackPosition.BOTTOM);
  }

}



Future resetpass(String email) async
{

  try{
    return await _auth.sendPasswordResetEmail(email: email);

  }
  catch(e){
    print(e.toString());
  }
}



Future signout() async{


  try{
    await _auth.signOut();

    //.then((value) => Get.offAll(Login()));
  if(LoginState().flag) {
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }
  }
  catch(e)
  {

    print(e.message);
//    Get.snackbar("Error in signout user ", e.message,snackPosition: SnackPosition.BOTTOM);

  }
}



}