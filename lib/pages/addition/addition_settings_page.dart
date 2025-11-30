import 'package:flutter/material.dart';
import '../../widgets/practice_settings_form.dart';
import 'addition_practice_page.dart';

class AdditionSettingsPage extends StatelessWidget {
  const AdditionSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PracticeSettingsForm(
      title: '加法练习设置',
      onStart: (digits, count, interval) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdditionPracticePage(
              digits: digits,
              count: count,
              interval: interval,
            ),
          ),
        );
      },
    );
  }
}
