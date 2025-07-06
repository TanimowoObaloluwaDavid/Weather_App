import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food/Provider/theme_provider.dart';
import 'package:food/Theme/theme.dart';
import 'package:food/home_screen.dart';
import 'package:food/splash_screen.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode = ref.watch(themeNotifierProvider);
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode,
      debugShowCheckedModeBanner: false,
      home:SplashScreen(),
    );
  }
}

