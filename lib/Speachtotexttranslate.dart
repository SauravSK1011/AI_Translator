import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:texttospeachapp/ml.dart';
import 'package:texttospeachapp/texttranslate.dart';
import 'package:texttospeachapp/utils/Colors.dart';
import 'package:texttospeachapp/utils/languages.dart';
import 'package:translator/translator.dart';
import 'package:avatar_glow/avatar_glow.dart';

class SpeachToTextTranslate extends StatefulWidget {
  const SpeachToTextTranslate({Key? key}) : super(key: key);

  @override
  _SpeachToTextTranslateState createState() => _SpeachToTextTranslateState();
}

class _SpeachToTextTranslateState extends State<SpeachToTextTranslate> {
  String? selectedto = "Hindi";
  bool isTranslate = true;
  var finaltext = "";
  final stt.SpeechToText _speachtotext = stt.SpeechToText();

  bool isListening = false;
  String speechToText = "Press the button and start speaking";
  // TextEditingController textController = TextEditingController();
  int initialindex = 2;
  final translator = GoogleTranslator();
  final FlutterTts flutterTts = FlutterTts();
  var output;
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

  listen() async {
    if (isListening == false) {
      bool available = await _speachtotext.initialize(
          onStatus: (value) => print("onStatus: $value"),
          onError: (value) => print("onError: $value"));
      if (available) {
        setState(() {
          isListening = true;
        });
        _speachtotext.listen(onResult: (value) {
          speechToText = value.recognizedWords;
        });
      }
    } else {
      setState(() {
        isListening = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: colorsUsed.appbarbackgroundColor,
        title: Center(
            child: Text(
          "Translator Using ML",
          style: TextStyle(color: colorsUsed.textcolor),
        )),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple,width: 3),borderRadius: BorderRadius.circular(16)),
                  child: Text(
                  speechToText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Card(
                    color: colorsUsed.dropdowncolor,
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
                                color: colorsUsed.textcolor,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            decoration: BoxDecoration(color: colorsUsed.color),
                            // color: Colors.white,
                            width: 150,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hoverColor: colorsUsed.color,
                                fillColor: colorsUsed.color,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      width: 5, color: colorsUsed.color),
                                ),
                              ),
                              value: selectedto,
                              items: Translation_languages.select_languages
                                  .map((language) => DropdownMenuItem<String>(
                                        value: language,
                                        child: Text(
                                          language,
                                          style: TextStyle(
                                              color: colorsUsed.textcolor),
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
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: colorsUsed.buttoncolor,
                          ),
                          onPressed: () {
                            setState(() {
                              isTranslate = false;
                            });
                            output = "";
                            setState(() {
                              finaltext = speechToText;
                            });
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
                                        color: colorsUsed.textcolor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    color: colorsUsed.textcolor,
                                  ),
                                )),
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            color: colorsUsed.cardcolor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 25,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                output == null ? "" : output.toString(),
                                style: TextStyle(
                                    color: colorsUsed.textcolor, fontSize: 17),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        glowColor: colorsUsed.iconcolor,
        endRadius: 75,
        duration: Duration(milliseconds: 2000),
        repeatPauseDuration: Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(backgroundColor: colorsUsed.buttoncolor,
            onPressed: () {
              listen();
            },
            child: isListening
                ? Icon(
                    Icons.mic,
                    color: colorsUsed.iconcolor,
                  )
                : Icon(Icons.mic_none, color: colorsUsed.iconcolor)),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: colorsUsed.bottomcolor,
        index: initialindex,
        height: 50,
        backgroundColor: Colors.transparent,
        items: iconUsed.items,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Imagetotext()));
          } else if (index == 1) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const TextTranslate()));
          } else if (index == 2) {}
        },
      ),
    );
  }
}