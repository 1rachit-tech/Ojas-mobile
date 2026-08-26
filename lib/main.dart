import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/main_scaffold.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider<ThemeController>(
      create: (_) => ThemeController(),
      child: const OjasApp(),
    ),
  );
}

class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode value) {
    if (_themeMode == value) {
      return;
    }
    _themeMode = value;
    notifyListeners();
  }

  void toggleBrightness(Brightness brightness) {
    setThemeMode(
      brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark,
    );
  }
}

class OjasApp extends StatelessWidget {
  const OjasApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final lightScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.light,
    );
    final darkScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'OJAS',
      debugShowCheckedModeBanner: false,
      themeMode: themeController.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
        scaffoldBackgroundColor: lightScheme.surface,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkScheme,
        scaffoldBackgroundColor: darkScheme.surface,
      ),
      home: const MainScaffold(),
    );
  }
}
