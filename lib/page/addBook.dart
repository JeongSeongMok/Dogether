import 'dart:io';
import 'dart:async';
import 'dart:ui';
import 'package:dogether/page/add.dart';
import 'package:learning_input_image/learning_input_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learning_text_recognition/learning_text_recognition.dart';
import 'home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
TextEditingController titleController = TextEditingController();
String _body = '';
String _curNickname ='';
bool confirm = false;
class AddBookPage extends StatefulWidget{
  @override
  _AddBookPage createState() => _AddBookPage();
}
class _AddBookPage extends State <AddBookPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider(
      create: (_) => TextRecognitionState(),
      child: TextRecognitionPage(),
    );
  }
}
Future<void> addBook(id, nickname, body, title) async{
  var doc_id = id.toString();
  var doc = FirebaseFirestore.instance.collection('book').doc(doc_id);
  doc.set({
    'book_id' : int.parse(doc_id),
    'body': body,
    'title': title,
    'nickname' : nickname,
  });
}

Future <int> _getNewIdx(category) async{
  int idx = 1;
  while(true){
    final snapshot = await FirebaseFirestore.instance.collection('${category}').doc('$idx').get();
    if(snapshot.exists) {
      idx = idx+1;
    } else {
      break;
    }
  }
  return idx;
}

class TextRecognitionPage extends StatefulWidget {
  @override
  _TextRecognitionPageState createState() => _TextRecognitionPageState();
}

class _TextRecognitionPageState extends State<TextRecognitionPage> {
  TextRecognition? _textRecognition = TextRecognition(
      options: TextRecognitionOptions.Korean
  );

  /* TextRecognition? _textRecognition = TextRecognition(
    options: TextRecognitionOptions.Japanese
  ); */
  final picker = ImagePicker();
  String _imageSrc = "tmp";
  @override
  void dispose() {
    _textRecognition?.dispose();
    super.dispose();
  }


  Future<void> _startRecognition(InputImage image) async {
    TextRecognitionState state = Provider.of(context, listen: false);

    if (state.isNotProcessing) {
      state.startProcessing();
      state.image = image;
      state.data = await _textRecognition?.process(image);
      state.stopProcessing();
    }
  }
  Future _putImage(id, File _file) async {
    final ref = FirebaseStorage.instance.ref().child('book').child('$id.png');
    await ref.putFile(_file);
  }
  Future _getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery);

    setState(() {
      _imageSrc = pickedFile!.path;
    });
  }
  @override
  void initState() {
    confirm = false;
    titleController.text = '';
    _body = '';
    getValue("users", FirebaseAuth.instance.currentUser?.uid.toString(), "nickname").then((result){
      setState(() {
        _curNickname = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer <TextRecognitionState> (
      builder: (_, state, __){
        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar:AppBar(
              backgroundColor: Colors.green[200],
              title :Container(
                padding: EdgeInsets.only(left:50),
                width:190,
                child: Image.asset("assets/images/addbook/addbook.png"),
              ),
              actions: [
                IconButton(
                  onPressed: (){
                    _getNewIdx("book").then((result){
                      _putImage(result, File(_imageSrc));
                      addBook(result, _curNickname, _body, titleController.text);
                    });
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.save),
                )
              ],
            ),
            body:Column(
              children: [
                Expanded(
                  child: InputCameraView(
                    mode: InputCameraMode.gallery,
                    // resolutionPreset: ResolutionPreset.high,
                    title: 'Text Recognition',
                    onImage: _startRecognition,
                    overlay: Consumer<TextRecognitionState>(
                      builder: (_, state, __) {
                        if (state.isNotEmpty) {
                          return Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                              decoration: BoxDecoration(
                                //color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              ),

                            ),
                          );
                        }

                        return Container();
                      },
                    ),
                  ),
                ),
                Center(
                    child:Row(
                      children: [
                        InkWell(
                          child:Container(
                            width:100,
                            child:Image.asset("assets/images/addbook/fix.png"),
                          ),
                          onTap: (){
                            _getImage();
                          },
                        ),
                        InkWell(
                          child:Container(
                            width:100,
                            child:Image.asset("assets/images/addbook/fix2.png"),
                          ),
                          onTap: (){
                            setState(() {
                              confirm = true;
                              _body = state.text;
                            });
                          },
                        )
                      ],
                    )
                ),
                TextFormField(
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
                    labelText: "도서 제목",
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(left:15),
                  alignment: Alignment.centerLeft,
                  height:200,
                  child: Text((state.isNotEmpty)?state.text:"",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: (confirm)?FontWeight.bold:FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(height:50),
              ],
            )
        );
      },
    );
  }
}

class TextRecognitionState extends ChangeNotifier {
  InputImage? _image;
  RecognizedText? _data;
  bool _isProcessing = false;

  InputImage? get image => _image;
  RecognizedText? get data => _data;
  String get text => _data!.text;
  bool get isNotProcessing => !_isProcessing;
  bool get isNotEmpty => _data != null && text.isNotEmpty;

  void startProcessing() {
    _isProcessing = true;
    notifyListeners();
  }

  void stopProcessing() {
    _isProcessing = false;
    notifyListeners();
  }

  set image(InputImage? image) {
    _image = image;
    notifyListeners();
  }

  set data(RecognizedText? data) {
    _data = data;
    notifyListeners();
  }
}
