// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(body: Center(child: Text('Hello World!'))),
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'app/route.dart';
import 'core/widgets/Const/colors.dart';
// import 'features/settings/ui/SettingsPage.dart';

void main() => runApp(const MyApp());

// ---------- With Router for real Use ----------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
      ),
    );
  }
}

// // ---------- Per Page Testing ----------
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
//         scaffoldBackgroundColor: const Color(0xFFF9F9F9),
//       ),
//       home: const SettingsPage(),
//     );
//   }
// }
