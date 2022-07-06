import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add.dart';
import 'detail.dart';
import 'home.dart';

class ListPage extends StatefulWidget{
  String _dempartment;
  String _category;
  ListPage(this._dempartment, this._category);
  @override
  _ListPage createState() => _ListPage();
}
class _ListPage extends State <ListPage> {
  @override
  void initState() {
    getArticle("article_${widget._category}");
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPage(widget._dempartment, widget._category)),
                  );
                },
                icon: Icon(Icons.add)),
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(left:30, top:10),
          child:ListView.builder(
            itemCount: Articles.length,
            itemBuilder: (context, index){
              return InkWell(
                child:Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top:10),
                        child:Row(
                          children: [
                            Container(
                              width:MediaQuery.of(context).size.width-190,
                              child:Text(Articles[index].title,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              width:100,
                              child:Text(Articles[index].nickname,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width-60,
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey[300],
                      ),
                    )

                  ],
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailPage(Articles[index], widget._dempartment, widget._category)),
                  );
                },
              );
            },
          )
        )
    );
  }
}
