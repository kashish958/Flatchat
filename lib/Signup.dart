import 'package:firebase_storage/firebase_storage.dart';
import 'package:flatchat/Auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:get/get_navigation/src/snackbar/snack.dart';
import 'Login.dart';
import 'db.dart';
import 'savinglocalsharepref.dart';
import'dart:io';


class Signup extends StatefulWidget {
  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<Signup> {
  bool _rememberMe = false;

 // File imageFile;
//  final picker = ImagePicker();
  PickedFile _pickedImage;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController UserNameCtrl    = new TextEditingController();
  TextEditingController UserEmailCtrl   = new TextEditingController();
  TextEditingController UserPassCtrl    = new TextEditingController();
  bool loading = false;
Authenti a = new Authenti();
DB d = new DB();

  File imageFile;
  final picker = ImagePicker();
static var url;
@override
  Future choose(ImageSource source) async {
    final pickedimage = await picker.getImage(source: source);

    setState(() {
      imageFile = File(pickedimage.path);
      print(imageFile.path);
    });
  }


  @override
 Future addimage(File pickedImage) async{
    print("hee");
    print(Authenti.result.user.uid );

    final ref = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child(Authenti.result.user.uid + '.jpg');

    await ref.putFile(
        pickedImage
    );

    url = await ref.getDownloadURL();


    print(url);
    print("tt");
    return url;

  }






  @override
  void initState(){
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key:_scaffoldKey,
        body:
loading ? MaterialApp(
  //theme: new ThemeData(scaffoldBackgroundColor: const Color()),

  home:   Scaffold(
    backgroundColor: Colors.black,
    body: Center(


       child : SpinKitHourGlass(

          color: Colors.white,

          size: 300.0,

        ),



    ),
  ),

):

        SingleChildScrollView(







            child:Column(
mainAxisAlignment: MainAxisAlignment.center,

              children: [







                Container(
                  width:MediaQuery.of(context).size.width,
                  height:MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/MainBg2.jpg',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),








                  child:Form(
                      key: _formKey,
                      child:Center(
                        child:ListView(
                          shrinkWrap:true,
                          children: [
                            Center(
                              child: Container(


                               child: Column(
                                 children: [

                                   Center(
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                 CircleAvatar(
                                 radius: 70,
                                 backgroundColor: Colors.blueGrey,
                                 child: ClipOval(

                                   child: SizedBox(


                                     width:150.0,
                                     height :150.0,
                                     child: imageFile != null ? Image.file(imageFile,fit:BoxFit.fill,)  : CircularProgressIndicator(),

                                   ),
                                 ),

                               ),

                                           Container(
                                               child :Row(
                                                 children: [
                                                   Padding(

                                                     padding:  EdgeInsets.only(top :60),
                                                     child: IconButton(
                                                         icon: Icon(Icons.camera_alt ,size: 30,color: Colors.white,),
                                                         onPressed: (){
                                                           choose(ImageSource.gallery);
                                                         }
                                                     ),
                                                   ),


                                                 ],
                                               )

                                           )
                                         ],
                                       )
                                   )
                                   // Row(

                                    ,Text("SignUp",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 50),),
                                 ],
                               ),


                              ),
                            ),
                            SizedBox(height: 10,),
                            TextFormField(

                              validator: (value){
                               return value.isEmpty ? "Please Enter username ":null;

                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)

                                ),
                                labelText: 'Name',
                                  filled: true,
                                  fillColor: Colors.blueGrey,
                                icon: Icon(Icons.person_pin,color:Colors.white,),




                              ),

                              onChanged: (value) {
                                if (value.isEmpty) {
                                  return "Please Enter Your Email";
                                }
                              },
                              controller: UserNameCtrl,
                            ),

        //         Future choose(ImageSource source) async {
        // final pickedimage = await picker.getImage(source: source);
        //
        // setState(() {
        // imageFile = File(pickedimage.path);
        // });
        // }







                            SizedBox(height:10,),

                            TextFormField(
                              validator: (value){
                             return   RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value) ? null :"Please enter valid email";
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                ),
                                labelText: 'Email',
                                icon: Icon(Icons.email,color:Colors.white,),
                                  filled: true,
                                  fillColor: Colors.blueGrey



                              ),

                              onChanged: (value) {
                                if (value.isEmpty) {
                                  return "Please Enter Your Email";
                                }
                              },
                              controller: UserEmailCtrl,
                            ),


                            SizedBox(height:10,),


                            SizedBox(height:10,),

          TextFormField(

                validator: (value){
return value.length<4 ? "Please enter strong password": null;
                },
                controller: UserPassCtrl,
                cursorColor: Colors.white,
                obscureText:true,
                onChanged:(value) {
                  if (value.isEmpty) {
                    return "Please Enter Your Password";
                  }
                },

                decoration: InputDecoration(
//  hoverColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                  ),

                  labelText: 'Password',
                  icon: Icon(Icons.lock_outline_sharp,color:Colors.white,),
filled: true,
fillColor: Colors.blueGrey

                ),



          ),

                            SizedBox(height:25,),

                            Container(
                                child:Center(
                                    child: GradiantBtn(
                                        RoundRadius:20.0,
                                        BtnColor:Colors.blue,
                                        BtnTxt:"SignUp",
                                        TxtColor:Colors.white,
                                        TxtFontSize:25.0,
                                        W: 230.0,
                                        H: 45.0,
                                        Do:() async {
                                          if (_formKey.currentState.validate()) {
setState(() {
  loading=true;
});

         a.createuser(UserEmailCtrl.text, UserPassCtrl.text).then((value) {
         //  HelperFunctions.saveUserLoggedInSharedPreference(true);
           HelperFunctions.saveUserNameSharedPreference(UserNameCtrl.text);
           HelperFunctions.saveUserEmailSharedPreference(UserEmailCtrl.text);

         addimage(imageFile).then((value) {
           print(value);
           d.uploadinfo(UserNameCtrl.text, UserEmailCtrl.text,value) ;}  );

           //Navigator.push(context ,MaterialPageRoute(builder: (context)=>Gal()));
        Navigator.pushReplacement(context ,MaterialPageRoute(builder: (context)=>Login()));




         }).catchError((error)=>
       print(error.toString())
         );
                                          }

                                        }
                                    ),
                                )
                            ),

                            SizedBox(height:20,),




                            Center(
                              child:FlatButton(
                                onPressed:(){
                                  Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>Login()));
                                },
                                child:Text(
                                  "Have An Account?SignIn",
                                  style:TextStyle(
                                      color:Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),




                          ],
                        ),
                      )
                  ),
                ),
              ],
            )
        )




    );

  }





}