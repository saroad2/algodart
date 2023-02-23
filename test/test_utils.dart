import 'package:algodart/exceptions.dart';
import 'package:test/test.dart';

Matcher throwsWithMessage<T extends MessagedException>(String message) {
  return throwsA(
      isA<T>().having((e) => e.message, "different message", message));
}
