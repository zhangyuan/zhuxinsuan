import 'dart:math';

class NumberGenerator {
  static List<int> generateAdditionNumbers(int digits, int count) {
    final random = Random();
    final min = pow(10, digits - 1).toInt();
    final max = pow(10, digits).toInt() - 1;
    final numbers = <int>[];

    for (int i = 0; i < count; i++) {
      numbers.add(min + random.nextInt(max - min + 1));
    }

    return numbers;
  }

  static List<int> generateAddSubtractNumbers(int digits, int count) {
    final random = Random();
    final min = pow(10, digits - 1).toInt();
    final max = pow(10, digits).toInt() - 1;
    final numbers = <int>[];

    int runningSum = 0;
    bool hasNegative = false;

    for (int i = 0; i < count; i++) {
      int number;

      if (i == 0) {
        number = min + random.nextInt(max - min + 1);
        runningSum = number;
      } else {
        bool shouldBeNegative = false;

        if (!hasNegative && i < count - 1) {
          shouldBeNegative = random.nextBool();
        } else if (!hasNegative && i == count - 1) {
          shouldBeNegative = true;
        } else {
          shouldBeNegative = random.nextBool();
        }

        if (shouldBeNegative) {
          int maxNegative = runningSum;
          if (maxNegative > max) {
            maxNegative = max;
          }
          if (maxNegative < min) {
            number = min + random.nextInt(max - min + 1);
          } else {
            number = -(min + random.nextInt(maxNegative - min + 1));
            hasNegative = true;
          }
        } else {
          number = min + random.nextInt(max - min + 1);
        }

        if (runningSum + number < 0) {
          number = min + random.nextInt(max - min + 1);
        }

        runningSum += number;
      }

      numbers.add(number);
    }

    return numbers;
  }
}
