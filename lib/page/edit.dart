import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

class EditPage extends StatefulWidget{
  String _dempartment;
  String _category;
  Article cur_article;
  EditPage(this.cur_article, this._dempartment, this._category);
  @override
  _EditPage createState() => _EditPage();
}
class _EditPage extends State <EditPage>{

  @override
  String _curNickname = "";
  String _curSchool = "";
  TextEditingController titleController = new TextEditingController();
  TextEditingController bodyController = new TextEditingController();
  void initState() {
    titleController.text = widget.cur_article.title.toString();
    bodyController.text = widget.cur_article.body.toString();
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
            IconButton(
                onPressed: (){
                  updateValue("article_${widget._category}", widget.cur_article.article_id.toString(), 'title', titleController.text);
                  updateValue("article_${widget._category}", widget.cur_article.article_id.toString(), 'body', bodyController.text);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.save)
            ),
          ],
        ),
        body:Column(
          children: [
            SizedBox(height:20),
            Container(
              padding: EdgeInsets.only(right:20),
              alignment: Alignment.centerRight,
              child:Text(widget.cur_article.createdTime),
            ),
            Container(
              width:MediaQuery.of(context).size.width-40,

              child:TextFormField(
                keyboardType: TextInputType.text ,
                controller: titleController,

                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                ),
                // The validator receives the text that the user has entere
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
              width:MediaQuery.of(context).size.width-40,

              child:TextFormField(
                maxLines: 10,
                keyboardType: TextInputType.text ,
                controller: bodyController,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                ),
                // The validator receives the text that the user has entere
              ),
            ),
          ],
        )
    );
  }
}
Future<void> updateValue(String collName, String docId, String type, dst) async{
  FirebaseFirestore.instance.collection(collName).doc(docId).update({type: dst});
}
