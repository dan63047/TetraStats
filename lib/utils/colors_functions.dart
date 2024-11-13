import 'package:flutter/material.dart';

Color getColorOfRank(int rank){
    if (rank < 1) return Colors.grey;
    if (rank == 1) return Colors.yellowAccent;
    if (rank == 2) return Colors.blueGrey;
    if (rank == 3) return Colors.brown[400]!;
    if (rank <= 9) return Colors.blueAccent;
    if (rank <= 99) return Colors.greenAccent;
    return Colors.grey;
}

Color? getStatColor(num value, num? avgValue, bool higherIsBetter){
    if (avgValue == null) return null;
    num percentile = (higherIsBetter ? value / avgValue : avgValue / value).abs();
    if (percentile > 1.50) return Colors.purpleAccent;
    if (percentile > 1.20) return Colors.blueAccent;
    if (percentile > 0.90) return Colors.greenAccent;
    if (percentile > 0.70) return Colors.yellowAccent;
    return Colors.redAccent;
  }

Color getDifferenceColor(num diff){
  return diff.isNegative ? Colors.redAccent : Colors.greenAccent;
}