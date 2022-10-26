import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codeprisma/Screens/upload_questions_to_firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../Controllers/SplashScreenController.dart';
import 'package:path/path.dart' as path;
class RetrieveDataFromFirebase extends StatefulWidget {
  const RetrieveDataFromFirebase({Key? key}) : super(key: key);

  @override
  State<RetrieveDataFromFirebase> createState() => _RetrieveDataFromFirebaseState();
}

class _RetrieveDataFromFirebaseState extends State<RetrieveDataFromFirebase> {
  final splashScreenController1 = Get.find<SplashScreenController>();
  CollectionReference firstQuiz =
      FirebaseFirestore.instance.collection("FirstQuiz");
  CollectionReference secondQuiz =
      FirebaseFirestore.instance.collection("SecondQuiz");
  CollectionReference thirdQuiz =
      FirebaseFirestore.instance.collection("ThirdQuiz");
  var allData  = [];
  int currentQuestion = 1;

  @override
  void initState() {
    fetchAllContact();
    super.initState();
  }

  Future fetchAllContact() async {
    QuerySnapshot querySnapshot = await firstQuiz.get();
    setState(() {
      allData = querySnapshot.docs.map((e) => e.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: () {},
            child: Icon(Icons.share),
          ),
          actions: [
            Container(
              width: 100,
              height: 1,
              color: Colors.orange,
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              width: 100,
              height: 2,
              color: Colors.red,
            ),
            SizedBox(
              width: 10,
            ),
          ],
          // leading: IconButton(
          //   icon: Icon(Icons.share),
          //   onPressed: () {},
          // ),
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Center(child: Text('Menu', style: TextStyle(fontSize: 44),)),
              ),
              ListTile(
                title: const Text('Upload Question'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UploadQuestionsToFirebase()));
                },
              ),
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: allData.isNotEmpty ? ListView.builder(
              itemCount: allData.length,
              itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 320,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 2,
                          offset: Offset(2, 3),
                          blurRadius: 6,
                        ),
                      ],
                    image: DecorationImage(fit: BoxFit.cover,image: NetworkImage(allData[currentQuestion]["image_url"]))
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: ElevatedButton.icon(
                                    onPressed: () {
                                      chooseFile();
                                    },
                                    icon: Icon(Icons.lightbulb_outline),
                                    label: Text('Hint'))),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                child: ElevatedButton.icon(
                                    onPressed: () {

                                    },
                                    icon: Icon(Icons.arrow_forward),
                                    label: Text('Next'))),
                          ],
                        ),
                        myContainer(txt: allData[currentQuestion]["answer1"],onPress: (){goToNextQuestion(val: allData[currentQuestion]["answer1"],i: index);}),
                        myContainer(txt: allData[currentQuestion]["answer2"],onPress: (){goToNextQuestion(val: allData[currentQuestion]["answer2"],i: index);}),
                        myContainer(txt: allData[currentQuestion]["answer3"],onPress: (){goToNextQuestion(val: allData[currentQuestion]["answer3"],i: index);}),
                        myContainer(txt: allData[currentQuestion]["correctAnswer"],onPress: (){goToNextQuestion(val: allData[currentQuestion]["correctAnswer"],i: index);}),
                      ],
                    ),
                  ),
                )
              ],
            );
          }): CircularProgressIndicator())
        );
  }

  goToNextQuestion({String? val, int? i}){
      if(val == allData[i!]["correctAnswer"]){
        print("pass");
      }else{print("fail");}

  }

  myContainer({String? txt, VoidCallback? onPress}) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: double.infinity,
        height: 50,
        margin: EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 2,
                offset: Offset(2, 3),
                blurRadius: 6,
              ),
            ]),
        child: Center(child: Text("$txt")),
      ),
    );
  }

  ImagePicker imagePicker = ImagePicker();
  XFile? _file1;
  Future chooseFile() async {
    _file1 = await imagePicker.pickImage(source: ImageSource.gallery).then((value) async {
      setState(() {_file1 = value;});
      final imagePath = File(_file1!.path);
      UploadTask uploadTask = FirebaseStorage.instance.ref().child("quizImages").child("Quiz6Image").putFile(imagePath);
      TaskSnapshot snapshot = await uploadTask;
       await snapshot.ref.getDownloadURL().then((value){
         firstQuiz.add({
           "Question" : "What is your name",
           "answer1": "ali",
           "answer2": "ahmed",
           "answer3": "ali2",
           "correctAnswer": "fahad",
           "image_url" : value.toString()
         }).then((value) => {print("All done")})
             .catchError((val) {
           print("$val");
         });
       });
    });
  }
}
