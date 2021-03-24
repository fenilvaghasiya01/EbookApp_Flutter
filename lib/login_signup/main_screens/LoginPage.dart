import 'package:ebook_app/login_signup/FadeAnimation.dart';
import 'package:ebook_app/login_signup/main_screens/RegisterPage.dart';
import 'package:ebook_app/login_signup/results_screen/Done.dart';
import 'package:ebook_app/login_signup/results_screen/ForgotPassword.dart';
import 'package:ebook_app/views/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

bool _wrongEmail = false;
bool _wrongPassword = false;

FirebaseUser _user;

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  static String id = '/LoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email;
  String password;

  bool _showSpinner = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn() async {
    // hold the instance of the authenticated user
//    FirebaseUser user;
    // flag to check whether we're signed in already
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      // if so, return the current user
      _user = await _auth.currentUser();
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      // get the credentials to (access / id token)
      // to sign in via Firebase Authentication
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      _user = (await _auth.signInWithCredential(credential)).user;
    }

    return _user;
  }

  void onGoogleSignIn(BuildContext context) async {
    setState(() {
      _showSpinner = true;
    });

    FirebaseUser user = await _handleSignIn();

    setState(() {
      _showSpinner = true;
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen(user,_googleSignIn)));
  }

  String emailText = 'Email doesn\'t match';
  String passwordText = 'Password doesn\'t match';

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
                    FadeAnimation(1, Text("Login", style: TextStyle(color: Colors.white, fontSize: 40),)),
                    SizedBox(height: 10,),
                    FadeAnimation(1.3, Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18),)),
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
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (value) {
                                      email = value;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Email ",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      errorText: _wrongEmail ? emailText : null,
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
                                        errorText: _wrongPassword ? passwordText : null,
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                          FadeAnimation(1.5, Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  child: Text("Forgot Password?",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onTap: (){
                                    Navigator.pushNamed(context, ForgotPassword.id);
                                  },
                                ),
                              ]),),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                          FadeAnimation(1.6, Container(
                            height: 37,
                            margin: EdgeInsets.symmetric(horizontal: 87),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.orange[800]
                            ),
                            child: RaisedButton(
                              color: Colors.orange[800],
                              onPressed: () async {
                                setState(() {
                                  _showSpinner = true;
                                });
                                try {
                                  setState(() {
                                    _wrongEmail = false;
                                    _wrongPassword = false;
                                  });
                                  final newUser = await _auth.signInWithEmailAndPassword(
                                      email: email, password: password);
                                  if (newUser != null) {
                                    Navigator.pushNamed(context, Done.id);
                                  }
                                } catch (e) {
                                  print(e.code);
                                  if (e.code == 'ERROR_WRONG_PASSWORD') {
                                    setState(() {
                                      _wrongPassword = true;
                                    });
                                  } else {
                                    setState(() {
                                      emailText = 'User doesn\'t exist';
                                      passwordText = 'Please check your email';

                                      _wrongPassword = true;
                                      _wrongEmail = true;
                                    });
                                  }
                                }
                              },
                              child: Center(
                                child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                              ),
                            ),
                          )),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                          FadeAnimation(1.7, Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Don\'t have an account?',
                                style: TextStyle(fontSize: 15.0,color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, RegisterPage.id);
                                },
                                child: Text(
                                  ' Signup',
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

