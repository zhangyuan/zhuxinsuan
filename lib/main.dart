import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '珠心算练习',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// 主页 - 模式选择
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('珠心算'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.calculate,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 30),
              const Text(
                '选择练习模式',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 60),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('加法练习'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 设置页 - 参数配置
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _digitsController = TextEditingController(text: '2');
  final _countController = TextEditingController(text: '5');
  final _intervalController = TextEditingController(text: '2');

  @override
  void dispose() {
    _digitsController.dispose();
    _countController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('加法练习设置'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _digitsController,
                decoration: const InputDecoration(
                  labelText: '位数',
                  hintText: '请输入数字的位数',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.looks_one),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入位数';
                  }
                  final num = int.tryParse(value);
                  if (num == null || num < 1 || num > 10) {
                    return '请输入1-10之间的数字';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _countController,
                decoration: const InputDecoration(
                  labelText: '笔数',
                  hintText: '请输入数字的笔数',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.format_list_numbered),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入笔数';
                  }
                  final num = int.tryParse(value);
                  if (num == null || num < 2 || num > 100) {
                    return '请输入2-100之间的数字';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _intervalController,
                decoration: const InputDecoration(
                  labelText: '间隔时间 (秒)',
                  hintText: '请输入每个数字停留的秒数',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timer),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入间隔时间';
                  }
                  final num = int.tryParse(value);
                  if (num == null || num < 1 || num > 10) {
                    return '请输入1-10之间的数字';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final digits = int.parse(_digitsController.text);
                    final count = int.parse(_countController.text);
                    final interval = int.parse(_intervalController.text);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PracticePage(
                          digits: digits,
                          count: count,
                          interval: interval,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('开始练习'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 练习页 - 显示数字
class PracticePage extends StatefulWidget {
  final int digits;
  final int count;
  final int interval;

  const PracticePage({
    super.key,
    required this.digits,
    required this.count,
    required this.interval,
  });

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  final FlutterTts _flutterTts = FlutterTts();
  final List<int> _numbers = [];
  int _currentIndex = 0;
  bool _isFinished = false;
  bool _isInitialized = false;
  bool _ttsSupported = true;

  @override
  void initState() {
    super.initState();
    _initTts();
    _generateNumbers();
  }

  Future<void> _initTts() async {
    try {
      // 检查TTS是否支持
      await _flutterTts.setLanguage("zh-CN");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
    } catch (e) {
      // TTS不支持时继续运行，但不播放语音
      debugPrint('TTS不支持: $e');
      _ttsSupported = false;
    }
    
    setState(() {
      _isInitialized = true;
    });
    
    _startPractice();
  }

  void _generateNumbers() {
    final random = Random();
    final min = pow(10, widget.digits - 1).toInt();
    final max = pow(10, widget.digits).toInt() - 1;

    for (int i = 0; i < widget.count; i++) {
      _numbers.add(min + random.nextInt(max - min + 1));
    }
  }

  Future<void> _startPractice() async {
    if (!_isInitialized) return;
    
    for (int i = 0; i < _numbers.length; i++) {
      if (!mounted) return;
      
      setState(() {
        _currentIndex = i;
      });

      // 先读出数字，等待读完
      if (_ttsSupported) {
        await _speakNumber(_numbers[i]);
        // 等待TTS播报完成
        await _waitForSpeechCompletion();
      }
      
      // TTS播报完成后，再等待间隔时间
      await Future.delayed(Duration(seconds: widget.interval));
    }

    if (mounted) {
      setState(() {
        _isFinished = true;
      });
    }
  }

  Future<void> _waitForSpeechCompletion() async {
    // 等待TTS播报完成
    // 根据数字长度估算播报时间（每个字约0.5秒）
    final estimatedTime = _numbers[_currentIndex].toString().length * 0.5;
    await Future.delayed(Duration(milliseconds: (estimatedTime * 1000).toInt()));
  }

  Future<void> _speakNumber(int number) async {
    try {
      final numberStr = number.toString();
      // 方法1：逐位读出中文数字
      // final chineseNumber = _convertToChineseNumber(numberStr);
      // await _flutterTts.speak(chineseNumber);
      
      // 如果上面的方法不工作，可以尝试直接读数字让TTS引擎处理
      await _flutterTts.speak(numberStr);
    } catch (e) {
      debugPrint('语音播报失败: $e');
    }
  }

  // String _convertToChineseNumber(String number) {
  //   // 将数字逐位转换为中文并用空格分隔，帮助TTS正确发音
  //   const digits = ['零', '一', '二', '三', '四', '五', '六', '七', '八', '九'];
  //   List<String> result = [];
    
  //   for (int i = 0; i < number.length; i++) {
  //     result.add(digits[int.parse(number[i])]);
  //   }
    
  //   // 用逗号分隔每个数字，让TTS有停顿
  //   return result.join('');
  // }

  @override
  void dispose() {
    if (_ttsSupported) {
      try {
        _flutterTts.stop();
      } catch (e) {
        debugPrint('停止TTS失败: $e');
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('练习中'),
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
                  _numbers[_currentIndex].toString(),
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ] else ...[
                const Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 30),
                const Text(
                  '所有数字已显示完毕',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnswerPage(numbers: _numbers),
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
}

// 答案页 - 显示总和
class AnswerPage extends StatefulWidget {
  final List<int> numbers;

  const AnswerPage({super.key, required this.numbers});

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTtsAndSpeak();
  }

  Future<void> _initTtsAndSpeak() async {
    try {
      await _flutterTts.setLanguage("zh-CN");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      
      // 计算总和
      final sum = widget.numbers.reduce((a, b) => a + b);
      
      // 播报结果
      await Future.delayed(const Duration(milliseconds: 500));
      await _flutterTts.speak("综合为，$sum");
    } catch (e) {
      debugPrint('语音播报失败: $e');
    }
  }

  @override
  void dispose() {
    try {
      _flutterTts.stop();
    } catch (e) {
      debugPrint('停止TTS失败: $e');
    }
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
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        title: Text(
                          widget.numbers[index].toString(),
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
