import 'package:ebook_app/login_signup/FadeAnimation.dart';
import 'package:ebook_app/login_signup/main_screens/LoginPage.dart';
import 'package:ebook_app/login_signup/results_screen/Done.dart';
import 'package:ebook_app/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:validators/validators.dart' as validator;
import 'package:flutter_signin_button/flutter_signin_button.dart';
// ignore: must_be_immutable
class RegisterPage extends StatefulWidget {
  static String id = '/RegisterPage';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String name;
  String email;
  String password;

  bool _showSpinner = false;
  bool _wrongname = false;
  bool _wrongEmail = false;
  bool _wrongPassword = false;
  String _nameText = 'Please use a strong Username';
  String _emailText = 'Please use a valid email';
  String _passwordText = 'Please use a strong password';

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn() async {
    // hold the instance of the authenticated user
    FirebaseUser user;
    // flag to check whether we're signed in already
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      // if so, return the current user
      user = await _auth.currentUser();
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      // get the credentials to (access / id token)
      // to sign in via Firebase Authentication
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      user = (await _auth.signInWithCredential(credential)).user;
    }

    return user;
  }

  void onGoogleSignIn(BuildContext context) async {
    FirebaseUser user = await _handleSignIn();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen(user,_googleSignIn)));
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        color: Colors.blueAccent,
        child: Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image:ExactAssetImage(
                'assets/images/form_background.jpg',
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 80,),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    FadeAnimation(1, Text("Register", style: TextStyle(color: Colors.white, fontSize: 40),)),
                    SizedBox(height: 10,),
                    FadeAnimation(1.3, Text("Welcome Here", style: TextStyle(color: Colors.white, fontSize: 18),)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 60,),
                          FadeAnimation(1.4, Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(
                                    color: Color.fromRGBO(225, 95, 27, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10)
                                )]
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                  ),
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    keyboardType: TextInputType.name,
                                    textCapitalization: TextCapitalization.words,
                                    onChanged: (value) {
                                      name = value;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Username",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      errorText: _wrongname ? _nameText : null,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                  ),
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (value) {
                                      email = value;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Email ",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      errorText: _wrongEmail ? _emailText : null,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                  ),
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    obscureText: true,
                                    keyboardType: TextInputType.visiblePassword,
                                    onChanged: (value) {
                                      password = value;
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Password",
                                        errorText: _wrongPassword ? _passwordText : null,
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                          FadeAnimation(1.6, Container(
                            height: 37,
                            margin: EdgeInsets.symmetric(horizontal: 87),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.orange[800]
                            ),
                            child: RaisedButton(
                              color:Colors.orange[900],
                              onPressed: () async {
                                setState(() {
                                  _wrongname=false;
                                  _wrongEmail = false;
                                  _wrongPassword = false;
                                });
                                try {
                                  if (validator.isLength(name, 4)& validator.isEmail(email) &
                                  validator.isLength(password, 6)) {
                                    setState(() {
                                      _showSpinner = true;
                                    });
                                    final newUser =
                                    await _auth.createUserWithEmailAndPassword(
                                      email: email,
                                      password: password,
                                    );
                                    if (newUser != null) {
                                      print('user authenticated by registration');
                                      Navigator.pushNamed(context, Done.id);
                                    }
                                    if(name.isEmpty){
                                      print('nvkr');
                                    }

                                  }

                                  setState(() {
                                    if (!validator.isLength(name,4)) {
                                      _wrongname = true;
                                    }
                                    else if (!validator.isEmail(email)) {
                                      _wrongEmail = true;
                                    } else if (!validator.isLength(password, 6)) {
                                      _wrongPassword = true;
                                    } else {
                                      _wrongEmail = true;
                                      _wrongPassword = true;
                                    }
                                  });
                                } catch (e) {
                                  setState(() {
                                    _wrongEmail = true;
                                    if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
                                      _emailText =
                                      'The email address is already in use by another account';
                                    }
                                  });
                                }
                              },
                              child: Center(
                                child: Text("Register", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                              ),
                            ),
                          )),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                          FadeAnimation(1.7, Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Already have an account?',
                                style: TextStyle(fontSize: 15.0,color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, LoginPage.id);
                                },
                                child: Text(
                                  ' Sign In',
                                  style: TextStyle(fontSize: 15.0, color: Colors.blue),
                                ),
                              ),
                            ],
                          ),),
                          SizedBox(height: 10,),
                          const Divider(
                            color: Colors.black,
                            height: 20,
                            thickness: 2,
                            indent: 20,
                            endIndent: 20,
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          FadeAnimation(1.7,Text('Sign In with Google',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:17),)),
                          SizedBox(height: 10,),
                          FadeAnimation(1.7, SignInButton(
                            Buttons.Google,
                            onPressed: (){
                              onGoogleSignIn(context);
                            },
                          )),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

