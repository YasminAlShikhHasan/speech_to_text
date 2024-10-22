import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:test_speech_to_text/color.dart';

class SpeechToTextPage extends StatefulWidget {
  const SpeechToTextPage({super.key});

  @override
  State<SpeechToTextPage> createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {
  String text = '';
  bool isListening = false;
  SpeechToText speech = SpeechToText();
  bool available = false;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  Future<void> initSpeech() async {
    available = await speech.initialize();
    if (available) {
      setState(() {
        isListening = false;
      });
    }
  }

  startListening() async {
    await speech.listen(onResult: (result) {
      setState(() {
        text = result.recognizedWords;
      });
      setState(() {
        isListening = true;
      });
    });
  }

  stopListening() async {
    await speech.stop();
    setState(() {
      isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        glowColor: bgColor,
        animate: isListening,
        duration: const Duration(milliseconds: 2000),
        repeat: true,
        child: GestureDetector(
          onTap: isListening ? stopListening : startListening,
          child: CircleAvatar(
            backgroundColor: bgColor,
            radius: 35,
            child: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0.0,
        title: const Text(
          "Speech To Text",
          style: TextStyle(fontWeight: FontWeight.w500, color: textColor),
        ),
      ),
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          margin: const EdgeInsets.only(bottom: 150),
          child: Column(
            children: [
              Text(
                text,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.black87),
              ),
              Text(
                isListening ? "listening" : "Not Listining",
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.black87),
              ),
            ],
          )),
    );
  }
}
