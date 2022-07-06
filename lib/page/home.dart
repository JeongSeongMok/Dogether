import 'dart:async';
import 'package:dogether/page/mypage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'addBook.dart';
import 'detail.dart';
import 'list.dart';
List <Article> Articles = [];
List <Book> Books = [];
final List <String> adLink = ["http://www.handong.edu","https://programmers.co.kr/competitions/2465","https://programmers.co.kr/competitions/2363" ];
class HomePage extends StatefulWidget{
  String _dempartment;
  HomePage(this._dempartment);
  @override
  _HomePage createState() => _HomePage();
}
class _HomePage extends State <HomePage>{

  
  final List<String> images = <String>['assets/images/signin/googlelogo.png','assets/images/signin/logo.png'];
  String _currCategory = 'free';
  //final controller = Get.put(ArticleController());

  @override
  void initState() {
    //controller.getArticle("article_free");
    getArticle("article_free");
    getBook();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar:AppBar(
          backgroundColor: Colors.green[200],
          title :Container(
            padding: EdgeInsets.only(left:40),
            width:200,
            child: Image.asset("assets/images/home/${widget._dempartment}.png"),
          ),
          actions: [
            IconButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPage()),
                  );
                },
                icon: Icon(Icons.person),
            )
          ],
        ),
        body:Center(
          child: Column(
            children: [
              SizedBox(height:20),
              Container(
                width : MediaQuery.of(context).size.width-60,
                color: Colors.white,
                height:200,
                child:PageView.builder(
                  controller: PageController(initialPage: 1),
                  itemCount: 3,
                  itemBuilder : (context, index){
                    return InkWell(
                      onTap: (){
                        _launchURL(adLink[index]);
                      },
                      child:Stack(
                        children: [
                          Container(
                              child:Image(image:FirebaseImage('gs://dogether-3fe02.appspot.com/ad/${index+1}.png')
                                ,fit: BoxFit.fill,)
                          ),
                          Container(
                            color:Colors.white,
                            width:30,
                            height:20,
                            padding: EdgeInsets.only(right:5, top:5),
                            child:Container(
                              color: Colors.white,
                              child: Text("${index+1}/3"),
                            ),
                            alignment: Alignment.topRight,
                          ),

                        ],
                      )
                    );
                  }
                )
              ),
              SizedBox(height:20),
              Container(
                width: MediaQuery.of(context).size.width-40,
                child:Row(
                  children: [
                    InkWell(
                      child:Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: (_currCategory=='free')?Colors.green.withOpacity(0.5):Colors.green.withOpacity(0.0),
                                spreadRadius: 2,
                                blurRadius: 15,
                                offset: Offset(0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          width:(MediaQuery.of(context).size.width-60)/3,
                          child:Image.asset('assets/images/home/article_free.png')
                      ),
                      onTap: (){
                        setState(() {
                          getArticle("article_free");
                          //controller.getArticle("article_free");
                          _currCategory="free";
                        });
                      },
                    ),
                    SizedBox(width:10),
                    InkWell(
                      child:Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: (_currCategory=='employment')?Colors.green.withOpacity(0.5):Colors.green.withOpacity(0.0),
                                spreadRadius: 2,
                                blurRadius: 15,
                                offset: Offset(0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          width:(MediaQuery.of(context).size.width-60)/3,
                          child:Image.asset('assets/images/home/article_employment.png')
                      ),
                      onTap: (){
                        setState(() {
                          getArticle("article_employment");
                          //controller.getArticle("article_employment");
                          _currCategory="employment";
                        });
                      },
                    ),
                    SizedBox(width:10),
                    InkWell(
                      child:Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: (_currCategory=='contest')?Colors.green.withOpacity(0.5):Colors.green.withOpacity(0.0),
                                spreadRadius: 2,
                                blurRadius: 15,
                                offset: Offset(0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          width:(MediaQuery.of(context).size.width-60)/3,
                          child:Image.asset('assets/images/home/article_contest.png')
                      ),
                      onTap: (){
                        setState(() {
                          getArticle("article_contest");
                          //controller.getArticle("article_contest");
                          _currCategory="contest";
                        });
                      },
                    ),
                  ],
                )
              ),
              Row(children: [
                SizedBox(width: MediaQuery.of(context).size.width-100,),
                Container(
                  height:30,
                    child:
                TextButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListPage(widget._dempartment, _currCategory)),
                  );
                }, child:Text("more", style:TextStyle(color:Colors.green, fontWeight: FontWeight.bold))))
              ],),
               Expanded(
                child:Container(

                  width:MediaQuery.of(context).size.width-40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color:Colors.green, width: 2),
                  ),
                  padding:EdgeInsets.only(left:40, top:7),
                  child:ListView.builder(
                    itemCount: Articles.length,
                    itemBuilder: (context, index){
                      return InkWell(
                        child:Container(
                            margin: EdgeInsets.only(top:10),
                            child:Row(
                              children: [
                                Container(
                                  width:MediaQuery.of(context).size.width-190,
                                  child:Text(Articles[index].title),
                                ),
                                Container(
                                  width:100,
                                  child:Text(Articles[index].nickname,
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
                            MaterialPageRoute(builder: (context) => DetailPage(Articles[index], widget._dempartment, _currCategory)),
                          );
                        },
                      );
                    },
                  )
                )
              ),
              SizedBox(height:5),
              Row(
                children: [
                  Container(
                    padding:EdgeInsets.only(left:20),
                    alignment: Alignment.centerLeft,
                    height:40,
                    width:200,
                    child:Image.asset("assets/images/home/recommend.png", fit:BoxFit.fill),
                  ),
                  SizedBox(width : MediaQuery.of(context).size.width-265),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddBookPage()),
                      );
                    },
                    child:Icon(Icons.add, color:Colors.green),
                  )
                ],
              ),
              Container(

                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color:Colors.green, width: 2),
                ),
                height: 154,
                width:MediaQuery.of(context).size.width-36,

                child: PageView.builder(
                    controller: PageController(initialPage: 0),
                    itemCount: Books.length,
                    itemBuilder : (context, index){
                      return InkWell(
                          child:Stack(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width:MediaQuery.of(context).size.width-150,
                                    height:150,
                                    child:Column(
                                      children: [
                                        SizedBox(height:30),
                                        Container(
                                          padding: EdgeInsets.only(left:5),
                                          alignment: Alignment.centerLeft,
                                          child : Text(Books[index].title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height:10),
                                        Container(
                                          height:70,
                                          padding: EdgeInsets.only(left:5),
                                          alignment: Alignment.centerLeft,
                                          child:Text(Books[index].body,
                                            overflow:  TextOverflow.ellipsis,
                                          )
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(right:5),
                                          alignment: Alignment.centerRight,
                                          child : Text(Books[index].nickname),
                                        ),
                                      ],
                                    )
                                  ),
                                  Container(
                                      height:150,
                                      width:110,
                                      child:Image(image:FirebaseImage('gs://dogether-3fe02.appspot.com/book/${index+1}.png')
                                        ,fit: BoxFit.fill,)
                                  ),
                                ],
                              ),

                              Container(
                                color:Colors.white,
                                width:30,
                                height:20,
                                padding: EdgeInsets.only(right:5, top:5),
                                child:Container(
                                  color: Colors.white,
                                  child: Text("${index+1}/${Books.length}"),
                                ),
                                alignment: Alignment.topRight,
                              ),

                            ],
                          )
                      );
                    }
                ),
              ),
              SizedBox(height:10),
            ],
          )
        )
    );
  }
}

class Article {
  Article({required this.article_id, required this.uid, required this.category, required this.createdTime, required this.body, required this.title, required this.nickname});
  int article_id;
  String category;
  String uid;
  String createdTime;
  String body;
  String title;
  String nickname;
}
class Book {
  Book({required this.book_id, required this.title, required this.nickname, required this.body});
  int book_id;
  String nickname;
  String title;
  String body;
}
Future <void> getArticle(articleCategory) async{
  StreamSubscription<QuerySnapshot>? _productsSubscription;
  FirebaseAuth.instance.userChanges().listen((user) {
    if (user != null) {
      _productsSubscription=FirebaseFirestore.instance
          .collection(articleCategory.toString())
          .orderBy('createdTime')
          .snapshots()
          .listen((snapshot) {
        Articles = [];
        for (final document in snapshot.docs) {
          Articles.add(
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

Future <void> getBook() async{
  StreamSubscription<QuerySnapshot>? _productsSubscription;
  FirebaseAuth.instance.userChanges().listen((user) {
    if (user != null) {
      _productsSubscription=FirebaseFirestore.instance
          .collection('book')
          .orderBy('book_id')
          .snapshots()
          .listen((snapshot) {
        Books = [];
        for (final document in snapshot.docs) {
          Books.add(
            Book(
              body : document.data()['body'] as String,
              book_id: document.data()['book_id'],
              nickname : document.data()['nickname'] as String,
              title : document.data()['title'] as String,
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

Future <String> getValue(collName, docId, String type) async{
  var ret;
  var docSnapshot = await FirebaseFirestore.instance.collection(collName).doc(docId).get();
  if (docSnapshot.exists) {
    Map<String, dynamic> data = docSnapshot.data()!;
    // You can then retrieve the value from the Map like this:
    ret = data[type];
  }
  return ret.toString();
}
void _launchURL(_url) async {
  if (!await launch(_url)) throw 'Could not launch $_url';
}
