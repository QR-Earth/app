import 'package:flutter/material.dart';

class SafePadding extends StatelessWidget {
  final Widget child;
  const SafePadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: child,
      ),
    );
  }
}
