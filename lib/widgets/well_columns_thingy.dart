import 'package:flutter/material.dart' hide Badge;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/data_objects/minomuncher.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

class WellColumnsThingy extends StatelessWidget{
  final List<List<WellsData>> data;
  final List<String> nicknames;
  final double width;
  const WellColumnsThingy(this.data, this.nicknames, this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return 	Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
        child: Column(
          children: [
            SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(numberFormat: percentage),
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
                        "${percentage.format(data.value)}",
                        style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 20),
                      ),
                    );
                }
              ),
              title: ChartTitle(text: "Well Column Distribution", textStyle: width > 768.0 ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleSmall),
              series: <CartesianSeries>[
                for (int i = 0; i < data.length; i++) ColumnSeries<WellsData, int>(
                    dataSource: data[i],
                    xValueMapper: (WellsData data, _) => data.well,
                    yValueMapper: (WellsData data, _) => data.value,
                    name: nicknames[i],
                )
              ],
              legend: Legend(isVisible: data.length > 1, position: LegendPosition.top),
            ),
          ],
        ),
      )
    );
  }
}