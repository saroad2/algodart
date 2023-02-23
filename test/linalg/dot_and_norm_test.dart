import 'package:algodart/vector.dart';
import 'package:test/test.dart';

import '../random_methods.dart';
import '../test_utils.dart';

void main() {
  group('Vector dot and norm', () {
    test("Test int vector dot", () {
      final v1 = Vector([1, -3, 7]);
      final v2 = Vector([15, 4, 1]);

      expect(v1.dot(v2), 10);
    });
    test("Test double vector dot", () {
      final v1 = Vector([1.34, -3.2, 9]);
      final v2 = Vector([15.2, 4.4, 0.1]);

      expect(v1.dot(v2), closeTo(7.1879, 1e-4));
    });
    test("Test int vector fails on different length", () {
      final n1 = 4, n2 = 7;
      final v1 = Vector(randomIntList(n1)), v2 = Vector(randomIntList(n2));

      expect(
          () => v1.dot(v2),
          throwsWithMessage<VectorError>(
            "Cannot calculate do product of vectors with different lengths",
          ));
    });
    test("Test double vector fails on different length", () {
      final n1 = 4, n2 = 7;
      final v1 = Vector(randomDoubleList(n1)),
          v2 = Vector(randomDoubleList(n2));

      expect(
          () => v1.dot(v2),
          throwsWithMessage<VectorError>(
            "Cannot calculate do product of vectors with different lengths",
          ));
    });
    test("Test int vector norm", () {
      final v = Vector([1, -3, 7]);
      expect(v.norm(), closeTo(7.6811, 1e-4));
    });
    test("Test double vector norm", () {
      final v = Vector([1.34, -3.2, 9]);
      expect(v.norm(), closeTo(9.6454, 1e-4));
    });
  });
}
