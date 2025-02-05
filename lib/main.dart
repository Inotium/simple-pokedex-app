import 'package:flutter/material.dart';
import 'package:pokedex_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          home:  GenerationScreen(),
        );
      },
    );
  }
}
