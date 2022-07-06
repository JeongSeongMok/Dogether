import 'package:dogether/page/signin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future : Firebase.initializeApp(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Center(child : Text("Firebase connection error"));
          }
          if(snapshot.connectionState == ConnectionState.done){
            return GetMaterialApp(
              title: 'Flutter Demo',
              home: SignInPage(),
            );
          }
          return CircularProgressIndicator();
        }
    );

  }
}



