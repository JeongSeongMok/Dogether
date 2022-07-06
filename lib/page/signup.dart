import 'package:dogether/page/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home.dart';
String? UID = FirebaseAuth.instance.currentUser?.uid.toString();
String _currentSchool = "한동대학교";
String _currentDepartment = "컴퓨터공학과";
TextEditingController nicknameController = TextEditingController();


class SignUpPage extends StatefulWidget{
  @override
  _SignUpPage createState() => _SignUpPage ();
}

class _SignUpPage extends State <SignUpPage>{
  var _schools = ["한동대학교", "경북대학교", "포스텍"];
  var _departments = ["컴퓨터공학과"];



  @override
  void initState() {
    nicknameController.text = '';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:AppBar(
        backgroundColor: Colors.green[200],
        centerTitle: true,
        title :Container(
          height:80,
          child: Image.asset("assets/images/logo_only.png"),
        ),
      ),
      body:Center(
          child: Column(

            children: [
              Container(

                width:MediaQuery.of(context).size.width-100,
                child:Image.asset("assets/images/signup/signup.png"),

              ),
              SizedBox(height:40),
              Container(
                width:MediaQuery.of(context).size.width-100,
                child:TextFormField(
                  keyboardType: TextInputType.text ,
                  controller: nicknameController,
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
                    labelText: "사용할 닉네임을 적어주세요.",
                  ), // The validator receives the text that the user has entere
                ),
              ),
              SizedBox(height:30),
              Container(
                height:40,
                child:Image.asset("assets/images/signup/selectshcool.png"),
              ),
              Container(
                width:MediaQuery.of(context).size.width-100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color:Colors.green, width: 2),
                ),
                child:FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                          hintText: 'Please select expense',
                          border: OutlineInputBorder(borderSide: BorderSide(
                            color: Colors.white,
                            width:2,
                          ),borderRadius: BorderRadius.circular(20))),
                      isEmpty: _currentSchool == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _currentSchool,
                          isDense: true,
                          onChanged: (String? newValue){
                            setState(() {
                              _currentSchool = newValue!;
                              state.didChange(newValue);
                            });
                          },
                          items: _schools.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                )
              ),
              SizedBox(height:15),
              Container(
                height:40,
                child:Image.asset("assets/images/signup/selectdepartment.png"),
              ),
              Container(
                  width:MediaQuery.of(context).size.width-100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color:Colors.green, width: 2),
                  ),
                  child:FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                            hintText: 'Please select expense',
                            border: OutlineInputBorder(borderSide: BorderSide(
                              color: Colors.white,
                              width:2,
                            ),borderRadius: BorderRadius.circular(20))),
                        isEmpty: _currentDepartment == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _currentDepartment,
                            isDense: true,
                            onChanged: (String? newValue){
                              setState(() {
                                _currentDepartment = newValue!;
                                state.didChange(newValue);
                              });
                            },
                            items: _departments.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  )
              ),
              SizedBox(height:30),
              InkWell(
                child:Container(
                    height:40,
                    child:Image.asset("assets/images/signup/start.png")
                ),
                onTap: (){
                  addFieldUser();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(departmentMap[_currentDepartment.toString()].toString())),
                  );
                },
              )

            ],
          )
      )
    );
  }
}

Future <void> addFieldUser() async{
  var doc = FirebaseFirestore.instance.collection('users').doc(UID.toString());
  doc.set({
    'uid' : UID.toString(),
    'name' :  FirebaseAuth.instance.currentUser?.displayName.toString(),
    'nickname' : nicknameController.text,
    'school' : _currentSchool.toString(),
    'department' : _currentDepartment.toString(),
  });
}


