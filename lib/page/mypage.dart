import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_image/firebase_image.dart';
import 'detail.dart';
import 'home.dart';
String _curNickname = "";
List <Article> MyArticles = [];
class MyPage extends StatefulWidget{
  @override
  _MyPage createState() => _MyPage();
}
class _MyPage extends State <MyPage>{
  @override

  void initState() {
    getMyArticle();
    getValue("users", FirebaseAuth.instance.currentUser?.uid.toString(), "nickname").then((result){
      setState(() {
        _curNickname = result;
      });
    });
    super.initState();
  }

  String? imageURL = FirebaseAuth.instance.currentUser?.photoURL.toString();
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:AppBar(
        backgroundColor: Colors.green[200],
        title :Container(
          padding: EdgeInsets.only(left:80),
          height:35,
          child: Image.asset("assets/images/mypage/myinfo.png"),
        ),
      ),

      body:Center(
        child: Column(
          children: [
            SizedBox(height:30),
            Container(
              child:Image.network(imageURL!),
            ),
            SizedBox(height:30),
            Container(
              width:MediaQuery.of(context).size.width-100,
              child:Divider(
                thickness: 2,
                color : Colors.green,
              ),
            ),
            SizedBox(height:10),
            Container(
              child:Text(_curNickname,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height:50),
            Container(
              padding: EdgeInsets.only(left:20),
              alignment: Alignment.centerLeft,
              child:Text("내가 쓴 글",
                style: TextStyle(fontSize: 17,
                ),
              ),
            ),
            SizedBox(height:10),
            Expanded(
              child:Container(
                width:MediaQuery.of(context).size.width-40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color:Colors.green, width: 2),
                ),
                padding:EdgeInsets.only(left:40, top:7),
                child:ListView.builder(
                  itemCount: MyArticles.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      child:Container(
                          margin: EdgeInsets.only(top:10),
                          child:Row(
                            children: [
                              Container(
                                width:MediaQuery.of(context).size.width-190,
                                child:Text(MyArticles[index].title),
                              ),
                              Container(
                                width:100,
                                child:Text(MyArticles[index].nickname,
                                    style:TextStyle(
                                      fontWeight: FontWeight.bold,
                                  )),
                              ),
                            ],
                          )
                      ),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailPage(MyArticles[index], "computer_science", MyArticles[index].category.toString())),
                        );
                      },
                    );
                  },
                )
              )
            ),
          ],
        ),
      )
    );
  }
}

Future <void> getMyArticle() async{
  StreamSubscription<QuerySnapshot>? _productsSubscription;
  FirebaseAuth.instance.userChanges().listen((user) {
    if (user != null) {
      _productsSubscription=FirebaseFirestore.instance
          .collection("article_free")
          .orderBy('createdTime')
          .snapshots()
          .listen((snapshot) {
        MyArticles = [];
        for (final document in snapshot.docs) {
          if(document.data()['uid'].toString() != FirebaseAuth.instance.currentUser?.uid.toString()) continue;
          MyArticles.add(
            Article(
              article_id: document.data()['article_id'],
              uid: document.data()['uid'] as String,
              category: document.data()['category'] as String,
              body: document.data()['body'] as String,
              title : document.data()['title'] as String,
              createdTime: document.data()['createdTime'] as String,
              nickname : document.data()['nickname'] as String,
            ),
          );
        }
      });
    }else {
      Articles = [];
      _productsSubscription?.cancel();
    }
  });

  FirebaseAuth.instance.userChanges().listen((user) {
    if (user != null) {
      _productsSubscription=FirebaseFirestore.instance
          .collection("article_employment")
          .orderBy('createdTime')
          .snapshots()
          .listen((snapshot) {
        for (final document in snapshot.docs) {
          if(document.data()['uid'].toString() != FirebaseAuth.instance.currentUser?.uid.toString()) continue;
          MyArticles.add(
            Article(
              article_id: document.data()['article_id'],
              uid: document.data()['uid'] as String,
              category: document.data()['category'] as String,
              body: document.data()['body'] as String,
              title : document.data()['title'] as String,
              createdTime: document.data()['createdTime'] as String,
              nickname : document.data()['nickname'] as String,
            ),
          );
        }
      });
    }else {
      Articles = [];
      _productsSubscription?.cancel();
    }
  });

  FirebaseAuth.instance.userChanges().listen((user) {
    if (user != null) {
      _productsSubscription=FirebaseFirestore.instance
          .collection("article_contest")
          .orderBy('createdTime')
          .snapshots()
          .listen((snapshot) {

        for (final document in snapshot.docs) {
          if(document.data()['uid'].toString() != FirebaseAuth.instance.currentUser?.uid.toString()) continue;
          MyArticles.add(
            Article(
              article_id: document.data()['article_id'],
              uid: document.data()['uid'] as String,
              category: document.data()['category'] as String,
              body: document.data()['body'] as String,
              title : document.data()['title'] as String,
              createdTime: document.data()['createdTime'] as String,
              nickname : document.data()['nickname'] as String,
            ),
          );
        }
      });
    }else {
      Articles = [];
      _productsSubscription?.cancel();
    }
  });
}