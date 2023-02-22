import 'dart:math';

final testRandom = Random();

const defaultMinValue = 0, defaultMaxValue = 100;

T randomValue<T extends num>(
    {num minValue = defaultMinValue, num maxValue = defaultMaxValue}) {
  if (T == int) {
    final minInt = minValue.toInt(), maxInt = maxValue.toInt();
    return (testRandom.nextInt(maxInt - minInt) + maxInt) as T;
  }
  if (T == double) {
    final minDouble = minValue.toDouble(), maxDouble = maxValue.toDouble();
    return (testRandom.nextDouble() * (maxDouble - minDouble) + minDouble) as T;
  }
  throw Exception("Cannot randomize a value of type $T");
}

List<double> randomDoubleList(
  int length, {
  num minValue = defaultMinValue,
  num maxValue = defaultMaxValue,
}) =>
    List.generate(
      length,
      (index) => randomValue(minValue: minValue, maxValue: maxValue),
    );
List<int> randomIntList(
  int length, {
  num minValue = defaultMinValue,
  num maxValue = defaultMaxValue,
}) =>
    List.generate(
      length,
      (index) => randomValue(minValue: minValue, maxValue: maxValue),
    );

List<List<T>> randomMatrixElements<T extends num>(
  int rows,
  int columns, {
  num minValue = defaultMinValue,
  num maxValue = defaultMaxValue,
}) {
  if (T == double) {
    return randomDoubleMatrixElements(rows, columns,
        minValue: minValue, maxValue: maxValue) as List<List<T>>;
  }
  if (T == int) {
    return randomIntMatrixElements(rows, columns,
        minValue: minValue, maxValue: maxValue) as List<List<T>>;
  }
  throw Exception("Could not create matrix elements of type $T");
}

List<List<int>> randomIntMatrixElements(
  int rows,
  int columns, {
  num minValue = defaultMinValue,
  num maxValue = defaultMaxValue,
}) =>
    List.generate(
      rows,
      (index) => randomIntList(columns, minValue: minValue, maxValue: maxValue),
    );
List<List<double>> randomDoubleMatrixElements(int rows, int columns,
        {num minValue = defaultMinValue, num maxValue = defaultMaxValue}) =>
    List.generate(
        rows,
        (index) =>
            randomDoubleList(columns, minValue: minValue, maxValue: maxValue));
