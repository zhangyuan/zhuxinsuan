import 'package:flutter/material.dart';
import '../../utils/tts_helper.dart';

class AddSubtractAnswerPage extends StatefulWidget {
  final List<int> numbers;

  const AddSubtractAnswerPage({
    super.key,
    required this.numbers,
  });

  @override
  State<AddSubtractAnswerPage> createState() => _AddSubtractAnswerPageState();
}

class _AddSubtractAnswerPageState extends State<AddSubtractAnswerPage> {
  final TtsHelper _ttsHelper = TtsHelper();

  @override
  void initState() {
    super.initState();
    _initTtsAndSpeak();
  }

  Future<void> _initTtsAndSpeak() async {
    await _ttsHelper.initialize();
    final sum = widget.numbers.reduce((a, b) => a + b);
    await _ttsHelper.speakSum(sum);
  }

  @override
  void dispose() {
    _ttsHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sum = widget.numbers.reduce((a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('答案'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '所有数字',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.numbers.length,
                  itemBuilder: (context, index) {
                    final number = widget.numbers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      color: number < 0 ? Colors.red.shade50 : null,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: number < 0 ? Colors.red : Colors.blue,
                          child: Text('${index + 1}'),
                        ),
                        title: Text(
                          _formatNumber(number, index),
                          style: TextStyle(
                            fontSize: 24,
                            color: number < 0 ? Colors.red : Colors.black,
                            fontWeight: number < 0 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(thickness: 2),
              const SizedBox(height: 10),
              const Text(
                '最终结果',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                sum.toString(),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('返回主页'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text('再练一次'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNumber(int number, int index) {
    if (index == 0) {
      return number.toString();
    }
    return number < 0 ? '− ${number.abs()}' : '+ $number';
  }
}
