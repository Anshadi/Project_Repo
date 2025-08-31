import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class SpeechService {
  static final stt.SpeechToText _speechToText = stt.SpeechToText();
  static bool _speechEnabled = false;

  // Initialize speech recognition
  static Future<bool> initialize() async {
    // Request microphone permission
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      return false;
    }

    // Initialize speech to text
    _speechEnabled = await _speechToText.initialize(
      onError: (error) => debugPrint('Speech recognition error: $error'),
      onStatus: (status) => debugPrint('Speech recognition status: $status'),
    );

    return _speechEnabled;
  }

  // Check if speech recognition is available
  static bool get isAvailable => _speechEnabled;

  // Check if currently listening
  static bool get isListening => _speechToText.isListening;

  // Start listening
  static Future<void> startListening({
    required Function(String) onResult,
    required Function(String) onError,
  }) async {
    if (!_speechEnabled) {
      onError('Speech recognition not available');
      return;
    }

    await _speechToText.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
      ),
      localeId: 'en_US', // Can be changed for multilingual support
    );
  }

  // Stop listening
  static Future<void> stopListening() async {
    await _speechToText.stop();
  }

  // Cancel listening
  static Future<void> cancelListening() async {
    await _speechToText.cancel();
  }

  // Get available locales for multilingual support
  static Future<List<stt.LocaleName>> getAvailableLocales() async {
    if (!_speechEnabled) return [];
    return await _speechToText.locales();
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
