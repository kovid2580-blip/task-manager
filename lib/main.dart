import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/task_provider.dart';
import 'screens/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPixelMode = ref.watch(isPixelModeProvider);

    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: isPixelMode ? _buildPixelTheme() : _buildModernTheme(),
      home: const DashboardScreen(),
    );
  }

  ThemeData _buildModernTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      primaryColor: Colors.orange,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.orange,
        brightness: Brightness.dark,
        primary: Colors.orange,
        surface: const Color(0xFF1E1E1E),
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  ThemeData _buildPixelTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      primaryColor: const Color(0xFF00FF88),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00FF88),
        surface: Colors.black,
        onSurface: Color(0xFF00FF88),
      ),
      textTheme: GoogleFonts.pressStart2pTextTheme(ThemeData.dark().textTheme).copyWith(
        bodyMedium: const TextStyle(color: Color(0xFF00FF88)),
        bodyLarge: const TextStyle(color: Color(0xFF00FF88)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,
        titleTextStyle: TextStyle(color: Color(0xFF00FF88), fontSize: 18),
      ),
      cardTheme: CardThemeData(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF00FF88), width: 2),
          borderRadius: BorderRadius.circular(0),
        ),
      ),
    );
  }
}
