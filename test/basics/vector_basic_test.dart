import 'package:algodart/vector.dart';
import 'package:test/test.dart';

import '../random_methods.dart';
import '../test_utils.dart';

void main() {
  group("Constructors", () {
    void testVectorConstructors<T extends num>() {
      test('Vector $T simple constructor', () {
        final n = 3;
        final elements = randomList<T>(n);
        final v = Vector(elements);
        expect(v.length, n);
        for (var i = 0; i < n; i++) {
          expect(v[i], isA<T>());
          expect(v[i], elements[i]);
        }
      });
      test('Vector $T value constructor', () {
        final n = 7;
        final p = randomValue<T>();
        final v = Vector<T>.value(n, value: p);
        expect(v.length, n);
        for (var i = 0; i < n; i++) {
          expect(v[i], isA<T>());
          expect(v[i], p);
        }
      });
      test('Vector $T zeros constructor', () {
        final n = 7;
        final v = Vector<T>.zeros(n);
        expect(v.length, n);
        for (var i = 0; i < n; i++) {
          expect(v[i], isA<T>());
          expect(v[i], 0);
        }
      });
      test('Vector $T basis constructor', () {
        final n = 7;
        final index = testRandom.nextInt(n);
        final v = Vector<T>.basis(n, index);
        for (var i = 0; i < n; i++) {
          expect(v[i], isA<T>());
          expect(v[i], i == index ? 1 : 0);
        }
      });
    }

    testVectorConstructors<int>();
    testVectorConstructors<double>();
  });
  group("Set element", () {
    void testVectorSetMethods<T extends num>() {
      test("Set $T vector at index", () {
        final n = 5;
        final index = testRandom.nextInt(n);
        final elements = randomList<T>(n);
        final p = randomValue<T>();
        final v = Vector(List<T>.from(elements));
        v[index] = p;
        expect(elements[index], isNot(p));
        for (var i = 0; i < n; i++) {
          expect(v[i], i == index ? p : elements[i]);
        }
      });
    }

    testVectorSetMethods<int>();
    testVectorSetMethods<double>();
  });
  group("concat and pad", () {
    void testVectorConcatAndPad<T extends num>() {
      test("Concat $T vectors", () {
        int n1 = 3, n2 = 5;
        final v1 = Vector(randomList<T>(n1)), v2 = Vector(randomList<T>(n2));
        final v = v1.concat(v2);
        expect(v, isA<Vector<T>>());
        expect(v.length, n1 + n2);
        for (var i = 0; i < n1; i++) {
          expect(v[i], v1[i]);
        }
        for (var i = 0; i < n2; i++) {
          expect(v[n1 + i], v2[i]);
        }
      });
      test("pad $T zero to start", () {
        int n1 = 3, n2 = 5;
        final v1 = Vector(randomList<T>(n1));
        final v = v1.padStart(n2);
        expect(v, isA<Vector<T>>());
        expect(v.length, n1 + n2);
        for (var i = 0; i < n2; i++) {
          expect(v[i], 0);
        }
        for (var i = 0; i < n1; i++) {
          expect(v[n2 + i], v1[i]);
        }
      });
      test("pad $T value to start", () {
        final n1 = 3, n2 = 5;
        final p = randomValue<T>();
        final v1 = Vector(randomList<T>(n1));
        final v = v1.padStart(n2, value: p);
        expect(v, isA<Vector<T>>());
        expect(v.length, n1 + n2);
        for (var i = 0; i < n2; i++) {
          expect(v[i], p);
        }
        for (var i = 0; i < n1; i++) {
          expect(v[n2 + i], v1[i]);
        }
      });
      test("pad $T zero to end", () {
        int n1 = 3, n2 = 5;
        final v1 = Vector(randomList<T>(n1));
        final v = v1.padEnd(n2);
        expect(v, isA<Vector<T>>());
        expect(v.length, n1 + n2);
        for (var i = 0; i < n1; i++) {
          expect(v[i], v1[i]);
        }
        for (var i = 0; i < n2; i++) {
          expect(v[n1 + i], 0);
        }
      });
      test("pad $T value to end", () {
        final n1 = 3, n2 = 5;
        final p = randomValue<T>();
        final v1 = Vector(randomList<T>(n1));
        final v = v1.padEnd(n2, value: p);
        expect(v, isA<Vector<T>>());
        expect(v.length, n1 + n2);
        for (var i = 0; i < n1; i++) {
          expect(v[i], v1[i]);
        }
        for (var i = 0; i < n2; i++) {
          expect(v[n1 + i], p);
        }
      });
    }

    testVectorConcatAndPad<int>();
    testVectorConcatAndPad<double>();
  });
  final arithmeticFunctions = {
    "add": (a, b) => a + b,
    "subtract": (a, b) => a - b,
    "multiply": (a, b) => a * b,
  };
  void testVectorArithmetics<T extends num>({
    required String methodName,
    required dynamic Function(dynamic, dynamic) func,
  }) {
    group("$methodName $T arithmetics", () {
      test("$methodName $T operation on two vectors successful", () {
        final n = 5;
        final v1 = Vector(randomList<T>(n)), v2 = Vector(randomList<T>(n));
        final v = func(v1, v2);
        expect(v, isA<Vector<T>>());
        expect(v.length, n);
        for (var i = 0; i < n; i++) {
          expect(v[i], func(v1[i], v2[i]));
        }
      });
      test("$methodName $T operation on vector and number successful", () {
        final n = 5;
        final v1 = Vector(randomList<T>(n));
        final p = randomValue<T>();
        final v = func(v1, p);
        expect(v, isA<Vector<T>>());
        expect(v.length, n);
        for (var i = 0; i < n; i++) {
          expect(v[i], func(v1[i], p));
        }
      });
      test("$methodName $T opeation on different lengths unsuccessfuly", () {
        final n1 = 5, n2 = 4;
        final v1 = Vector(randomList<T>(n1)), v2 = Vector(randomList<T>(n2));
        expect(
          () => func(v1, v2),
          throwsWithMessage<VectorError>(
            "Cannot $methodName vectors with different lengths",
          ),
        );
      });
      test("$methodName $T opeation on string unsuccessfuly", () {
        final n = 5;
        final v = Vector(randomList<T>(n));
        final p = "bla";
        expect(
          () => func(v, p),
          throwsWithMessage<VectorError>(
            "Cannot $methodName type String to vector",
          ),
        );
      });
    });
  }

  for (var entry in arithmeticFunctions.entries) {
    testVectorArithmetics<int>(methodName: entry.key, func: entry.value);
    testVectorArithmetics<double>(methodName: entry.key, func: entry.value);
  }
  group("divide arithmetics", () {
    void testVectorDivide<T extends num>() {
      test("divide $T operation on two vectors successful", () {
        final n = 5;
        final v1 = Vector(randomList<T>(n)),
            v2 = Vector(randomList<T>(n, minValue: 1));
        final v = v1 / v2;
        expect(v, isA<Vector<double>>());
        expect(v.length, n);
        for (var i = 0; i < n; i++) {
          expect(v[i], v1[i] / v2[i]);
        }
      });
      test("divide $T operation on vector and number successful", () {
        final n = 5;
        final v1 = Vector(randomList<T>(n));
        final p = randomValue<T>(minValue: 1);
        final v = v1 / p;
        expect(v, isA<Vector<double>>());
        expect(v.length, n);
        for (var i = 0; i < n; i++) {
          expect(v[i], v1[i] / p);
        }
      });
      test("divide $T opeation different lengths unsuccessful", () {
        final n1 = 5, n2 = 4;
        final v1 = Vector(randomList<T>(n1)), v2 = Vector(randomList<T>(n2));
        expect(
            () => v1 / v2,
            throwsWithMessage<VectorError>(
                "Cannot divide vectors with different lengths"));
      });
      test("divide $T opeation on string unsuccessfuly", () {
        final n = 5;
        final v = Vector(randomList<T>(n));
        final p = "bla";
        expect(
            () => v / p,
            throwsWithMessage<VectorError>(
                "Cannot divide type String to vector"));
      });
    }

    testVectorDivide<int>();
    testVectorDivide<double>();
  });
  group("whole divide arithmetics", () {
    void testWholeVectorDivide<T extends num>() {
      test("whole divide $T operation on two vectors successful", () {
        final n = 5;
        final v1 = Vector(randomList<T>(n)),
            v2 = Vector(randomList<T>(n, minValue: 1));
        final v = v1 ~/ v2;
        expect(v, isA<Vector<int>>());
        expect(v.length, n);
        for (var i = 0; i < n; i++) {
          expect(v[i], v1[i] ~/ v2[i]);
        }
      });
      test("whole divide $T operation on vector and number successful", () {
        final n = 5;
        final v1 = Vector(randomList<T>(n));
        final p = randomValue<T>(minValue: 1);
        final v = v1 ~/ p;
        expect(v, isA<Vector<int>>());
        expect(v.length, n);
        for (var i = 0; i < n; i++) {
          expect(v[i], v1[i] ~/ p);
        }
      });
      test("whole divide $T opeation different lengths unsuccessful", () {
        final n1 = 5, n2 = 4;
        final v1 = Vector(randomList<T>(n1)), v2 = Vector(randomList<T>(n2));
        expect(
            () => v1 ~/ v2,
            throwsWithMessage<VectorError>(
                "Cannot divide vectors with different lengths"));
      });
      test("whole divide $T opeation on string unsuccessfuly", () {
        final n = 5;
        final v = Vector(randomList<T>(n));
        final p = "bla";
        expect(
            () => v ~/ p,
            throwsWithMessage<VectorError>(
                "Cannot divide type String to vector"));
      });
    }

    testWholeVectorDivide<int>();
    testWholeVectorDivide<double>();
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
