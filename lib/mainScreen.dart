import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'const.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final translator = GoogleTranslator();
  TextEditingController _controller = TextEditingController();

  final FlutterTts flutterTts = FlutterTts();

  String to = "en";
  String from = "ar";
  String word;
  List<String> wordAdded = [];
  List<String> wordTranslated = [];

  void _submitForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    wordAdded.add(word);
    translateFun();
    _controller.text = '';
  }
  translateFun() async {
    var wordTran = await translator.translate(word, from: from, to: to);
    wordTranslated.add(wordTran.toString());
  }

  speak(word)async{
    await flutterTts.setLanguage(to);
    await flutterTts.setPitch(1);
    await flutterTts.speak(word);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Translator"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Translate From: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton(
                  value: from,
                  onChanged: (val) {
                    setState(() {
                      from = val;
                      wordAdded = [];
                      wordTranslated = [];
                      print(from);
                    });
                  },
                  items: langs
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Translate to: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton(
                  value: to,
                  onChanged: (val) {
                    setState(() {
                      to = val;
                      wordAdded = [];
                      wordTranslated = [];
                      print(to);
                    });
                  },
                  items: langs
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.only(right: 15, left: 15,),
              padding: EdgeInsets.only(right: 15, left: 15, bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black12),
              child: TextFormField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(40),
                ],
                controller: _controller,
                textAlign: TextAlign.left,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  hintText: 'Enter Word You Want Translate',
                  hintStyle: TextStyle(color: Colors.black12),
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter any word';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    word = value;
                  });
                },
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                ),
                onPressed: () {
                  _submitForm();
                },
                child: Text(
                  'Add Word',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .6,
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(10.0),
                itemCount: wordAdded.length,
                itemBuilder: (ctx, index) {
                  return Container(
                    // padding: EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        speak(wordTranslated[index]);
                      },
                      onLongPress: (){
                        setState(() {
                          wordAdded.removeAt(index);
                          wordTranslated.removeAt(index);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.lightBlueAccent),
                        child: Center(
                            child: Text(
                          wordAdded[index],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
