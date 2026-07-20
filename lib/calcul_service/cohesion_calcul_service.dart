import 'dart:math';

class CohesionCalculService {
  static double getAverageFromInt(List<int> values) {
    int sum = 0;
    for (int value in values) {
      sum += value;
    }
    return sum / values.length;
  }

  static double getAverageFromDouble(List<double> values) {
    double sum = 0;
    for (double value in values) {
      sum += value;
    }
    return sum / values.length;
  }

  static double getEcartType(List<int> values) {
    int sum = 0;
    for (int value in values) {
      sum += value;
    }
    double average = sum / values.length;
    double valueToDivide = 0;
    for (int value in values) {
      valueToDivide += pow((value - average), 2).toDouble();
    }
    return sqrt(valueToDivide / values.length);
  }
}
