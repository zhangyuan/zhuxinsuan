import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PracticeSettingsForm extends StatefulWidget {
  final String title;
  final void Function(int digits, int count, int interval) onStart;

  const PracticeSettingsForm({
    super.key,
    required this.title,
    required this.onStart,
  });

  @override
  State<PracticeSettingsForm> createState() => _PracticeSettingsFormState();
}

class _PracticeSettingsFormState extends State<PracticeSettingsForm> {
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

  void _selectAllText(TextEditingController controller) {
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                onTap: () => _selectAllText(_digitsController),
                validator: (value) {
                  if (value == null || value.isEmpty) return '请输入位数';
                  final num = int.tryParse(value);
                  if (num == null || num < 1 || num > 8) {
                    return '请输入1-8之间的数字';
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
                onTap: () => _selectAllText(_countController),
                validator: (value) {
                  if (value == null || value.isEmpty) return '请输入笔数';
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
                onTap: () => _selectAllText(_intervalController),
                validator: (value) {
                  if (value == null || value.isEmpty) return '请输入间隔时间';
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
                    widget.onStart(digits, count, interval);
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
