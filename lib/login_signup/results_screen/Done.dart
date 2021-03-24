import 'package:ebook_app/models/category.dart';
import 'package:ebook_app/theme/theme_notifier.dart';
import 'package:ebook_app/util/popup_alert.dart';
import 'package:ebook_app/util/routes.dart';
import 'package:ebook_app/view_models/home_page.dart';
import 'package:ebook_app/views/explore.dart';
import 'package:ebook_app/views/genre.dart';
import 'package:ebook_app/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

FirebaseUser loggedInUser;

// ignore: must_be_immutable
class Done extends StatefulWidget {
  static String id = '/Done';

  @override
  _DoneState createState() => _DoneState();
}

class _DoneState extends State<Done> {

  final _auth = FirebaseAuth.instance;

  void getCurrentUser() async {
        try {
          //TODO 10 : New user variable to check if a newUser is signed in
          final user = await _auth.currentUser();
          //Equal to null if no user is signed in, else equal to new user details
          //TODO 11 : Use if else block to get the loggedInUser details
//      if (user.toString() != null) {
          loggedInUser = user;
//      }
        } catch (e) {
          print(e);
    }
  }
  PageController _pageController;
  int _page = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (BuildContext context, HomeProvider homeProvider, Widget child) {
        return WillPopScope(
          onWillPop: () => Dialogs().showExitDialog(context),
          child: Scaffold(
            appBar: AppBar(
              title: new Text('EbookApp'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Provider.of<Settings>(context).isDarkMode
                      ? Feather.sun
                      : Feather.moon),
                  onPressed: () {
                    changeTheme(
                        Provider.of<Settings>(context, listen: false).isDarkMode ? false : true,
                        context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.account_circle,),
                  iconSize: 37.0,
                  onPressed: () {
                    _modelBottomSheet(context);
                  },
                ),
              ],
            ),
            drawer: new Drawer(
              child:Column(
                  mainAxisAlignment:MainAxisAlignment.start,
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children:<Widget>[
                    Expanded(
                      flex:0,
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                          color: Provider.of<Settings>(context).isDarkMode
                              ? Colors.teal[800]:Colors.lime[800],
                        ),
                        child:Padding(
                          padding: const EdgeInsets.fromLTRB(15,60,15,30),
                          child: Center(
                            child: Column(
                              children:<Widget>[
                                Text('Catagories',style: (TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0
                                )),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex:1,
                      child: SingleChildScrollView(
                          child: ListView.separated(
//                        primary: false,
//                        scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              Link link = homeProvider.top.feed.link[index];
                              return InkWell(
                                onTap: () {
                                  MyRouter.pushPage(
                                    context,
                                    Genre(
                                      title: '${link.title}',
                                      url: link.href,
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    '${link.title}',
                                    style: TextStyle(
                                      color: Provider.of<Settings>(context).isDarkMode
                                          ? Colors.white:Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: homeProvider?.top?.feed?.link?.length ?? 0,
                            separatorBuilder: (BuildContext context, int index) {
                              return Divider();
                            },
                          )
                      ),
                    )
                  ]
              ),
            ),
            body: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: onPageChanged,
              children: <Widget>[
                Home(),
                Explore(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Theme
                  .of(context)
                  .primaryColor,
              selectedItemColor: Theme
                  .of(context)
                  .accentColor,
              unselectedItemColor: Colors.grey[500],
              elevation: 20,
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Feather.home,
                  ),
                  title: Text(
                    'Home',
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Feather.compass,
                  ),
                  title: Text(
                    'Explore',
                  ),
                ),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          ),
        );
      },
    );
  }
  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  void _modelBottomSheet(context) {
    showModalBottomSheet(context: context, builder: (BuildContext bc) {
      return Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.3,
        width: MediaQuery
            .of(context)
            .size
            .width * 0.6,
        child: Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
                image: ExactAssetImage(
                  'assets/images/background.png',
                ),
                fit: BoxFit.fitWidth
            ),
          ),
          child: Center(
            child: Column(
                children: <Widget>[
                  SizedBox(height: 15.0,),
                  Text('User Detalis:', style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
                  SizedBox(height: 20.0,),
//                  CircleAvatar(
//                    backgroundImage: _user.photoUrl != null ? NetworkImage(
//                      _user.photoUrl,) : Image.network(
//                        'https://lh3.googleusercontent.com/6UgEjh8Xuts4nwdWzTnWH8QtLuHqRMUB7dp24JYVE2xcYzq4HA8hFfcAbU-R-PC_9uA1'),
//                    radius: 30,
//                  ),
//                  SizedBox(height: 10.0,),
//                  Text(_user.displayName, style: TextStyle(
//                      color: Colors.grey[800],
//                      fontWeight: FontWeight.bold,
//                      fontSize: 20)),
//                  SizedBox(height: 10.0,),
                  Text(loggedInUser.email, style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
                  SizedBox(height: 10.0,),
                  RaisedButton(
                      child: Text('Logout', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                      textColor: Colors.white,
                      color: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                  )
                ]
            ),
          ),
        ),
      );
    });
  }
  void changeTheme(bool set, BuildContext context) {
    Provider.of<Settings>(context, listen: false).setDarkMode(set);
  }
}
