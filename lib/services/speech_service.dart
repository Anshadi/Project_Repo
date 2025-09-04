import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class SpeechService {
  static final stt.SpeechToText _speechToText = stt.SpeechToText();
  static bool _speechEnabled = false;

  // Initialize speech recognition
  static Future<bool> initialize() async {
    // Request microphone permission
    final status = await Permission.microphone.request();            //   Used Inbuilt Method - request() and granted .
    if (status != PermissionStatus.granted) {
      return false;
    }

    // Method to Initialize speech to text
    _speechEnabled = await _speechToText.initialize(
      onError: (error) => debugPrint('Speech recognition error: $error'),
      onStatus: (status) => debugPrint('Speech recognition status: $status'),
    );

    return _speechEnabled;
  }

  // Check if speech recognition is available
  static bool get isAvailable => _speechEnabled;

  // Check if currently listening
  static bool get isListening => _speechToText.isListening;          // isListening is a built-in property of the SpeechToText class.

  // Start listening
  static Future<void> startListening({
    required Function(String) onResult,                        // It is the shorthand of void Function(String) which is onResult 
    required Function(String) onError,                    // Have defined Custom Callbacks - OnResult and OnError 
  }) async {
    if (!_speechEnabled) {
      onError('Speech recognition not available');
      return;
    }

    await _speechToText.listen(
      onResult: (result) {                // onResult and onError in speech_to_text (Built-in Callbacks) But here we have above also defined the custom callbacks 
        onResult(result.recognizedWords);            // so when builtin callback is called , inside it , we call our custom ones like here - OnResult 
      },                                          // here built-in callbacks handle the interaction with the speech engine. The custom ones allow our app to react to events 
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),          
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
      ),
      localeId: 'en_US', // Can be changed for multilingual support
    );
  }

  // Here there is no problem in the name conflict of both built-in and the custom ones because - the built in is only available in listen so we use it like method_name :  , 
  // but in the custom one , we pass the value to the method_name( values )

  // Stop listening
  static Future<void> stopListening() async {
    await _speechToText.stop();
  }

  // Cancel listening
  static Future<void> cancelListening() async {
    await _speechToText.cancel();
  }

  // Get available locales for multilingual support
  static Future<List<stt.LocaleName>> getAvailableLocales() async {     // It returns a list of locales that is available languages that it supports 
    if (!_speechEnabled) return [];                  // If speech Engine is not ready , then save the unnescessary processing and return empty list 
    return await _speechToText.locales();          // locales() is a inbuilt function of this package 
  }

  // Check microphone permission
  static Future<bool> checkMicrophonePermission() async {
    final status = await Permission.microphone.status;
    return status == PermissionStatus.granted;
  }

  // Request microphone permission
  static Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }
}
