import 'package:algodart/exceptions.dart';
import 'package:algodart/number_conversions.dart';

class MatrixError extends MessagedException {
  const MatrixError(super.message);
}

class Matrix<T extends num> {
  final List<List<T>> elements;
  Matrix(this.elements)
      : assert(elements.isNotEmpty, "Matrix must have at least one row."),
        assert(
          elements.every((row) => row.length == elements[0].length),
          "Matrix must have equal number of columns for each row.",
        );
  Matrix.generate(int rows, int columns, T Function(int, int) generator)
      : elements = List.generate(
          rows,
          (row) => List.generate(columns, (column) => generator(row, column)),
        );
  Matrix.value(int rows, int columns, {required T value})
      : this.generate(rows, columns, (row, column) => value);
  Matrix.zeros(int rows, int columns)
      : this.value(rows, columns, value: zeroVal());
  Matrix.identity(int n)
      : this.generate(
            n, n, (row, column) => row == column ? oneVal() : zeroVal());

  Matrix<U> as<U extends num>() => Matrix(
      elements.map((row) => row.map(convertNumberTo<U>).toList()).toList());

  int get rows => elements.length;
  int get columns => elements.isNotEmpty ? elements[0].length : 0;

  T getAt(int row, int column) => elements[row][column];
  void setAt(int row, int column, T value) {
    elements[row][column] = value;
  }

  Matrix<T> padHorizontalyStart(int n, {T? value}) {
    value ??= zeroVal();
    var paddingMatrix = Matrix<T>.value(rows, n, value: value);
    return paddingMatrix.concatHorizontaly(this);
  }

  Matrix<T> padHorizontalyEnd(int n, {T? value}) {
    value ??= zeroVal();
    var paddingMatrix = Matrix<T>.value(rows, n, value: value);
    return concatHorizontaly(paddingMatrix);
  }

  Matrix<T> padVerticallyStart(int n, {T? value}) {
    value ??= zeroVal();
    var paddingMatrix = Matrix<T>.value(n, columns, value: value);
    return paddingMatrix.concatVertically(this);
  }

  Matrix<T> padVerticallyEnd(int n, {T? value}) {
    value ??= zeroVal();
    var paddingMatrix = Matrix<T>.value(n, columns, value: value);
    return concatVertically(paddingMatrix);
  }

  Matrix<T> concatHorizontaly(Matrix<T> other) {
    if (rows != other.rows) {
      throw MatrixError(
        "Cannot concat matrices horizontally with different number of rows",
      );
    }
    return Matrix.generate(
      rows,
      columns + other.columns,
      (row, column) => column < columns
          ? getAt(row, column)
          : other.getAt(row, column - columns),
    );
  }

  Matrix<T> concatVertically(Matrix<T> other) {
    if (columns != other.columns) {
      throw MatrixError(
        "Cannot concat matrices vertically "
        "with different number of columns",
      );
    }
    return Matrix.generate(
      rows + other.rows,
      columns,
      (row, column) =>
          row < rows ? getAt(row, column) : other.getAt(row - rows, column),
    );
  }

  Matrix<T> operator +(dynamic other) {
    return _operateElementWise(other,
        operation: (a, b) => (a + b) as T, methodName: "add");
  }

  Matrix<T> operator -(dynamic other) {
    return _operateElementWise(other,
        operation: (a, b) => (a - b) as T, methodName: "subtract");
  }

  Matrix<T> operator *(dynamic other) {
    return _operateElementWise(other,
        operation: (a, b) => (a * b) as T, methodName: "multiply");
  }

  Matrix<double> operator /(dynamic other) {
    return _operateElementWise(other,
        operation: (a, b) => a / b, methodName: "divide");
  }

  Matrix<int> operator ~/(dynamic other) {
    return _operateElementWise(other,
        operation: (a, b) => a ~/ b, methodName: "divide");
  }

  Matrix<U> _operateElementWise<U extends num>(dynamic other,
      {required U Function(T, num) operation, required String methodName}) {
    if (other is num) {
      return Matrix.generate(rows, columns,
          (row, column) => (operation(getAt(row, column), other)));
    }
    if (other is! Matrix) {
      throw MatrixError(
          "Cannot $methodName type ${other.runtimeType} to matrix");
    }
    if (rows != other.rows) {
      throw MatrixError(
          "Cannot $methodName matrices with different number of rows");
    }
    if (columns != other.columns) {
      throw MatrixError(
          "Cannot $methodName matrices with different number of columns");
    }
    return Matrix.generate(
      rows,
      columns,
      (row, column) => operation(getAt(row, column), other.getAt(row, column)),
    );
  }
}
