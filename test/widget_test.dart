import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojas/main.dart';

void main() {
  test('theme controller changes theme mode', () {
    final controller = ThemeController();

    expect(controller.themeMode, ThemeMode.system);

    controller.setThemeMode(ThemeMode.dark);

    expect(controller.themeMode, ThemeMode.dark);
  });
}
