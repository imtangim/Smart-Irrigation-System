import 'package:flutter/material.dart';

class ErrorBox extends StatelessWidget {
  final String text;
  const ErrorBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
