import 'package:flutter/material.dart';
import '../../utils/tts_helper.dart';

class AdditionAnswerPage extends StatefulWidget {
  final List<int> numbers;

  const AdditionAnswerPage({
    super.key,
    required this.numbers,
  });

  @override
  State<AdditionAnswerPage> createState() => _AdditionAnswerPageState();
}

class _AdditionAnswerPageState extends State<AdditionAnswerPage> {
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
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text('${index + 1}'),
                        ),
                        title: Text(
                          number.toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(thickness: 2),
              const SizedBox(height: 10),
              const Text(
                '总和',
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
}
