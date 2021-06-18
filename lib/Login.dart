import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flatchat/savinglocalsharepref.dart';
import 'package:flutter/material.dart';
import 'Signup.dart';
import 'Auth.dart';
import 'chatroom.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'db.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  bool _rememberMe = false;
  //final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController T1Ctrl = new TextEditingController();
  TextEditingController T2Ctrl = new TextEditingController();
  bool loading = false;
  bool ShowPass = true;
  var SuffixIc;
  Authenti a = new Authenti();
  DB d = DB();
  var flag = false;
  QuerySnapshot snapshotuserinfo;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Center(
                child: Text("FlatChat",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30))),
            backgroundColor: Colors.black,
          ),
          body: SingleChildScrollView(
              child: Container(
            width: 600, //MediaQuery.of(context).size.width,
            height: 650, //MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitWanderingCubes(
                        color: Colors.black,
                        size: 50.0,
                      ),
                      Center(
                        child: Container(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 40),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)
                              ? null
                              : "Please enter valid email";
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          icon: Icon(
                            Icons.email,
                            color: Colors.black,
                          ),
                        ),
                        controller: T1Ctrl,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          return value.length < 4
                              ? "Please enter strong password"
                              : null;
                        },
                        controller: T2Ctrl,
                        obscureText: ShowPass,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          icon: Icon(
                            Icons.lock_outline_sharp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlatButton(
                              onPressed: () {
                                a.resetpass(T1Ctrl.text);
                              },
                              child: Text(
                                "Forget Password?",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          child: Center(
                        child: FlatButton(
                          child: GradiantBtn(
                            RoundRadius: 20.0,
                            BtnColor: Colors.black,
                            BtnTxt: "Sign In",
                            TxtColor: Colors.white,
                            TxtFontSize: 25.0,
                            W: 230.0,
                            H: 45.0,
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                             // locally saving email and name
                              HelperFunctions.saveUserEmailSharedPreference(
                                  T1Ctrl.text);

                              //for getting the useremail for saving locally
                              d.getuserbyemail(T1Ctrl.text).then((value) {
                                snapshotuserinfo = value;
                                HelperFunctions.saveUserNameSharedPreference(
                                    snapshotuserinfo.docs[0]["field1"]);
                              });

                              a.login(T1Ctrl.text, T2Ctrl.text).then((value) {
                                HelperFunctions
                                    .saveUserLoggedInSharedPreference(true);

                                // HelperFunctions.sharedPreferenceUserLoggedInKey;
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()));
                              });
                            }
                          },
                        ),
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          child: Text(
                            "Or",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 90, right: 90),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Image.asset(
                                'assets/fb.png',
                                width: 180,
                                height: 180,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Image.asset(
                                'assets/google.png',
                                width: 150,
                                height: 150,
                              ),
                              onPressed: () {
                                a.signingoogle();
                                flag = true;
                              },
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signup()));
                          },
                          child: Text(
                            "Not A Member Yet?SignUp Now!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ))),
    );
  }
}

class GradiantBtn extends StatelessWidget {
  var W, H, RoundRadius, BtnColor, BtnTxt, TxtColor, TxtFontSize, Do;

  GradiantBtn({
    @required this.RoundRadius,
    @required this.BtnColor,
    @required this.BtnTxt,
    @required this.TxtColor,
    @required this.TxtFontSize,
    @required this.W,
    @required this.H,
    @required this.Do,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: W,
      height: H,
      child: RaisedButton(
          color: BtnColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RoundRadius),
          ),
          child: Text(
            BtnTxt,
            style: TextStyle(color: TxtColor, fontSize: TxtFontSize),
          ),
          onPressed: Do),
    );
  }
}
