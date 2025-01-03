import 'package:flutter/material.dart';

class FutureError extends StatelessWidget{
  final AsyncSnapshot snapshot;

  FutureError(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Durations.medium3,
      tween: Tween<double>(begin: 0, end: 1),
      curve: Easing.standard,
      builder: (context, value, child) {
        return Container(
          transform: Matrix4.translationValues(0, 50-value*50, 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacer(),
          Icon(Icons.error_outline, size: 128.0, color: Colors.red, shadows: [
            Shadow(offset: Offset(0.0, 0.0), blurRadius: 30.0, color: Colors.red),
            Shadow(offset: Offset(0.0, 0.0), blurRadius: 80.0, color: Colors.red),
          ]),
          Text(snapshot.error.toString(), style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 42, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(snapshot.stackTrace.toString(), textAlign: TextAlign.left, style: TextStyle(fontFamily: "Monospace")),
          ),
          Spacer()
        ],
      ),
    );
  }
}