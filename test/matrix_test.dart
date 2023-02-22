import 'package:algodart/matrix.dart';
import 'package:test/test.dart';

import 'random_methods.dart';

const List<Type> numberTypes = [int, double];

void main() {
  group("Constructors", () {
    void testMatrixConstructors<T extends num>() {
      test('Matrix $T constructor', () {
        final rows = 3, columns = 7;
        final elements = randomMatrixElements<T>(rows, columns);
        final m = Matrix(elements);
        expect(m.rows, rows);
        expect(m.columns, columns);
        for (var i = 0; i < rows; i++) {
          for (var j = 0; j < columns; j++) {
            expect(m.getAt(i, j), isA<T>());
            expect(m.getAt(i, j), elements[i][j]);
          }
        }
      });
      test('Matrix $T zeros constructor', () {
        final rows = 3, columns = 7;
        final m = Matrix<T>.zeros(rows, columns);
        expect(m.rows, rows);
        expect(m.columns, columns);
        for (var i = 0; i < rows; i++) {
          for (var j = 0; j < columns; j++) {
            expect(m.getAt(i, j), isA<T>());
            expect(m.getAt(i, j), 0);
          }
        }
      });
      test('Matrix $T identity constructor', () {
        final n = 3;
        final m = Matrix<T>.identity(n);
        for (var i = 0; i < n; i++) {
          for (var j = i + 1; j < n; j++) {
            expect(m.getAt(i, j), isA<T>());
            expect(m.getAt(i, j), 0);
          }
        }
        for (var i = 0; i < n; i++) {
          expect(m.getAt(i, i), isA<T>());
          expect(m.getAt(i, i), 1);
        }
      });
    }

    testMatrixConstructors<int>();
    testMatrixConstructors<double>();
  });
  group("Set element", () {
    test("Set int matrix at index", () {
      final rows = 5, columns = 3;
      final row = testRandom.nextInt(rows),
          column = testRandom.nextInt(columns);
      final elements = randomIntMatrixElements(rows, columns);
      final p = -200;
      final m = Matrix(
          List.generate(rows, (index) => List<int>.from(elements[index])));
      m.setAt(row, column, p);
      expect(elements[row][column], isNot(p));
      for (var i = 0; i < rows; i++) {
        for (var j = 0; j < columns; j++) {
          expect(m.getAt(i, j), i == row && j == column ? p : elements[i][j]);
        }
      }
    });
    test("Set double matrix at index", () {
      final rows = 5, columns = 3;
      final row = testRandom.nextInt(rows),
          column = testRandom.nextInt(columns);
      final elements = randomDoubleMatrixElements(rows, columns);
      final p = -200.1;
      final m = Matrix(
          List.generate(rows, (index) => List<double>.from(elements[index])));
      m.setAt(row, column, p);
      expect(elements[row][column], isNot(p));
      for (var i = 0; i < rows; i++) {
        for (var j = 0; j < columns; j++) {
          expect(m.getAt(i, j), i == row && j == column ? p : elements[i][j]);
        }
      }
    });
  });
  group("concat and pad", () {
    void concatTests<T extends num>() {
      test("$T matrices concat horizontally successfuly", () {
        int rows = 3, columns1 = 4, columns2 = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows, columns1)),
            m2 = Matrix(randomMatrixElements<T>(rows, columns2));
        final m = m1.concatHorizontaly(m2);
        expect(m, isA<Matrix<T>>());
        expect(m.rows, rows);
        expect(m.columns, columns1 + columns2);
        for (var i = 0; i < rows; i++) {
          for (var j = 0; j < columns1; j++) {
            expect(m.getAt(i, j), m1.getAt(i, j));
          }
          for (var j = 0; j < columns2; j++) {
            expect(m.getAt(i, j + columns1), m2.getAt(i, j));
          }
        }
      });
      test("$T matrices concat horizontally unsuccessfuly", () {
        int rows1 = 3, rows2 = 9, columns1 = 4, columns2 = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows1, columns1)),
            m2 = Matrix(randomMatrixElements<T>(rows2, columns2));
        expect(
            () => m1.concatHorizontaly(m2),
            throwsA(isA<MatrixError>().having(
              (e) => e.message,
              "message",
              "Cannot concat matrices horizontally "
                  "with different number of rows",
            )));
      });
      test("$T matrices concat vertically", () {
        int rows1 = 3, rows2 = 4, columns = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows1, columns)),
            m2 = Matrix(randomMatrixElements<T>(rows2, columns));
        final m = m1.concatVertically(m2);
        expect(m, isA<Matrix<T>>());
        expect(m.rows, rows1 + rows2);
        expect(m.columns, columns);
        for (var j = 0; j < columns; j++) {
          for (var i = 0; i < rows1; i++) {
            expect(m.getAt(i, j), m1.getAt(i, j));
          }
          for (var i = 0; i < rows2; i++) {
            expect(m.getAt(i + rows1, j), m2.getAt(i, j));
          }
        }
      });
      test("$T matrices concat vertically unsuccessfuly", () {
        int rows1 = 3, rows2 = 9, columns1 = 4, columns2 = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows1, columns1)),
            m2 = Matrix(randomMatrixElements<T>(rows2, columns2));
        expect(
            () => m1.concatVertically(m2),
            throwsA(isA<MatrixError>().having(
              (e) => e.message,
              "message",
              "Cannot concat matrices vertically "
                  "with different number of columns",
            )));
      });
      test("$T matrices pad zeros horizontally from start", () {
        int rows = 3, columns1 = 4, columns2 = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows, columns1));
        final m = m1.padHorizontalyStart(columns2);
        expect(m, isA<Matrix<T>>());
        expect(m.rows, rows);
        expect(m.columns, columns1 + columns2);
        for (var i = 0; i < rows; i++) {
          for (var j = 0; j < columns2; j++) {
            expect(m.getAt(i, j), 0);
          }
          for (var j = 0; j < columns1; j++) {
            expect(m.getAt(i, j + columns2), m1.getAt(i, j));
          }
        }
      });
      test("$T matrices pad value horizontally from start", () {
        int rows = 3, columns1 = 4, columns2 = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows, columns1));
        final p = randomValue<T>();
        final m = m1.padHorizontalyStart(columns2, value: p);
        expect(m, isA<Matrix<T>>());
        expect(m.rows, rows);
        expect(m.columns, columns1 + columns2);
        for (var i = 0; i < rows; i++) {
          for (var j = 0; j < columns2; j++) {
            expect(m.getAt(i, j), p);
          }
          for (var j = 0; j < columns1; j++) {
            expect(m.getAt(i, j + columns2), m1.getAt(i, j));
          }
        }
      });
      test("$T matrices pad zeros horizontally from end", () {
        int rows = 3, columns1 = 4, columns2 = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows, columns1));
        final m = m1.padHorizontalyEnd(columns2);
        expect(m, isA<Matrix<T>>());
        expect(m.rows, rows);
        expect(m.columns, columns1 + columns2);
        for (var i = 0; i < rows; i++) {
          for (var j = 0; j < columns1; j++) {
            expect(m.getAt(i, j), m1.getAt(i, j));
          }
          for (var j = 0; j < columns2; j++) {
            expect(m.getAt(i, j + columns1), 0);
          }
        }
      });
      test("$T matrices pad value horizontally from end", () {
        int rows = 3, columns1 = 4, columns2 = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows, columns1));
        final p = randomValue<T>();
        final m = m1.padHorizontalyEnd(columns2, value: p);
        expect(m, isA<Matrix<T>>());
        expect(m.rows, rows);
        expect(m.columns, columns1 + columns2);
        for (var i = 0; i < rows; i++) {
          for (var j = 0; j < columns1; j++) {
            expect(m.getAt(i, j), m1.getAt(i, j));
          }
          for (var j = 0; j < columns2; j++) {
            expect(m.getAt(i, j + columns1), p);
          }
        }
      });
      test("$T matrices pad zeros vertically from start", () {
        int rows1 = 3, rows2 = 4, columns = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows1, columns));
        final m = m1.padVerticallyStart(rows2);
        expect(m, isA<Matrix<T>>());
        expect(m.rows, rows1 + rows2);
        expect(m.columns, columns);
        for (var j = 0; j < columns; j++) {
          for (var i = 0; i < rows2; i++) {
            expect(m.getAt(i, j), 0);
          }
          for (var i = 0; i < rows1; i++) {
            expect(m.getAt(i + rows2, j), m1.getAt(i, j));
          }
        }
      });
      test("$T matrices pad value vertically from start", () {
        int rows1 = 3, rows2 = 4, columns = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows1, columns));
        final p = randomValue<T>();
        final m = m1.padVerticallyStart(rows2, value: p);
        expect(m, isA<Matrix<T>>());
        expect(m.rows, rows1 + rows2);
        expect(m.columns, columns);
        for (var j = 0; j < columns; j++) {
          for (var i = 0; i < rows2; i++) {
            expect(m.getAt(i, j), p);
          }
          for (var i = 0; i < rows1; i++) {
            expect(m.getAt(i + rows2, j), m1.getAt(i, j));
          }
        }
      });
      test("$T matrices pad zeros vertically from end", () {
        int rows1 = 3, rows2 = 4, columns = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows1, columns));
        final m = m1.padVerticallyEnd(rows2);
        expect(m, isA<Matrix<T>>());
        expect(m.rows, rows1 + rows2);
        expect(m.columns, columns);
        for (var j = 0; j < columns; j++) {
          for (var i = 0; i < rows1; i++) {
            expect(m.getAt(i, j), m1.getAt(i, j));
          }
          for (var i = 0; i < rows2; i++) {
            expect(m.getAt(i + rows1, j), 0);
          }
        }
      });
      test("$T matrices pad value vertically from end", () {
        int rows1 = 3, rows2 = 4, columns = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows1, columns));
        final p = randomValue<T>();
        final m = m1.padVerticallyEnd(rows2, value: p);
        expect(m, isA<Matrix<T>>());
        expect(m.rows, rows1 + rows2);
        expect(m.columns, columns);
        for (var j = 0; j < columns; j++) {
          for (var i = 0; i < rows1; i++) {
            expect(m.getAt(i, j), m1.getAt(i, j));
          }
          for (var i = 0; i < rows2; i++) {
            expect(m.getAt(i + rows1, j), p);
          }
        }
      });
    }

    concatTests<int>();
    concatTests<double>();
  });
  Map<String, dynamic Function(dynamic, dynamic)> arithmeticFunctions = {
    "add": (a, b) => a + b,
    "subtract": (a, b) => a - b,
    "multiply": (a, b) => a * b,
  };
  void testMatrixArithmetics<T extends num>(
      {required String methodName,
      required dynamic Function(dynamic, dynamic) func}) {
    group("$methodName $T arithmetics", () {
      test("$methodName $T operation on two matrixs successful", () {
        final rows = 5, columns = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows, columns)),
            m2 = Matrix(randomMatrixElements<T>(rows, columns));
        final m = func(m1, m2);
        expect(m, isA<Matrix<int>>());
        expect(m.rows, rows);
        expect(m.columns, columns);
        for (var i = 0; i < rows; i++) {
          for (var j = 0; j < columns; j++) {
            expect(m.getAt(i, j), func(m1.getAt(i, j), m2.getAt(i, j)));
          }
        }
      });
      test("$methodName $T operation on matrix and number successful", () {
        final rows = 5, columns = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows, columns));
        final p = randomValue<T>();
        final m = func(m1, p);
        expect(m, isA<Matrix<int>>());
        expect(m.rows, rows);
        expect(m.columns, columns);
        for (var i = 0; i < rows; i++) {
          for (var j = 0; j < columns; j++) {
            expect(m.getAt(i, j), func(m1.getAt(i, j), p));
          }
        }
      });
      test("$methodName $T opeation on different rows unsuccessfuly", () {
        final rows1 = 5, rows2 = 4, columns = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows1, columns)),
            m2 = Matrix(randomMatrixElements<T>(rows2, columns));
        expect(
            () => func(m1, m2),
            throwsA(isA<MatrixError>().having(
              (e) => e.message,
              "Message is different than expected",
              "Cannot $methodName matrices with different number of rows",
            )));
      });
      test("$methodName $T opeation on different columns unsuccessfuly", () {
        final rows = 5, columns1 = 4, columns2 = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows, columns1)),
            m2 = Matrix(randomMatrixElements<T>(rows, columns2));
        expect(
            () => func(m1, m2),
            throwsA(isA<MatrixError>().having(
              (e) => e.message,
              "Message is different than expected",
              "Cannot $methodName matrices with different number of columns",
            )));
      });
      test("$methodName $T opeation on string unsuccessfuly", () {
        final rows = 5, columns = 7;
        final m = Matrix(randomMatrixElements<T>(rows, columns));
        final p = "bla";
        expect(
            () => func(m, p),
            throwsA(isA<MatrixError>().having(
              (e) => e.message,
              "Error message is different than exptend",
              "Cannot $methodName type String to matrix",
            )));
      });
    });
  }

  for (var entry in arithmeticFunctions.entries) {
    testMatrixArithmetics<int>(methodName: entry.key, func: entry.value);
  }
  group("divide arithmetics", () {
    void testMatrixDivideArithmetics<T extends num>() {
      test("divide $T operation on two matrixs successful", () {
        final rows = 5, columns = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows, columns)),
            m2 = Matrix(randomMatrixElements<T>(rows, columns));
        final m = m1 / m2;
        expect(m, isA<Matrix<double>>());
        expect(m.rows, rows);
        expect(m.columns, columns);
        for (var i = 0; i < rows; i++) {
          for (var j = 0; j < columns; j++) {
            expect(m.getAt(i, j), m1.getAt(i, j) / m2.getAt(i, j));
          }
        }
      });
      test("divide $T operation on matrix and number successful", () {
        final rows = 5, columns = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows, columns));
        final p = randomValue<T>();
        final m = m1 / p;
        expect(m, isA<Matrix<double>>());
        expect(m.rows, rows);
        expect(m.columns, columns);
        for (var i = 0; i < rows; i++) {
          for (var j = 0; j < columns; j++) {
            expect(m.getAt(i, j), m1.getAt(i, j) / p);
          }
        }
      });
      test("divide $T opeation different rows unsuccessful", () {
        final rows1 = 5, rows2 = 4, columns = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows1, columns)),
            m2 = Matrix(randomMatrixElements<T>(rows2, columns));
        expect(
            () => m1 / m2,
            throwsA(isA<MatrixError>().having(
              (e) => e.message,
              "Error message is different than expected",
              "Cannot divide matrices with different number of rows",
            )));
      });
      test("divide $T opeation different columns unsuccessful", () {
        final rows = 5, columns1 = 4, columns2 = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows, columns1)),
            m2 = Matrix(randomMatrixElements<T>(rows, columns2));
        expect(
            () => m1 / m2,
            throwsA(isA<MatrixError>().having(
              (e) => e.message,
              "Error message is different than expected",
              "Cannot divide matrices with different number of columns",
            )));
      });
      test("divide $T opeation on string unsuccessfuly", () {
        final rows = 5, columns = 7;
        final m = Matrix(randomMatrixElements<T>(rows, columns));
        final p = "bla";
        expect(
            () => m / p,
            throwsA(isA<MatrixError>().having(
              (e) => e.message,
              "Error is different than expected",
              "Cannot divide type String to matrix",
            )));
      });
    }

    testMatrixDivideArithmetics<int>();
    testMatrixDivideArithmetics<double>();
  });
  group("whole divide arithmetics", () {
    void testMatrixWholeDivideArithmetics<T extends num>() {
      test("whole divide $T operation on two matrixs successful", () {
        final rows = 5, columns = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows, columns)),
            m2 = Matrix(randomMatrixElements<T>(rows, columns, minValue: 1));
        final m = m1 ~/ m2;
        expect(m, isA<Matrix<int>>());
        expect(m.rows, rows);
        expect(m.columns, columns);
        for (var i = 0; i < rows; i++) {
          for (var j = 0; j < columns; j++) {
            expect(m.getAt(i, j), m1.getAt(i, j) ~/ m2.getAt(i, j));
          }
        }
      });

      test("whole divide $T operation on matrix and number successful", () {
        final rows = 5, columns = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows, columns));
        final p = randomValue<T>(minValue: 1);
        final m = m1 ~/ p;
        expect(m, isA<Matrix<int>>());
        expect(m.rows, rows);
        expect(m.columns, columns);
        for (var i = 0; i < rows; i++) {
          for (var j = 0; j < columns; j++) {
            expect(m.getAt(i, j), m1.getAt(i, j) ~/ p);
          }
        }
      });
      test("whole divide $T opeation different rows unsuccessful", () {
        final rows1 = 5, rows2 = 4, columns = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows1, columns)),
            m2 = Matrix(randomMatrixElements<T>(rows2, columns));
        expect(
            () => m1 ~/ m2,
            throwsA(isA<MatrixError>().having(
              (e) => e.message,
              "Different message than expected",
              "Cannot divide matrices with different number of rows",
            )));
      });
      test("whole divide $T opeation different columns unsuccessful", () {
        final rows = 5, columns1 = 4, columns2 = 7;
        final m1 = Matrix(randomMatrixElements<T>(rows, columns1)),
            m2 = Matrix(randomMatrixElements<T>(rows, columns2));
        expect(
            () => m1 ~/ m2,
            throwsA(isA<MatrixError>().having(
              (e) => e.message,
              "Different message than expected",
              "Cannot divide matrices with different number of columns",
            )));
      });
      test("whole divide $T opeation on string unsuccessfuly", () {
        final rows = 5, columns = 7;
        final m = Matrix(randomMatrixElements<T>(rows, columns));
        final p = "bla";
        expect(
            () => m ~/ p,
            throwsA(isA<MatrixError>().having(
              (e) => e.message,
              "different message than expected",
              "Cannot divide type String to matrix",
            )));
      });
    }

    testMatrixWholeDivideArithmetics<int>();
    testMatrixWholeDivideArithmetics<double>();
  });
  group("elements type conversions", () {
    test("convert int to int", () {
      final rows = 5, columns = 7;
      final elements = randomIntMatrixElements(rows, columns);
      final m = Matrix(elements).as<int>();
      expect(m, isA<Matrix<int>>());
      expect(m.rows, rows);
      expect(m.columns, columns);
      for (var i = 0; i < rows; i++) {
        for (var j = 0; j < columns; j++) {
          expect(m.getAt(i, j), isA<int>());
          expect(m.getAt(i, j), elements[i][j]);
        }
      }
    });
    test("convert int to double", () {
      final rows = 5, columns = 7;
      final elements = randomIntMatrixElements(rows, columns);
      final m = Matrix(elements).as<double>();
      expect(m, isA<Matrix<double>>());
      expect(m.rows, rows);
      expect(m.columns, columns);
      for (var i = 0; i < rows; i++) {
        for (var j = 0; j < columns; j++) {
          expect(m.getAt(i, j), isA<double>());
          expect(m.getAt(i, j), elements[i][j].toDouble());
        }
      }
    });
    test("convert double to double", () {
      final rows = 5, columns = 7;
      final elements = randomDoubleMatrixElements(rows, columns);
      final m = Matrix(elements).as<double>();
      expect(m, isA<Matrix<double>>());
      expect(m.rows, rows);
      expect(m.columns, columns);
      for (var i = 0; i < rows; i++) {
        for (var j = 0; j < columns; j++) {
          expect(m.getAt(i, j), isA<double>());
          expect(m.getAt(i, j), elements[i][j]);
        }
      }
    });
    test("convert double to int", () {
      final rows = 5, columns = 7;
      final elements = randomDoubleMatrixElements(rows, columns);
      final m = Matrix(elements).as<int>();
      expect(m, isA<Matrix<int>>());
      expect(m.rows, rows);
      expect(m.columns, columns);
      for (var i = 0; i < rows; i++) {
        for (var j = 0; j < columns; j++) {
          expect(m.getAt(i, j), isA<int>());
          expect(m.getAt(i, j), elements[i][j].toInt());
        }
      }
    });
  });
}
