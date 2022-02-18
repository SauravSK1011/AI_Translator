import 'dart:io';
import 'package:texttospeachapp/utils/languages.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:translator/translator.dart';

class Imagetotext extends StatefulWidget {
  const Imagetotext({Key? key}) : super(key: key);

  @override
  _ImagetotextState createState() => _ImagetotextState();
}

class _ImagetotextState extends State<Imagetotext> {
  Color color = Colors.grey.shade200;
  Color buttoncolor = Colors.grey.shade200;
  Color cardcolor = Colors.grey.shade200;
  Color appbarbackgroundColor = Colors.grey.shade200;
  Color bottomcolor = Colors.grey.shade400;
  Color dropdowncolor = Colors.grey.shade200;
  Color textcolor = Colors.deepPurpleAccent.shade700;
  Color iconcolor = Colors.deepPurpleAccent.shade700;

  // List<String> languagesfrom = ["English"];
  // String? selectedfrom = "English";

  // List<String> languagesto = ["Hindi", "Marathi"];
  String? selectedto = "Hindi";
  int initialindex = 1;
  late File _imagefile;
  final imagepicker = ImagePicker();
  bool isImageLoded = false;
  bool isrecognize = true;
  bool isTranslate = true;
  var finaltext = "";
  final TextEditingController textEditingController = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();
  final translator = GoogleTranslator();
  var output;
  final items = <Widget>[
    const Icon(
      Icons.add_a_photo,
      color: Colors.deepPurpleAccent,
    ),
    const Icon(Icons.menu, color: Colors.deepPurple),
    const Icon(Icons.add_photo_alternate_rounded,
        color: Colors.deepPurpleAccent),
  ];

  translate(String text, String lang) async {
    await translator.translate(text, to: lang).then((value) {
      setState(() {
        output = value;

        isTranslate = true;
      });
    });
    await flutterTts.setLanguage(lang);
    await flutterTts.setPitch(0.7);
    await flutterTts.speak(output.toString());
  }

  _imageformgallery() async {
    await Future.delayed(const Duration(seconds: 1), () {});
    var image = await imagepicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      setState(() {
        _imagefile = File(image.path);
        isImageLoded = true;
        initialindex = 1;
      });
    }
  }

  _imageformcamara() async {
    await Future.delayed(const Duration(seconds: 1), () {});
    var image = await imagepicker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    } else {
      setState(() {
        _imagefile = File(image.path);
        isImageLoded = true;
        initialindex = 1;
      });
    }
  }

  textfromImage() async {
    FirebaseVisionImage selectedimage =
        FirebaseVisionImage.fromFile(_imagefile);
    TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    VisionText outputtext = await textRecognizer.processImage(selectedimage);
    for (TextBlock blocks in outputtext.blocks) {
      for (TextLine line in blocks.lines) {
        for (TextElement word in line.elements) {
          setState(() {
            finaltext = finaltext + " " + word.text;
          });
        }
      }
    }
    setState(() {
      isrecognize = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: appbarbackgroundColor,
        title: Center(
            child: Text(
          "Translator Using ML",
          style: TextStyle(color: textcolor),
        )),
      ),
      body: Container(
        // height: MediaQuery.of(context).size.height + 600,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height + 100,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  isImageLoded
                      ? Center(
                          child: Container(
                            height: 250,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: FileImage(_imagefile),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Card(
                      color: dropdowncolor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      elevation: 25,
                      child: Container(
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Convert to",
                              style: TextStyle(
                                  color: textcolor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              decoration: BoxDecoration(color: color),
                              // color: Colors.white,
                              width: 150,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  hoverColor: color,
                                  fillColor: color,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide:
                                        BorderSide(width: 5, color: color),
                                  ),
                                ),
                                value: selectedto,
                                items: Translation_languages.select_languages
                                    .map((language) =>
                                        DropdownMenuItem<String>(
                                          value: language,
                                          child: Text(
                                            language,
                                            style:
                                                TextStyle(color: textcolor),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (language) =>
                                    setState(() => selectedto = language),
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.deepPurpleAccent,
                                ),
                                iconSize: 42,
                                // // underline: SizedBox(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: buttoncolor,
                    ),
                    onPressed: () {
                      setState(() {
                        isrecognize = false;
                      });
                      output = "";
                      finaltext = "";
                      textfromImage();
                    },
                    child: isrecognize
                        ? Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "recognize",
                              style: TextStyle(
                                  color: textcolor,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: textcolor,
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        color: cardcolor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 25,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            finaltext,
                            style: TextStyle(color: textcolor, fontSize: 17),
                          ),
                        )),
                  ),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: buttoncolor,
                            ),
                            onPressed: () {
                              setState(() {
                                isTranslate = false;
                              });
                              output = "";
                              // finaltext = "";
                              translate(
                                  finaltext,
                                  Translation_languages.getLanguageCode(
                                      selectedto!));
                            },
                            child: isTranslate
                                ? Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Translate",
                                      style: TextStyle(
                                          color: textcolor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      color: textcolor,
                                    ),
                                  )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              color: cardcolor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              elevation: 25,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  output == null ? "" : output.toString(),
                                  style: TextStyle(
                                      color: textcolor, fontSize: 17),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  // Home(finaltext: finaltext)
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: bottomcolor,
        index: initialindex,
        height: 50,
        backgroundColor: Colors.transparent,
        items: items,
        onTap: (index) {
          if (index == 0) {
            output = "";

            finaltext = "";
            _imageformcamara();
          } else if (index == 2) {
            output = "";

            finaltext = "";
            _imageformgallery();
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: textfromImage,
      //   child: Icon(Icons.check_sharp),
      // ),
    );
  }
}
