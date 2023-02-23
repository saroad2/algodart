import 'dart:math';

import 'package:algodart/exceptions.dart';
import 'package:algodart/number_conversions.dart';

class VectorError extends MessagedException {
  const VectorError(super.message);
}

class Vector<T extends num> {
  final List<T> elements;
  const Vector(this.elements);
  Vector.generate(int length, T Function(int) generator)
      : elements = List.generate(length, generator).toList();
  Vector.value(int num, {required T value})
      : this.generate(num, (index) => value);
  Vector.zeros(int num) : this.value(num, value: zeroVal<T>());
  Vector.basis(int num, int index)
      : this.generate(num, (i) => i == index ? oneVal() : zeroVal());

  Vector<U> as<U extends num>() =>
      Vector(elements.map(convertNumberTo<U>).toList());

  int get length => elements.length;
  T operator [](int index) {
    return elements[index];
  }

  void operator []=(int index, value) {
    elements[index] = value;
  }

  Vector<T> padStart(int num, {T? value}) {
    value ??= zeroVal();
    return Vector.generate(num, (index) => value!).concat(this);
  }

  Vector<T> padEnd(int num, {T? value}) {
    value ??= zeroVal();
    return concat(Vector.generate(num, (index) => value!));
  }

  Vector<T> concat(Vector<T> other) {
    return Vector(elements + other.elements);
  }

  Vector<T> operator +(dynamic other) {
    return _operateElementWise(other,
        operation: (a, b) => (a + b) as T, methodName: "add");
  }

  Vector<T> operator -(dynamic other) {
    return _operateElementWise(other,
        operation: (a, b) => (a - b) as T, methodName: "subtract");
  }

  Vector<T> operator *(dynamic other) {
    return _operateElementWise(other,
        operation: (a, b) => (a * b) as T, methodName: "multiply");
  }

  Vector<double> operator /(dynamic other) {
    return _operateElementWise(other,
        operation: (a, b) => a / b, methodName: "divide");
  }

  Vector<int> operator ~/(dynamic other) {
    return _operateElementWise(other,
        operation: (a, b) => a ~/ b, methodName: "divide");
  }

  T dot(Vector<T> other) {
    if (length != other.length) {
      throw VectorError(
          "Cannot calculate do product of vectors with different lengths");
    }
    num value = 0;
    for (var i = 0; i < length; i++) {
      value += this[i] * other[i];
    }
    return value as T;
  }

  double norm() => sqrt(this.dot(this));

  Vector<U> _operateElementWise<U extends num>(dynamic other,
      {required U Function(T, num) operation, required String methodName}) {
    if (other is num) {
      return Vector.generate(
          length, (index) => (operation(this[index], other)));
    }
    if (other is! Vector) {
      throw VectorError(
          "Cannot $methodName type ${other.runtimeType} to vector");
    }
    if (length != other.length) {
      throw VectorError("Cannot $methodName vectors with different lengths");
    }
    return Vector.generate(
        length, (index) => operation(this[index], other[index]));
  }
}
