import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsHelper {
  final FlutterTts _flutterTts = FlutterTts();
  bool _ttsSupported = true;

  bool get isSupported => _ttsSupported;

  Future<void> initialize() async {
    try {
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
    } catch (e) {
      debugPrint('TTS不支持: $e');
      _ttsSupported = false;
    }
  }

  Future<void> speakNumber(int number, {bool readOperator = false}) async {
    if (!_ttsSupported) return;

    try {
      String text;
      if (number < 0) {
        text = '减 ${number.abs()}';
      } else {
        text = readOperator ? '加 $number' : '$number';
      }
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('语音播报失败: $e');
    }
  }

  Future<void> speakSum(int sum) async {
    if (!_ttsSupported) return;

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await _flutterTts.speak('最终结果为 $sum');
    } catch (e) {
      debugPrint('语音播报失败: $e');
    }
  }

  void dispose() {
    if (_ttsSupported) {
      try {
        _flutterTts.stop();
      } catch (e) {
        debugPrint('停止TTS失败: $e');
      }
    }
  }
}

