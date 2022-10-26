import 'package:codeprisma/Screens/quiz_1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var level;
  var usersPoints;

  @override
  void initState() {
    getStoredLevel();
    getStoredPoints();

    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // appBar: AppBar(
      //   //backgroundColor: Colors.transparent,
      //   //backgroundColor: Color(0x44000000),
      //   title: Text("HomeScreen"),
      // ),
      drawer: Drawer(
        backgroundColor: Colors.transparent,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black54,
              ),
              child: Center(
                  child: Text(
                'Menu',
                style: TextStyle(fontSize: 44, color: Colors.white54),
              )),
            ),
            ListTile(
              title: const Text('Upload Question'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            'assets/images/fahad khan.png',
            fit: BoxFit.fill,
            // height: 100,
            // width: 100,
          ),
        ),
        Positioned(
          left: 10,
          top: 50,
          child: IconButton(
            icon: Icon(
              Icons.menu,
              size: 44,
            ),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 180,
                height: 40,
                decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(14),
              ),
                child: Center(
                  child: Text(
                    'Level: $level',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(14)
                ),
                child: Center(
                  child: Text(
                    'Points: $usersPoints',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,

                    ),

                  ),
                ),
              ),
              SizedBox(
                height: 80,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Get.to(Quiz1());
                  },
                  child: Text('    Start Quiz    ', style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,

                  ),)),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ]),
    );
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
}
