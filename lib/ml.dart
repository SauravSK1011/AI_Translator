import 'dart:io';

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
      color: Colors.white,
    ),
    const Icon(Icons.menu, color: Colors.white),
    const Icon(Icons.add_photo_alternate_rounded, color: Colors.white),
  ];

  translate(String text) async {
    await translator.translate(text, to: "mr").then((value) {
      setState(() {
        output = value;

        isTranslate = true;
      });
    });
    await flutterTts.setLanguage("mr-IN");
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
        title: const Center(child: Text("Translator Using ML")),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height+600,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/peakpx5.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(height: MediaQuery.of(context).size.height+100,
            child: Column(
              children: [
                // const SizedBox(
                //   height: 50,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     ElevatedButton(
                //         onPressed: () {
                //           output = "";

                //           finaltext = "";
                //           _imageformcamara();
                //         },
                //         child: const Icon(Icons.add_a_photo)),
                //     ElevatedButton(
                //         onPressed: () {
                //           output = "";
                //           finaltext = "";
                //           _imageformgallery();
                //         },
                //         child: const Icon(Icons.add_photo_alternate_rounded)),
                //   ],
                // ),
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
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isrecognize = false;
                      });
                      output = "";
                      finaltext = "";
                      textfromImage();
                    },
                    child: isrecognize
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("recognize"),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      color: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 25,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          finaltext,
                          style:
                              const TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      )),
                ),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isTranslate = false;
                            });
                            output = "";
                            // finaltext = "";
                            translate(finaltext);
                          },
                          child: isTranslate
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Translate"),
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            color: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 25,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                output == null ? "" : output.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 17),
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
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.blue,
        index: 1,
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
