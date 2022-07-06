import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit.dart';
import 'home.dart';
import 'package:learning_translate/learning_translate.dart';
import 'package:google_cloud_translation/google_cloud_translation.dart';
class DetailPage extends StatefulWidget{
  String _dempartment;
  String _category;
  Article cur_article;
  DetailPage(this.cur_article, this._dempartment, this._category);
  @override
  _DetailPage createState() => _DetailPage();
}
class _DetailPage extends State <DetailPage>{

  @override

  String _curNickname = "";
  String _curSchool = "";
  String _curBody = "";
  String _originBody ="";
  void initState() {
    _curBody = widget.cur_article.body;
    _originBody = _curBody;
    print("andisdafsda");
    getValue("users", widget.cur_article.uid.toString(), "nickname").then((result){
      setState(() {
        _curNickname = result;
      });
    });
    getValue("users", widget.cur_article.uid.toString(), "school").then((result){
      setState(() {
        _curSchool= result;
      });
    });
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:AppBar(
        backgroundColor: Colors.green[200],
        title :Container(
          padding: EdgeInsets.only(left:10),
          width:230,
          child: Image.asset("assets/images/list/${widget._dempartment}_article_${widget._category}.png"),
        ),
        actions: [
          Visibility(
            visible: (widget.cur_article.uid == FirebaseAuth.instance.currentUser?.uid.toString()),
            child:Row(
              children: [
                IconButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditPage(widget.cur_article, widget._dempartment, widget.cur_article.category)),
                      );

                    },
                    icon: Icon(Icons.edit)
                ),
                IconButton(
                    onPressed: (){
                      delProduct('article_${widget._category}', '${widget.cur_article.article_id}');
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.delete)
                ),
              ],
            )

          ),
        ],
      ),
      body:Column(
        children: [
          SizedBox(height:20),
          Container(

            padding: EdgeInsets.only(left:15),
            child:Row(
              children: [
                InkWell(
                    child:Container(
                      height:25,
                      child: Image.asset("assets/images/detail/kotoen.png"),
                    ),
                    onTap:(){
                      setState(() {
                        _translate(_originBody, "ko", "en").then((result){
                          _curBody = result;
                        });
                      });
                    }
                ),
                SizedBox(width:10),
                InkWell(
                    child:Container(
                      height:25,
                      child: Image.asset("assets/images/detail/entoko.png"),
                    ),
                    onTap:(){
                      setState(() {
                        _translate(_originBody, "en", "ko").then((result){
                          _curBody = result;
                        });
                      });
                    }
                ),
                SizedBox(width:MediaQuery.of(context).size.width-180),
                InkWell(
                  child:Icon(Icons.settings_backup_restore, color: Colors.green,),
                  onTap: (){
                    setState(() {
                      _curBody = _originBody;
                    });
                  },

                ),
              ],
            )
          ),
          Container(
            padding: EdgeInsets.only(right:20),
            alignment: Alignment.centerRight,
            child:Text(widget.cur_article.createdTime),
          ),
          Container(
            padding: EdgeInsets.only(left:20),
            alignment: Alignment.centerLeft,
            child:Text(widget.cur_article.title,
            style: TextStyle(

              fontSize: 20,
            ),
            ),
          ),
          Container(

            //alignment: Alignment.centerLeft,
            width:MediaQuery.of(context).size.width-40,
            child:Divider(
              color: Colors.green,
              thickness: 2,
            ),
          ),
          Container(
            padding: EdgeInsets.only(right:20),
            alignment: Alignment.centerRight,
            child:Column(
              children: [
                Text(_curNickname,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(_curSchool,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            )
          ),
          Container(
            padding: EdgeInsets.only(left:20),
            alignment: Alignment.centerLeft,
            child:Text(_curBody),
          ),

        ],
      )
    );
  }
}

Future<void> delProduct(category, docId) async {
  FirebaseFirestore.instance.collection(category.toString()).doc(docId.toString()).delete();
}

Future<String> _translate(String str, String src, String dst) async {


  Translator translator = Translator(from: src, to: dst);
  String translatedText = await translator.translate(str);
  return translatedText;
}