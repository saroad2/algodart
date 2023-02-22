T zeroVal<T extends num>() => T == double ? 0.0 as T : 0 as T;
T oneVal<T extends num>() => T == double ? 1.0 as T : 1 as T;
U convertNumberTo<U extends num>(num number) {
  if (U == double) return number.toDouble() as U;
  if (U == int) return number.toInt() as U;
  return number as U;
}
