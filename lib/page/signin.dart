import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogether/page/home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dogether/page/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
Map <String, String> departmentMap = {"컴퓨터공학과":"computer_science"};
class SignInPage extends StatelessWidget{
  @override

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Column(
          children: [
            SizedBox(height:200),
            Container(
              child:Image.asset("assets/images/signin/logo.png"),
            ),
            InkWell(
              child:_LoginButtonWidget(),
              onTap: (){
                signInWithGoogle();

                _isAlreadyUser().then((bool result){
                  if(!result) {
                    addGoogleUser(FirebaseAuth.instance.currentUser?.uid.toString(),
                        FirebaseAuth.instance.currentUser?.displayName);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  }else{
                    Navigator.push(
                      context,
                      //MaterialPageRoute(builder: (context) => SignUpPage()),
                      MaterialPageRoute(builder: (context) => HomePage("computer_science")),
                    );
                  }
                });
              },
            )
          ],
        )
      )
    );
  }
}
class _LoginButtonWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width :MediaQuery.of(context).size.width-130,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color:Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            spreadRadius: 0,
            blurRadius: 5.0,
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      child:Row(
        children: [
          SizedBox(width:20),
          Container(
            width:60,
            height:60,
            child:Image.asset('assets/images/signin/googlelogo.png'),
          ),
          Container(
            child:Text("Login with Google",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          )
        ],
      )
    );

  }

}

Future <void> addGoogleUser(uid, name) async{
  var doc = FirebaseFirestore.instance.collection('users').doc(uid);
  doc.set({
    'name' : name,
    'uid' : uid,
  });
}

Future<bool> _isAlreadyUser() async {
  var docSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid.toString()).get();
  if(docSnapshot.exists) return true;
  return false;
}