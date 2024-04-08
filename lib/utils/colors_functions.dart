import 'package:flutter/material.dart';

Color getColorOfRank(int rank){
    if (rank == 1) return Colors.yellowAccent;
    if (rank == 2) return Colors.blueGrey;
    if (rank == 3) return Colors.brown[400]!;
    if (rank <= 9) return Colors.blueAccent;
    if (rank <= 99) return Colors.greenAccent;
    return Colors.grey;
}