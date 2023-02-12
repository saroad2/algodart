import 'dart:math';

import 'package:algodart/vector.dart';
import 'package:test/test.dart';

final testRandom = Random();
List<double> randomDoubleList(int length) =>
    List.generate(length, (index) => testRandom.nextDouble());
List<int> randomIntList(int length, {int minNumber = 0, int maxNumber = 100}) =>
    List.generate(length,
        (index) => testRandom.nextInt(maxNumber - minNumber) + maxNumber);

void main() {
  group("Constructors", () {
    test('Vector int constructor', () {
      final n = 3;
      final elements = randomIntList(n);
      final v = Vector(elements);
      expect(v.length, n);
      for (var i = 0; i < n; i++) {
        expect(v[i], isA<int>());
        expect(v[i], elements[i]);
      }
    });
    test('Vector double constructor', () {
      final n = 3;
      final elements = randomDoubleList(n);
      final v = Vector(elements);
      expect(v.length, n);
      for (var i = 0; i < n; i++) {
        expect(v[i], isA<double>());
        expect(v[i], elements[i]);
      }
    });
    test('Vector int zeros constructor', () {
      final n = 7;
      final v = Vector<int>.zeros(n);
      expect(v.length, n);
      for (var i = 0; i < n; i++) {
        expect(v[i], isA<int>());
        expect(v[i], 0);
      }
    });
    test('Vector double zeros constructor', () {
      final n = 7;
      final v = Vector<double>.zeros(n);
      expect(v.length, n);
      for (var i = 0; i < n; i++) {
        expect(v[i], isA<double>());
        expect(v[i], 0);
      }
    });
    test('Vector int basis constructor', () {
      final n = 7;
      final index = testRandom.nextInt(n);
      final v = Vector<int>.basis(n, index);
      for (var i = 0; i < n; i++) {
        expect(v[i], isA<int>());
        expect(v[i], i == index ? 1 : 0);
      }
    });
    test('Vector double basis constructor', () {
      final n = 7;
      final index = testRandom.nextInt(n);
      final v = Vector<double>.basis(n, index);
      for (var i = 0; i < n; i++) {
        expect(v[i], isA<double>());
        expect(v[i], i == index ? 1 : 0);
      }
    });
  });
  group("Set element", () {
    test("Set int vector at index", () {
      final n = 5;
      final index = testRandom.nextInt(n);
      final elements = randomIntList(n);
      final p = -200;
      final v = Vector(List<int>.from(elements));
      v[index] = p;
      expect(elements[index], isNot(p));
      for (var i = 0; i < n; i++) {
        expect(v[i], i == index ? p : elements[i]);
      }
    });
    test("Set double vector at index", () {
      final n = 5;
      final index = testRandom.nextInt(n);
      final elements = randomDoubleList(n);
      final p = -200.0;
      final v = Vector(List<double>.from(elements));
      v[index] = p;
      expect(elements[index], isNot(p));
      for (var i = 0; i < n; i++) {
        expect(v[i], i == index ? p : elements[i]);
      }
    });
  });
  group("concat and pad", () {
    test("Concat int vectors", () {
      int n1 = 3, n2 = 5;
      final v1 = Vector(randomIntList(n1)), v2 = Vector(randomIntList(n2));
      final v = v1.concat(v2);
      expect(v, isA<Vector<int>>());
      expect(v.length, n1 + n2);
      for (var i = 0; i < n1; i++) {
        expect(v[i], v1[i]);
      }
      for (var i = 0; i < n2; i++) {
        expect(v[n1 + i], v2[i]);
      }
    });
    test("Concat double vectors", () {
      int n1 = 3, n2 = 5;
      final v1 = Vector(randomDoubleList(n1)),
          v2 = Vector(randomDoubleList(n2));
      final v = v1.concat(v2);
      expect(v, isA<Vector<double>>());
      expect(v.length, n1 + n2);
      for (var i = 0; i < n1; i++) {
        expect(v[i], v1[i]);
      }
      for (var i = 0; i < n2; i++) {
        expect(v[n1 + i], v2[i]);
      }
    });
    test("pad int zero to start", () {
      int n1 = 3, n2 = 5;
      final v1 = Vector(randomIntList(n1));
      final v = v1.padStart(n2);
      expect(v, isA<Vector<int>>());
      expect(v.length, n1 + n2);
      for (var i = 0; i < n2; i++) {
        expect(v[i], 0);
      }
      for (var i = 0; i < n1; i++) {
        expect(v[n2 + i], v1[i]);
      }
    });
    test("pad int value to start", () {
      int n1 = 3, n2 = 5;
      int p = 15;
      final v1 = Vector(randomIntList(n1));
      final v = v1.padStart(n2, value: p);
      expect(v, isA<Vector<int>>());
      expect(v.length, n1 + n2);
      for (var i = 0; i < n2; i++) {
        expect(v[i], p);
      }
      for (var i = 0; i < n1; i++) {
        expect(v[n2 + i], v1[i]);
      }
    });
    test("pad int zero to end", () {
      int n1 = 3, n2 = 5;
      final v1 = Vector(randomIntList(n1));
      final v = v1.padEnd(n2);
      expect(v, isA<Vector<int>>());
      expect(v.length, n1 + n2);
      for (var i = 0; i < n1; i++) {
        expect(v[i], v1[i]);
      }
      for (var i = 0; i < n2; i++) {
        expect(v[n1 + i], 0);
      }
    });
    test("pad int value to end", () {
      int n1 = 3, n2 = 5;
      int p = 15;
      final v1 = Vector(randomIntList(n1));
      final v = v1.padEnd(n2, value: p);
      expect(v, isA<Vector<int>>());
      expect(v.length, n1 + n2);
      for (var i = 0; i < n1; i++) {
        expect(v[i], v1[i]);
      }
      for (var i = 0; i < n2; i++) {
        expect(v[n1 + i], p);
      }
    });
    test("pad double zero to start", () {
      int n1 = 3, n2 = 5;
      final v1 = Vector(randomDoubleList(n1));
      final v = v1.padStart(n2);
      expect(v, isA<Vector<double>>());
      expect(v.length, n1 + n2);
      for (var i = 0; i < n2; i++) {
        expect(v[i], 0);
      }
      for (var i = 0; i < n1; i++) {
        expect(v[n2 + i], v1[i]);
      }
    });
    test("pad double value to start", () {
      int n1 = 3, n2 = 5;
      double p = 15.2;
      final v1 = Vector(randomDoubleList(n1));
      final v = v1.padStart(n2, value: p);
      expect(v, isA<Vector<double>>());
      expect(v.length, n1 + n2);
      for (var i = 0; i < n2; i++) {
        expect(v[i], p);
      }
      for (var i = 0; i < n1; i++) {
        expect(v[n2 + i], v1[i]);
      }
    });
    test("pad double zero to end", () {
      int n1 = 3, n2 = 5;
      final v1 = Vector(randomDoubleList(n1));
      final v = v1.padEnd(n2);
      expect(v, isA<Vector<double>>());
      expect(v.length, n1 + n2);
      for (var i = 0; i < n1; i++) {
        expect(v[i], v1[i]);
      }
      for (var i = 0; i < n2; i++) {
        expect(v[n1 + i], 0);
      }
    });
    test("pad double value to end", () {
      int n1 = 3, n2 = 5;
      double p = 15.2;
      final v1 = Vector(randomDoubleList(n1));
      final v = v1.padEnd(n2, value: p);
      expect(v, isA<Vector<double>>());
      expect(v.length, n1 + n2);
      for (var i = 0; i < n1; i++) {
        expect(v[i], v1[i]);
      }
      for (var i = 0; i < n2; i++) {
        expect(v[n1 + i], p);
      }
    });
  });
  final arithmeticFunctions = {
    "add": (a, b) => a + b,
    "subtract": (a, b) => a - b,
    "multiply": (a, b) => a * b,
  };
  for (var entry in arithmeticFunctions.entries) {
    final methodName = entry.key, func = entry.value;
    group("$methodName arithmetics", () {
      test("$methodName int operation on two vectors successful", () {
        final n = 5;
        final v1 = Vector(randomIntList(n)), v2 = Vector(randomIntList(n));
        final v = func(v1, v2);
        expect(v, isA<Vector<int>>());
        expect(v.length, n);
        for (var i = 0; i < n; i++) {
          expect(v[i], func(v1[i], v2[i]));
        }
      });
      test("$methodName int operation on vector and number successful", () {
        final n = 5;
        final v1 = Vector(randomIntList(n));
        final p = testRandom.nextInt(100);
        final v = func(v1, p);
        expect(v, isA<Vector<int>>());
        expect(v.length, n);
        for (var i = 0; i < n; i++) {
          expect(v[i], func(v1[i], p));
        }
      });
      test("$methodName int opeation on different lengths unsuccessfuly", () {
        final n1 = 5, n2 = 4;
        final v1 = Vector(randomIntList(n1)), v2 = Vector(randomIntList(n2));
        expect(() => func(v1, v2), throwsA(isA<VectorError>()));
      });
      test("$methodName int opeation on string unsuccessfuly", () {
        final n = 5;
        final v = Vector(randomIntList(n));
        final p = "bla";
        expect(() => func(v, p), throwsA(isA<VectorError>()));
      });
      test("$methodName double operation successfuly", () {
        final n = 5;
        final v1 = Vector(randomDoubleList(n)),
            v2 = Vector(randomDoubleList(n));
        final v = func(v1, v2);
        expect(v, isA<Vector<double>>());
        expect(v.length, n);
        for (var i = 0; i < n; i++) {
          expect(v[i], func(v1[i], v2[i]));
        }
      });
      test("$methodName double operation on vector and number successful", () {
        final n = 5;
        final v1 = Vector(randomDoubleList(n));
        final p = testRandom.nextDouble();
        final v = func(v1, p);
        expect(v, isA<Vector<double>>());
        expect(v.length, n);
        for (var i = 0; i < n; i++) {
          expect(v[i], func(v1[i], p));
        }
      });
      test("$methodName double operation unsuccessful", () {
        final n1 = 5, n2 = 4;
        final v1 = Vector(randomDoubleList(n1)),
            v2 = Vector(randomDoubleList(n2));
        expect(() => func(v1, v2), throwsA(isA<VectorError>()));
      });
      test("$methodName double opeation on string unsuccessfuly", () {
        final n = 5;
        final v = Vector(randomDoubleList(n));
        final p = "bla";
        expect(() => func(v, p), throwsA(isA<VectorError>()));
      });
    });
  }
  group("divide arithmetics", () {
    test("divide int operation on two vectors successful", () {
      final n = 5;
      final v1 = Vector(randomIntList(n)), v2 = Vector(randomIntList(n));
      final v = v1 / v2;
      expect(v, isA<Vector<double>>());
      expect(v.length, n);
      for (var i = 0; i < n; i++) {
        expect(v[i], v1[i] / v2[i]);
      }
    });
    test("divide int operation on vector and number successful", () {
      final n = 5;
      final v1 = Vector(randomIntList(n));
      final p = testRandom.nextInt(100);
      final v = v1 / p;
      expect(v, isA<Vector<double>>());
      expect(v.length, n);
      for (var i = 0; i < n; i++) {
        expect(v[i], v1[i] / p);
      }
    });
    test("divide int opeation different lengths unsuccessful", () {
      final n1 = 5, n2 = 4;
      final v1 = Vector(randomIntList(n1)), v2 = Vector(randomIntList(n2));
      expect(() => v1 / v2, throwsA(isA<VectorError>()));
    });
    test("divide int opeation on string unsuccessfuly", () {
      final n = 5;
      final v = Vector(randomIntList(n));
      final p = "bla";
      expect(() => v / p, throwsA(isA<VectorError>()));
    });
    test("divide double operation successfuly", () {
      final n = 5;
      final v1 = Vector(randomDoubleList(n)), v2 = Vector(randomDoubleList(n));
      final v = v1 / v2;
      expect(v, isA<Vector<double>>());
      expect(v.length, n);
      for (var i = 0; i < n; i++) {
        expect(v[i], v1[i] / v2[i]);
      }
    });
    test("divide double operation on vector and number successful", () {
      final n = 5;
      final v1 = Vector(randomDoubleList(n));
      final p = testRandom.nextDouble();
      final v = v1 / p;
      expect(v, isA<Vector<double>>());
      expect(v.length, n);
      for (var i = 0; i < n; i++) {
        expect(v[i], v1[i] / p);
      }
    });
    test("divide double opeation different length unsuccessful", () {
      final n1 = 5, n2 = 4;
      final v1 = Vector(randomDoubleList(n1)),
          v2 = Vector(randomDoubleList(n2));
      expect(() => v1 / v2, throwsA(isA<VectorError>()));
    });
    test("divide double opeation on string unsuccessfuly", () {
      final n = 5;
      final v = Vector(randomDoubleList(n));
      final p = "bla";
      expect(() => v / p, throwsA(isA<VectorError>()));
    });
  });
  group("whole divide arithmetics", () {
    test("whole divide int operation on two vectors successful", () {
      final n = 5;
      final v1 = Vector(randomIntList(n)),
          v2 = Vector(randomIntList(n, minNumber: 1));
      final v = v1 ~/ v2;
      expect(v, isA<Vector<int>>());
      expect(v.length, n);
      for (var i = 0; i < n; i++) {
        expect(v[i], v1[i] ~/ v2[i]);
      }
    });
    test("whole divide int operation on vector and number successful", () {
      final n = 5;
      final v1 = Vector(randomIntList(n));
      final p = testRandom.nextInt(100) + 1;
      final v = v1 ~/ p;
      expect(v, isA<Vector<int>>());
      expect(v.length, n);
      for (var i = 0; i < n; i++) {
        expect(v[i], v1[i] ~/ p);
      }
    });
    test("whole divide int opeation different lengths unsuccessful", () {
      final n1 = 5, n2 = 4;
      final v1 = Vector(randomIntList(n1)), v2 = Vector(randomIntList(n2));
      expect(() => v1 ~/ v2, throwsA(isA<VectorError>()));
    });
    test("whole divide int opeation on string unsuccessfuly", () {
      final n = 5;
      final v = Vector(randomIntList(n));
      final p = "bla";
      expect(() => v ~/ p, throwsA(isA<VectorError>()));
    });
    test("whole divide double operation successfuly", () {
      final n = 5;
      final v1 = Vector(randomDoubleList(n)), v2 = Vector(randomDoubleList(n));
      final v = v1 ~/ v2;
      expect(v, isA<Vector<int>>());
      expect(v.length, n);
      for (var i = 0; i < n; i++) {
        expect(v[i], v1[i] ~/ v2[i]);
      }
    });
    test("whole divide double operation on vector and number successful", () {
      final n = 5;
      final v1 = Vector(randomDoubleList(n));
      final p = testRandom.nextDouble();
      final v = v1 ~/ p;
      expect(v, isA<Vector<int>>());
      expect(v.length, n);
      for (var i = 0; i < n; i++) {
        expect(v[i], v1[i] ~/ p);
      }
    });
    test("whole divide double opeation different lengths unsuccessful", () {
      final n1 = 5, n2 = 4;
      final v1 = Vector(randomDoubleList(n1)),
          v2 = Vector(randomDoubleList(n2));
      expect(() => v1 ~/ v2, throwsA(isA<VectorError>()));
    });
    test("whole divide double opeation on string unsuccessfuly", () {
      final n = 5;
      final v = Vector(randomDoubleList(n));
      final p = "bla";
      expect(() => v ~/ p, throwsA(isA<VectorError>()));
    });
  });
  group("elements type conversions", () {
    test("convert int to int", () {
      final n = 5;
      final elements = randomIntList(n);
      final v = Vector(elements).as<int>();
      expect(v, isA<Vector<int>>());
      expect(v.length, n);
      for (var i = 0; i < n; i++) {
        expect(v[i], isA<int>());
        expect(v[i], elements[i]);
      }
    });
    test("convert int to double", () {
      final n = 5;
      final elements = randomIntList(n);
      final v = Vector(elements).as<double>();
      expect(v, isA<Vector<double>>());
      expect(v.length, n);
      for (var i = 0; i < n; i++) {
        expect(v[i], isA<double>());
        expect(v[i], elements[i].toDouble());
      }
    });
    test("convert double to double", () {
      final n = 5;
      final elements = randomDoubleList(n);
      final v = Vector(elements).as<double>();
      expect(v, isA<Vector<double>>());
      expect(v.length, n);
      for (var i = 0; i < n; i++) {
        expect(v[i], isA<double>());
        expect(v[i], elements[i]);
      }
    });
    test("convert double to int", () {
      final n = 5;
      final elements = randomDoubleList(n);
      final v = Vector(elements).as<int>();
      expect(v, isA<Vector<int>>());
      expect(v.length, n);
      for (var i = 0; i < n; i++) {
        expect(v[i], isA<int>());
        expect(v[i], elements[i].toInt());
      }
    });
  });
}
