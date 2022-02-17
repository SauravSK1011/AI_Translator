import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class Home extends StatefulWidget {
  Home({Key? key, required this.finaltext}) : super(key: key);
  String finaltext;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController textEditingController = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();
  final translator = GoogleTranslator();
  var output;
  translate(String text) async {
    await translator.translate(text, to: "hi").then((value) {
      setState(() {
        output = value;
      });
    });
    await flutterTts.setLanguage("hi-IN");
    await flutterTts.setPitch(1.4);
    await flutterTts.speak(output.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    translate(widget.finaltext);
                  },
                  child: Text("Translate")),
              Text(
                output == null ? "" : output.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
