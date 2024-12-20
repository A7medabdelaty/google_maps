import 'package:flutter/material.dart';

void main() {
  runApp(const GoogleMapsFlutter());
}

class GoogleMapsFlutter extends StatelessWidget {
  const GoogleMapsFlutter({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Column(),
    );
  }
}
