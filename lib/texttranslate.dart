import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:texttospeachapp/ml.dart';
import 'package:texttospeachapp/utils/languages.dart';
import 'package:translator/translator.dart';

class TextTranslate extends StatefulWidget {
  const TextTranslate({Key? key}) : super(key: key);

  @override
  _TextTranslateState createState() => _TextTranslateState();
}

class _TextTranslateState extends State<TextTranslate> {
  Color color = Colors.grey.shade200;
  Color buttoncolor = Colors.grey.shade200;
  Color cardcolor = Colors.grey.shade200;
  Color appbarbackgroundColor = Colors.grey.shade200;
  Color bottomcolor = Colors.grey.shade400;
  Color dropdowncolor = Colors.grey.shade200;
  Color textcolor = Colors.deepPurpleAccent.shade700;
  Color iconcolor = Colors.deepPurpleAccent.shade700;
  String? selectedto = "Hindi";
  bool isTranslate = true;
  var finaltext = "";

  TextEditingController textController = TextEditingController();
  int initialindex = 1;
  final items = <Widget>[
    const Icon(
      Icons.camera,
      color: Colors.deepPurpleAccent,
    ),
    const Icon(Icons.text_fields_rounded, color: Colors.deepPurpleAccent),
  ];
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
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: textController,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                  decoration: const InputDecoration(
                    labelText: 'Enter Text to Translate',
                    labelStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                    // hintText: "Enter Text",
                    // hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
                SizedBox(
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
                                color: textcolor, fontWeight: FontWeight.bold),
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
                                  .map((language) => DropdownMenuItem<String>(
                                        value: language,
                                        child: Text(
                                          language,
                                          style: TextStyle(color: textcolor),
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
                            primary: buttoncolor,
                          ),
                          onPressed: () {
                            setState(() {
                              isTranslate = false;
                            });
                            output = "";
                            setState(() {
                              finaltext = textController.text;
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
                      SizedBox(
                        height: 50,
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
                                output == null ? "" : output.toString(),
                                style:
                                    TextStyle(color: textcolor, fontSize: 17),
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
      bottomNavigationBar: CurvedNavigationBar(
        color: bottomcolor,
        index: initialindex,
        height: 50,
        backgroundColor: Colors.transparent,
        items: items,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Imagetotext()));
          } else if (index == 1) {}
        },
      ),
    );
  }
}
