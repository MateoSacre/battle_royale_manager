import 'dart:math';

import 'package:battle_royale_manager/calcul_service/cohesion_calcul_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getAverageFromInt', () {
    test('computes the average of several values', () {
      expect(CohesionCalculService.getAverageFromInt([1, 2, 3, 4]), 2.5);
    });

    test('returns the value itself for a single-element list', () {
      expect(CohesionCalculService.getAverageFromInt([7]), 7);
    });

    test('handles a list of identical values', () {
      expect(CohesionCalculService.getAverageFromInt([5, 5, 5]), 5);
    });
  });

  group('getAverageFromDouble', () {
    test('computes the average of several values', () {
      expect(
        CohesionCalculService.getAverageFromDouble([1.0, 2.0, 3.0]),
        2.0,
      );
    });

    test('returns the value itself for a single-element list', () {
      expect(CohesionCalculService.getAverageFromDouble([4.2]), 4.2);
    });
  });

  group('getEcartType', () {
    test('returns 0 when every value is identical', () {
      expect(CohesionCalculService.getEcartType([50, 50, 50]), 0);
    });

    test('matches the textbook population standard deviation example', () {
      // mean = 5, population variance = 4, ecart type = 2
      expect(
        CohesionCalculService.getEcartType([2, 4, 4, 4, 5, 5, 7, 9]),
        closeTo(2, 1e-9),
      );
    });

    test('reaches its max spread for extreme opposite values', () {
      expect(CohesionCalculService.getEcartType([0, 100]), 50);
    });

    test('matches an independently computed sqrt(variance)', () {
      final values = [30, 70, 50, 10];
      final mean = values.reduce((a, b) => a + b) / values.length;
      final expected = sqrt(
        values.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b) /
            values.length,
      );
      expect(
        CohesionCalculService.getEcartType(values),
        closeTo(expected, 1e-9),
      );
    });
  });
}
