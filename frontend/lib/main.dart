import 'package:flutter/material.dart';
import 'routes/app_routing.dart';

void main() {
  runApp(const StyleListApp());
}

class StyleListApp extends StatelessWidget {
  const StyleListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StyleList Fashion',
      initialRoute: AppRouting.splash,
      onGenerateRoute: AppRouting.generateRoute,
    );
  }
}