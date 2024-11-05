import 'package:flutter/material.dart';

class InfoThingy extends StatelessWidget{
  final String info;

  const InfoThingy(this.info);

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.info_outline, size: 128.0, color: Colors.grey.shade800),
        SizedBox(height: 5.0),
        Text(info, textAlign: TextAlign.center),
      ],
    ));
  }
  
}