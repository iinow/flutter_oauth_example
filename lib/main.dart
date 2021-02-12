import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'dart:io';

import 'package:oauth2/oauth2.dart' as oauth2;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _isLoggedIn = false;
  final _googleSignIn = GoogleSignIn(scopes: ['email']);

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _login() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        return;
      }
      setState(() {
        _isLoggedIn = true;
      });
    } catch (err) {
      print(err);
    }
  }

  void _logout() async {
    _googleSignIn.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        child: _isLoggedIn
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    _googleSignIn.currentUser.photoUrl,
                    height: 50.0,
                    width: 50.0,
                  ),
                  Text(_googleSignIn.currentUser.displayName),
                  Text(_googleSignIn.currentUser.email),
                  OutlineButton(
                    child: Text('Logout'),
                    onPressed: () {
                      _logout();
                    },
                  ),
                ],
              )
            : Center(
                child: OutlineButton(
                  child: Text('Login with Google'),
                  onPressed: () {
                    _login();
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Future<void> redirect(Uri url) async {
  print('url: $url');
}

// Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text(
//                     'You have pushed the button this many times:',
//                   ),
//                   Text(
//                     '$_counter',
//                     style: Theme.of(context).textTheme.headline4,
//                   ),
//                   RaisedButton(
//                     onPressed: () async {
//                       final authorizationEndpoint = Uri.parse(
//                           'http://iinow.synology.me:7711/oauth/github');
//                       final tokenEndpoint =
//                           Uri.parse('http://iinow.synology.me:7711');
//                       final redirectUrl = Uri.parse(
//                           'http://iinow.synology.me:7711/oauth/github/callback');

//                       var clientId = '46d7f30dfe4e000b5f83';
//                       var clientSecret =
//                           '6134dd8bfb91525e286f54be24ad1166aedad5a8';

//                       var grant = oauth2.AuthorizationCodeGrant(
//                           clientId, authorizationEndpoint, tokenEndpoint,
//                           secret: clientSecret);

//                       var authroizationUrl =
//                           grant.getAuthorizationUrl(redirectUrl);

//                       await redirect(authroizationUrl);

//                       Fluttertoast.showToast(
//                           msg: "This is Center Short Toast",
//                           toastLength: Toast.LENGTH_SHORT,
//                           gravity: ToastGravity.BOTTOM,
//                           timeInSecForIosWeb: 1,
//                           backgroundColor: Colors.red,
//                           textColor: Colors.white,
//                           fontSize: 16.0);
//                     },
//                     child: Text('그냥 테스트'),
//                   )
//                 ],
//               )
