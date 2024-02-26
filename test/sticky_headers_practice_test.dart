import 'package:flutter_test/flutter_test.dart';

import 'package:sticky_headers_practice/sticky_headers_practice.dart';

void main() {
  test('adds one to input values', () {
    final calculator = Sticky();
    expect(calculator.addOne(2), 3);
    expect(calculator.addOne(-7), -6);
    expect(calculator.addOne(0), 1);
  });
}
