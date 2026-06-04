import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class TextToSpecch extends StatefulWidget {
  const TextToSpecch({super.key});

  @override
  State<TextToSpecch> createState() => _TextToSpecchState();
}

class _TextToSpecchState extends State<TextToSpecch> {
  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

Future<void> initSpeech() async {
  _speechEnabled = await _speechToText.initialize(
    onStatus: (status) => print('🎙 Status: $status'),
    onError: (error) => print('❌ Error: $error'),
  );

  if (!_speechEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Speech recognition not available."),
        backgroundColor: Colors.orange,
      ),
    );
  }

  setState(() {});
}



void _startListening() async {
  var status = await Permission.microphone.request();

  if (status != PermissionStatus.granted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('❌ Microphone permission denied'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  await _speechToText.listen(
    onResult: _onSpeechResult,
    listenFor: const Duration(seconds: 10),
    pauseFor: const Duration(seconds: 3),
    cancelOnError: true,
  );

  setState(() {
    _confidenceLevel = 0;
  });
}


  void _stopListening() async {
    await _speechToText.stop();
    if (mounted) {
      Navigator.pop(context, _wordsSpoken); // Return result
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (!mounted) return;
    setState(() {
      _wordsSpoken = result.recognizedWords;
      _confidenceLevel = result.confidence;
    });
  }

  @override
  void dispose() {
    _speechToText.stop(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              _speechToText.isListening
                  ? "Listening..."
                  : _speechEnabled
                      ? "Tap mic to speak"
                      : "Speech not available",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(17),
                child: Text(
                  _wordsSpoken,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            if (!_speechToText.isListening && _confidenceLevel > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Text(
                  "Confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}%",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        backgroundColor: Colors.red,
        child: Icon(
          _speechToText.isListening ? Icons.mic_off : Icons.mic,
          color: Colors.white,
        ),
      ),
    );
  }
}
