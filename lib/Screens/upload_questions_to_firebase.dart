import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadQuestionsToFirebase extends StatefulWidget {
  const UploadQuestionsToFirebase({Key? key}) : super(key: key);

  @override
  State<UploadQuestionsToFirebase> createState() => _UploadQuestionsToFirebaseState();
}

class _UploadQuestionsToFirebaseState extends State<UploadQuestionsToFirebase> {

  late String yourQuestion, question1, question2, question3, question4;
  late String question = '', q1 = '', q2 = '', q3 = '', q4 = '';
  var myFormKey = GlobalKey<FormState>();
  File? imageFile;
  CollectionReference firstQuiz = FirebaseFirestore.instance.collection("FirstQuiz");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SingleChildScrollView(

          child: Column(
            children: [
              ElevatedButton(onPressed: (){chooseFile();}, child: Text('Chose File')),
              Form(
                key: myFormKey,
                child: Column(
                  children: [
                    SizedBox(height: 11,),

                    TextFormField(
                      validator: (String? txt) {
                        if (txt == null || txt.isEmpty) {
                          return "Please provide your Question";
                        }
                        yourQuestion = txt;
                        return null;
                      },
                      decoration: InputDecoration(
                        label: Text('Enter Your Question'),
                        hintText: 'Your Question',
                      ),

                    ),


                    TextFormField(
                      validator: (String? txt) {
                        if (txt == null || txt.isEmpty) {
                          return "Please provide Question 1";
                        }
                        question1 = txt;
                        return null;
                      },
                      decoration: InputDecoration(
                        label: Text('Enter Question 1'),
                        hintText: 'Question 1',
                      ),

                    ),
                    SizedBox(height: 11,),

                    TextFormField(
                      validator: (String? txt) {
                        if (txt == null || txt.isEmpty) {
                          return "Please provide Question 2";
                        }
                        question2 = txt;
                        return null;
                      },
                      decoration: InputDecoration(
                        label: Text('Enter Question 2'),
                        hintText: 'Question 2',
                      ),

                    ),
                    SizedBox(height: 11,),

                    TextFormField(
                      validator: (String? txt) {
                        if (txt == null || txt.isEmpty) {
                          return "Please provide Question 3";
                        }
                        question3 = txt;
                        return null;
                      },
                      decoration: InputDecoration(
                        label: Text('Enter Question 3'),
                        hintText: 'Question 3',
                      ),

                    ),
                    SizedBox(height: 11,),

                    TextFormField(
                      validator: (String? txt) {
                        if (txt == null || txt.isEmpty) {
                          return "Please provide Question 4";
                        }
                        question4 = txt;
                        return null;
                      },
                      decoration: InputDecoration(
                        label: Text('Enter Question 4'),
                        hintText: 'Question 4',
                      ),

                    ),
                    SizedBox(height: 11,),

                    ElevatedButton(onPressed: () async {
                     if(myFormKey.currentState!.validate())
                       {
                         setState(() async {
                           question = yourQuestion;
                           q1 = question1;
                           q2 = question2;
                           q3 = question3;
                           q4 = question4;

                           UploadTask uploadTask = FirebaseStorage.instance.ref().child("quizImages").child("QuizImage").putFile(imageFile!);
                           TaskSnapshot snapshot = await uploadTask;
                           await snapshot.ref.getDownloadURL().then((value){
                             firstQuiz.add({
                               "Question" : "$question",
                               "answer1": "$q1",
                               "answer2": "$q2",
                               "answer3": "$q3",
                               "correctAnswer": "$q4",
                               "image_url" : value.toString()
                             }).then((value) => {print("All done")})
                                 .catchError((val) {
                               print("$val");
                             });
                           });

                           // imageFile = _file1?.path;
                         });
                       }
                   }, child: Text('Upload')),

                    SizedBox(height: 11,),
                     imageFile != null ? Container(
                      width: double.infinity,
                      height: 200,
                       decoration: BoxDecoration(
                         image: DecorationImage(
                           image: FileImage(File(imageFile!.path))
                         )
                       ),
                    ): Container(color: Colors.red,),

                    Text('$q1'),
                    Text('$q2'),
                    Text('$q3'),
                    Text('$q4'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
  ImagePicker imagePicker = ImagePicker();
  Future chooseFile() async {
    final XFile? _file1 = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(_file1!.path);
    });

  }

}
