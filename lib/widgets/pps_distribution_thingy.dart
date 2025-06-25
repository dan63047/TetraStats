import 'package:flutter/material.dart' hide Badge;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/gen/strings.g.dart';
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
          primaryXAxis: NumericAxis(majorGridLines: MajorGridLines(color: Colors.grey.shade800)),
          primaryYAxis: NumericAxis(numberFormat: percentage, majorGridLines: MajorGridLines(color: Colors.grey.shade800)),
          palette: lineClearsColors,
          tooltipBehavior: TooltipBehavior(
            enable: true,
            color: Colors.black,
            borderColor: Colors.white,
            animationDuration: 0,
            builder: (dynamic data, dynamic point, dynamic series,
              int pointIndex, int seriesIndex) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${percentage.format(data.y)}",
                    style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 20),
                  ),
                );
            }
          ),
          title: ChartTitle(text: t.stats.ppsDistribution, textStyle: width > 768 ? Theme.of(context).textTheme.titleSmall : Theme.of(context).textTheme.titleMedium),
          series: <CartesianSeries>[
            // Renders spline chart
            for (int i = 0; i < finalData.length; i++) SplineSeries<Point, double>(
                dataSource: finalData[i],
                xValueMapper: (Point data, _) => data.x/10,
                yValueMapper: (Point data, _) => data.y,
                dataLabelMapper: (Point data, _) => data.nickname,
                name: nicknames[i],
            )
          ],
          legend: Legend(isVisible: data.length > 1, position: LegendPosition.top),
        )
      )
    );
  }
}