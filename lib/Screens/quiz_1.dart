import 'package:codeprisma/Utility/storedQuestions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:get/get.dart';

class Quiz1 extends StatefulWidget {
  Quiz1({Key? key}) : super(key: key);

  @override
  _Quiz1State createState() => _Quiz1State();
}

class _Quiz1State extends State<Quiz1> {
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  StoredQuestions allQuestions = StoredQuestions();
  var usersPoints = 20;

  @override
  void initState() {
    getStoredPoints();
    getStoredLevel();

    super.initState();
  }

  int i = 0;
  int result = 0;
  int resultWrong = 0;
  int level = 0;
  bool startAgainQiz = true;

  Future<void> questionIndex() async {
    SharedPreferences myLevelSP = await SharedPreferences.getInstance();
    setState(() {
      i++;
      if (i == allQuestions.questions.length) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.white,
          content: Container(
            height: 55,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(child: Text('Quiz is finished '))),
        ));
        startAgainQiz = false;
        getStoredLevel();

        int nLevel = this.level + 1;

          myLevelSP.setInt("LEVEL", nLevel);

        print('ok ok');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white54,
          elevation: 0,
          title: Text(
            'Result: $result / ${allQuestions.questions.length}',
            style: TextStyle(
                color: Colors.green, fontSize: 22, fontWeight: FontWeight.bold),
          ),

          actions: [
            Container(
              color: Colors.white,
              height: 33,
              width: 220,
              child: Row(
              children: [
                Container(
                  width: 100,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                      child: Text(
                        'Points: ${usersPoints}',
                        style: TextStyle(fontSize: 16),
                      )),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  width: 100,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                      child: Text(
                        'Level: $level',
                        style: TextStyle(fontSize: 16),
                      )),
                ),
                SizedBox(
                  width: 8,
                ),
              ],
            ),)
          ],
          // leading: IconButton(
          //   icon: Icon(Icons.share),
          //   onPressed: () {},
          // ),
        ),
        body: Container(
            color: Colors.white54,
            child: startAgainQiz ? Stack(children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  child: Column(
                    children: [
                      // Text('Result: $result / ${allQuestions.questions.length}', style: TextStyle(color: Colors.green, fontSize: 22, fontWeight: FontWeight.bold),),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                          'Q. ${allQuestions.questions[i].yourQuestion} ?',
                          style: TextStyle(fontSize: 25, color: Colors.black,fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        flex: 7,
                        child: Container(
                          padding: EdgeInsets.all(0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22.0),
                            child: Image.asset(
                              '${allQuestions.questions[i].image}',
                              fit: BoxFit.cover,
                              // height: 200.0,
                              // width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            width: myHeight(),
                            child: GridView(
                              // physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 2 / 0.8,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 0,
                                      crossAxisCount: 2),
                              children: [
                                myButtons(
                                    onPress: () {
                                      answerMatching(
                                          txt:
                                              allQuestions.questions[i].option1,
                                          i: i);
                                    },
                                    txt:
                                        '${allQuestions.questions[i].option1}'),
                                myButtons(
                                    onPress: () {
                                      answerMatching(
                                          txt:
                                              allQuestions.questions[i].option2,
                                          i: i);
                                    },
                                    txt:
                                        '${allQuestions.questions[i].option2}'),
                                myButtons(
                                    onPress: () {
                                      answerMatching(
                                          txt:
                                              allQuestions.questions[i].option3,
                                          i: i);
                                    },
                                    txt:
                                        '${allQuestions.questions[i].option3}'),
                                myButtons(
                                    onPress: () {
                                      answerMatching(
                                          txt: allQuestions
                                              .questions[i].correctAnswer,
                                          i: i);
                                    },
                                    txt:
                                        '${allQuestions.questions[i].correctAnswer}'),
                              ]..shuffle(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]) : Center(
              child: Column(
                children: [
                  SizedBox(height: 120,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(margin: EdgeInsets.only(bottom: 10),decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.red, width: 2)), child: Text(' $resultWrong ', style: TextStyle(color: Colors.red, fontSize: 40, fontWeight: FontWeight.bold),)),
                      Text('Times your selection is wrong', style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),),
                    ],
                  ),

                  SizedBox(height: 31,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(margin: EdgeInsets.only(bottom: 10),decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.green, width: 2)), child: Text(' $result ', style: TextStyle(color: Colors.green, fontSize: 40, fontWeight: FontWeight.bold),)),
                      Text('Times is right', style: TextStyle(color: Colors.lightGreen, fontSize: 16, fontWeight: FontWeight.bold),),

                    ],
                  ),
                  SizedBox(height: 80,),

                  SizedBox(child: result! > resultWrong ? Text("Great", style: TextStyle(color: Colors.lightGreen, fontSize: 16, fontWeight: FontWeight.bold)) : Text("Best of luck next time" , style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),),),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: Size(220, 44)),
                      onPressed: (){

                    setState(() {
                      i = 0;
                      resultWrong = 0;
                      result = 0;
                      startAgainQiz = true;
                    });
                  }, child: Text("Start Quiz Again")),
                ],
              ),
            )));
  }









  answerMatching({String? txt, int? i}) async {
    var allQuestion = StoredQuestions();
    if (txt == allQuestion.questions[i!].correctAnswer) {
      // _matchEngine!.currentItem?.like();

      print('correct');
      SharedPreferences mySP = await SharedPreferences.getInstance();
      int n = this.usersPoints + 5;
      setState(() {
        mySP.setInt("POINTS", n);
        result++;
      });

      getStoredPoints();

      questionIndex();

    } else {
      // _matchEngine!.currentItem?.superLike();
      print('wrong');
      SharedPreferences mySP = await SharedPreferences.getInstance();
      int n = this.usersPoints - 5;
      setState(() {
        mySP.setInt("POINTS", n);
        resultWrong++;
      });

      getStoredPoints();

      Get.snackbar("Error", "Wrong Answer",
          colorText: Colors.red,
          duration: Duration(seconds: 1),
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.only(bottom: 50, left: 30, right: 30));

    }
  }

  double myHeight() {
    late double a;
    MediaQuery.of(context).size.width >= 370
        ? a = 374
        : a = MediaQuery.of(context).size.width.toDouble();

    return a;
  }

  Widget myButtons({required VoidCallback? onPress, required String txt}) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPress,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(22)),
          height: myHeight() / 6,
          child: Center(
              child: Text(
                '$txt',
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ))),
    );
  }

  Future getStoredPoints() async {
    SharedPreferences mySP = await SharedPreferences.getInstance();
    int? usersPoints = mySP.getInt('POINTS');
    if (usersPoints != null) {
      setState(() {
        this.usersPoints = usersPoints;
      });
    } else {
      setState(() {
        this.usersPoints = 20;
      });
    }
  }

  Future getStoredLevel() async {
    SharedPreferences myLevelSP = await SharedPreferences.getInstance();
    int? level = myLevelSP.getInt('LEVEL');
    if (level != null) {
      setState(() {
        this.level = level;
      });
    } else {
      setState(() {
        this.level = 0;
      });
    }
  }
}
