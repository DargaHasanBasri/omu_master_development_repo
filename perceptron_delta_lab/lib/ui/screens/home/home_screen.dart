import 'package:flutter/material.dart';
import 'package:gen/gen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Hello from HomeScreen',
          style: TextStyle(color: ColorName.blueLotus),
        ),
      ),
    );
  }
}
