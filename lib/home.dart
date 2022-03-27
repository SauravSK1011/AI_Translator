import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:texttospeachapp/Speachtotexttranslate.dart';
import 'package:texttospeachapp/ml.dart';
import 'package:texttospeachapp/texttranslate.dart';
import 'package:texttospeachapp/utils/Colors.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  
  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  var initialindex = 1;
  var currentindex = 1;
  var screens = [
    const Imagetotext(),
    const TextTranslate(),
    const SpeachToTextTranslate()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: colorsUsed.bottomcolor,
        title: Center(
            child: Text(
          "AI Translator",
          style: TextStyle(color: colorsUsed.textcolor),
        )),
      ),
      body: screens[currentindex],
      bottomNavigationBar: CurvedNavigationBar(
        
        color: colorsUsed.bottomcolor,
        index: initialindex,
        height: 50,
        backgroundColor: Colors.transparent,
        items: iconUsed.items,
        onTap: (index) {
          setState(() {
                      currentindex = index;

          });

          // if (index == 0) {
          // } else if (index == 1) {
          //   Navigator.pushReplacement(
          //     context,
          //     PageRouteBuilder(
          //       pageBuilder: (context, animation1, animation2) =>
          //           TextTranslate(),
          //       transitionDuration: Duration(seconds: 0),
          //     ),
          //   );
          //   // Navigator.pushReplacement(context,
          //   //     MaterialPageRoute(builder: (context) => const TextTranslate()));
          // } else if (index == 2) {
          //   Navigator.pushReplacement(
          //     context,
          //     PageRouteBuilder(
          //       pageBuilder: (context, animation1, animation2) =>
          //           SpeachToTextTranslate(),
          //       transitionDuration: Duration(seconds: 0),
          //     ),
          //   );
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const SpeachToTextTranslate()));
          // }
        },
      ),
    );
  }
}
