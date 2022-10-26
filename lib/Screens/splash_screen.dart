import 'package:codeprisma/Controllers/SplashScreenController.dart';
import 'package:codeprisma/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final splashScreenController = Get.put(SplashScreenController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Obx(()=>Text('Splash Screen ${splashScreenController.count}'),),
            // TextButton(onPressed: (){
            //   // Get.snackbar("fghj","fghjk",snackPosition: SnackPosition.BOTTOM);
            //   splashScreenController.countData();
            // }, child: Text("Count")),
            TextButton(onPressed: (){
              Get.off(HomeScreen());
            }, child: Text("Next", style: TextStyle(fontSize: 50),)),
          ],

        ),
    ),
      );
  }
}
