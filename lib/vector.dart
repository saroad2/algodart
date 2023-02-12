class VectorError implements Exception {
  final String message;
  VectorError(this.message);
}

class Vector<T extends num> {
  final List<T> elements;
  const Vector(this.elements);
  Vector.generate(int length, T Function(int) generator)
      : elements = List.generate(length, generator).toList();
  Vector.zeros(int num) : this.generate(num, (index) => _zeroVal());
  Vector.basis(int num, int index)
      : this.generate(num, (i) => i == index ? _oneVal() : _zeroVal());

  Vector<U> as<U extends num>() => Vector(elements.map((e) {
        if (U == double) return e.toDouble() as U;
        if (U == int) return e.toInt() as U;
        return e as U;
      }).toList());

  int get length => elements.length;
  T operator [](int index) {
    return elements[index];
  }

  void operator []=(int index, value) {
    elements[index] = value;
  }

  Vector<T> padStart(int num, {T? value}) {
    value ??= _zeroVal();
    return Vector.generate(num, (index) => value!).concat(this);
  }

  Vector<T> padEnd(int num, {T? value}) {
    value ??= _zeroVal();
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

  static T _zeroVal<T extends num>() => T == double ? 0.0 as T : 0 as T;
  static T _oneVal<T extends num>() => T == double ? 1.0 as T : 1 as T;
}
