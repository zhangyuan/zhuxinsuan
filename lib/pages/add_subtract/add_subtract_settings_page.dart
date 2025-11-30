import 'package:flutter/material.dart';
import '../../widgets/practice_settings_form.dart';
import 'add_subtract_practice_page.dart';

class AddSubtractSettingsPage extends StatelessWidget {
  const AddSubtractSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PracticeSettingsForm(
      title: '加减法练习设置',
      onStart: (digits, count, interval) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddSubtractPracticePage(
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
