// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/finesse.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/text_shadow.dart';

class FinesseThingy extends StatelessWidget{
  final Finesse? finesse;
  final double? finessePercentage;

  const FinesseThingy(this.finesse, this.finessePercentage, {super.key});

  Color getFinesseColor(){
    if (finesse == null) return Colors.grey;
    if (finesse!.faults == 0) return Colors.purpleAccent;
    if (finessePercentage! > 0.4) return Colors.white;
    else return Colors.redAccent;
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        const Text("f", style: TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: 65,
          height: 1.2,
        )),
        const Positioned(left: 25, top: 20, child: Text("inesse", style: TextStyle(fontFamily: "Eurostile Round Extended"))),
        Positioned(
          right: 0, top: 20,
          child: Text("${finesse != null ? finesse!.faults : "---"}F", style: TextStyle(
            color: getFinesseColor()
          ))),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text("${finesse != null ? f2.format(finessePercentage! * 100) : "---.--"}%", style: TextStyle(
            shadows: textShadow,
            fontFamily: "Eurostile Round Extended",
            fontSize: 36,
            fontWeight: FontWeight.w500,
            color: getFinesseColor()
          )),
        )
      ],
    );
  }
}