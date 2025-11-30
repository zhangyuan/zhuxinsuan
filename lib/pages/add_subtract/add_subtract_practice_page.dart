import 'package:flutter/material.dart';
import '../../utils/tts_helper.dart';
import '../../utils/number_generator.dart';
import 'add_subtract_answer_page.dart';

class AddSubtractPracticePage extends StatefulWidget {
  final int digits;
  final int count;
  final int interval;

  const AddSubtractPracticePage({
    super.key,
    required this.digits,
    required this.count,
    required this.interval,
  });

  @override
  State<AddSubtractPracticePage> createState() => _AddSubtractPracticePageState();
}

class _AddSubtractPracticePageState extends State<AddSubtractPracticePage> {
  final TtsHelper _ttsHelper = TtsHelper();
  late List<int> _numbers;
  int _currentIndex = 0;
  bool _isFinished = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _numbers = NumberGenerator.generateAddSubtractNumbers(widget.digits, widget.count);
    _initTts();
  }

  Future<void> _initTts() async {
    await _ttsHelper.initialize();
    setState(() => _isInitialized = true);
    _startPractice();
  }

  Future<void> _startPractice() async {
    if (!_isInitialized) return;

    for (int i = 0; i < _numbers.length; i++) {
      if (!mounted) return;

      setState(() => _currentIndex = i);

      if (_ttsHelper.isSupported) {
        await _ttsHelper.speakNumber(_numbers[i], readOperator: i > 0);
        await _waitForSpeechCompletion();
      }

      await Future.delayed(Duration(seconds: widget.interval));
    }

    if (mounted) {
      setState(() => _isFinished = true);
    }
  }

  Future<void> _waitForSpeechCompletion() async {
    final number = _numbers[_currentIndex].abs();
    final estimatedTime = number.toString().length * 0.5;
    await Future.delayed(Duration(milliseconds: (estimatedTime * 1000).toInt()));
  }

  @override
  void dispose() {
    _ttsHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('加减法练习中'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isFinished) ...[
                Text(
                  '第 ${_currentIndex + 1} / ${widget.count} 个数字',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                Text(
                  _formatNumber(_numbers[_currentIndex]),
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: _numbers[_currentIndex] < 0 ? Colors.red : Colors.blue,
                  ),
                ),
              ] else ...[
                const Icon(Icons.check_circle, size: 80, color: Colors.green),
                const SizedBox(height: 30),
                const Text('所有数字已显示完毕', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddSubtractAnswerPage(numbers: _numbers),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 60),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text('查看答案'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (_currentIndex == 0) {
      return number.toString();
    }
    return number < 0 ? '− ${number.abs()}' : '+ $number';
  }
}
