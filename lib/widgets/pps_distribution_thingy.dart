import 'package:flutter/material.dart' hide Badge;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tetra_stats/data_objects/minomuncher.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

class Point{
  final String nickname;
  final int x;
  final double y;
  const Point(this.nickname, this.x, this.y);
}

class PPSDistributionThingy extends StatelessWidget{
  final List<List<double>> data;
  final List<String> nicknames;
  final double width;
  const PPSDistributionThingy(this.data, this.nicknames, this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    List<List<Point>> finalData = [for (int i = 0; i < data.length; i++) [for (int j = 0; j < data[i].length; j++)Point(nicknames[i], j, data[i][j])]];
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
        child: SfCartesianChart(
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(numberFormat: percentage),
          title: ChartTitle(text: "PPS distribution", textStyle: width > 768 ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleSmall),
          series: <CartesianSeries>[
            // Renders spline chart
            for (List<Point> e in finalData) SplineSeries<Point, double>(
                dataSource: e,
                xValueMapper: (Point data, _) => data.x/10,
                yValueMapper: (Point data, _) => data.y,
                dataLabelMapper: (Point data, _) => data.nickname,
            )
          ]
        )
      )
    );
  }
}