import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Authentication',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Authentication'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  String _imageUrl;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text("Google-SignIn"),
              onPressed: () => _gSignIn(),
              color: Colors.red,
            ),
            FlatButton(
              child: Text("Signin with Email"),
              onPressed: () => {},
              color: Colors.orange,
            ),
            FlatButton(
              onPressed: () => _createUser(),
              child: Text("Create Account"),
              color: Colors.blue,
            ),
            FlatButton(
              onPressed: () => _logOut(),
              child: Text("Sign Out"),
              color: Colors.greenAccent,
            ),
            new Image.network(
                _imageUrl == null || _imageUrl.isEmpty ? "https://images.unsplash.com/photo-1486565273886-f8309bda62b6?ixlib=rb-0.3.5&s=ea2bdbe674ed5c1558d24c9c08af2891&auto=format&fit=crop&w=500&q=60" : _imageUrl,
              width: 250.0,
              height: 250.0,
            )
          ],
        ),
      )
    );
  }
  Future<FirebaseUser> _gSignIn() async{
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken
    );
    print("user is: ${user.email} ${user.displayName}");
    setState(() {
      _imageUrl = user.photoUrl;
    });
    return user;
  }

  Future _createUser() async{
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: "aksjames@gmail.com", password: "test123456").then((user){
      print("User Created ${user.displayName}");
      print("Email: ${user.email}");
    });
  }

  _logOut() {
    setState(() {
      _googleSignIn.signOut();
      _imageUrl = "https://images.unsplash.com/photo-1486565273886-f8309bda62b6?ixlib=rb-0.3.5&s=ea2bdbe674ed5c1558d24c9c08af2891&auto=format&fit=crop&w=500&q=60";
    });
  }
}
