import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'home.dart';
TextEditingController titleController = TextEditingController();
TextEditingController bodyController = TextEditingController();
String _curNickname ='';
class AddPage extends StatefulWidget{
  String _dempartment;
  String _category;
  AddPage(this._dempartment, this._category);
  @override
  _AddPage createState() => _AddPage();
}
class _AddPage extends State <AddPage>{
  @override

  void initState() {
    getValue("users", FirebaseAuth.instance.currentUser?.uid.toString(), "nickname").then((result){
      setState(() {
        _curNickname = result;
      });
    });
    titleController.text = "";
    bodyController.text = "";
    super.initState();
  }
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:AppBar(
        backgroundColor: Colors.green[200],
        title :Container(
          padding: EdgeInsets.only(left:10),
          width:230,
          child: Image.asset("assets/images/list/${widget._dempartment}_article_${widget._category}.png"),
        ),

      ),
      body:Center(
        child:Column(
          children: [
            SizedBox(height:10),
            Container(
              child:TextFormField(
                keyboardType: TextInputType.text ,
                controller: titleController,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        color: Colors.green,
                        width:2,
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        color: Colors.green,
                        width:2,
                      )
                  ),
                  filled: true,
                  labelText: "글 제목",
                ),
              ),
            ),
            SizedBox(height:15),
            Text("글 내용"),
            Container(

              child:TextFormField(
                maxLines: 10,
                keyboardType: TextInputType.text ,
                controller: bodyController,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        color: Colors.green,
                        width:2,
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        color: Colors.green,
                        width:2,
                      )
                  ),
                  filled: true,

                ),
              ),
            ),
            InkWell(
              onTap: (){
                _getNewIdx('${widget._category}').then((result){
                  addProduct(widget._category, result, FirebaseAuth.instance.currentUser?.uid.toString(), bodyController.text, titleController.text);
                });
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child:Container(
                width:80,
                child:Image.asset("assets/images/add/save.png"),
              )
            )
          ],
        )
      )
    );
  }
}

Future<void> addProduct(category, id, uid, body, title) async{
  var doc_id = id.toString();
  var doc = FirebaseFirestore.instance.collection('article_${category}').doc(doc_id);
  doc.set({
    'article_id': int.parse(doc_id),
    'category': category,
    'body': body,
    'title': title,
    'uid' : uid,
    'createdTime' : DateFormat('yy.MM.dd HH:mm:ss').format(DateTime.now()),
    'nickname' : _curNickname,
  });
}



Future <int> _getNewIdx(category) async{
  int idx = 1;
  while(true){
    final snapshot = await FirebaseFirestore.instance.collection('article_${category}').doc('$idx').get();
    if(snapshot.exists) {
      idx = idx+1;
    } else {
      break;
    }
  }
  return idx;
}
