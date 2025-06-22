import 'package:flutter/material.dart' hide Badge;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tetra_stats/data_objects/minomuncher.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

class KD{
  final String nickname;
  final DeathData kills;
  final DeathData deaths;
  const KD(this.nickname, this.kills, this.deaths);
}

class KillsDeathsThingy extends StatelessWidget{
  final List<KD> data;
  final double width;
  const KillsDeathsThingy(this.data, this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10.0,
              runSpacing: 10.0,
              runAlignment: WrapAlignment.start,
              children: [
                SfCartesianChart(
                  primaryXAxis: CategoryAxis(isVisible: data.length > 1),
                  primaryYAxis: NumericAxis(minimum: 0, maximum: 100),
                  title: ChartTitle(text: t.stats.kills, textStyle: width > 768 ? Theme.of(context).textTheme.titleSmall : Theme.of(context).textTheme.titleMedium),
                  legend: data.length == 1 ? Legend(
                    isVisible: true,
                    position: LegendPosition.left,
                    itemPadding: 2,
                    legendItemBuilder: (legendText, series, point, seriesIndex) {
                      return Container(
                        height: 20,
                        width: 160,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                            children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
                                  child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: lineClearsColors[seriesIndex])),
                                ),
                              Text("${killsLabels[seriesIndex]}:"),
                            ],
                            ),
                            Text("${intf.format(point.y)}")
                          ],
                        ),
                      );
                    }, 
                  ) : const Legend(),
                  series: <CartesianSeries>[
                    for (int i = 0; i < data[0].kills.values.length; i++) StackedColumn100Series<KD, String>(
                      dataSource: data,
                      xValueMapper: (KD data, _) => data.nickname,
                      yValueMapper: (KD data, _) => data.kills.values[i],
                      pointColorMapper: (KD data, _) => lineClearsColors[i]
                    )
                  ]
                ),
                SfCartesianChart(
                  primaryXAxis: CategoryAxis(isVisible: data.length > 1),
                  primaryYAxis: NumericAxis(minimum: 0, maximum: 100, opposedPosition: true,),
                  title: ChartTitle(text: t.stats.deaths, textStyle: width > 768 ? Theme.of(context).textTheme.titleSmall : Theme.of(context).textTheme.titleMedium),
                  legend: data.length == 1 ? Legend(
                    isVisible: true,
                    position: LegendPosition.right,
                    itemPadding: 2,
                    legendItemBuilder: (legendText, series, point, seriesIndex) {
                      return Container(
                        height: 20,
                        width: 160,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                            children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
                                  child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: lineClearsColors[seriesIndex])),
                                ),
                              Text("${killsLabels[seriesIndex]}:"),
                            ],
                            ),
                            Text("${intf.format(point.y)}")
                          ],
                        ),
                      );
                    }, 
                  ) : const Legend(),
                  series: <CartesianSeries>[
                    for (int i = 0; i < data[0].deaths.values.length; i++) StackedColumn100Series<KD, String>(
                      dataSource: data,
                      xValueMapper: (KD data, _) => data.nickname,
                      yValueMapper: (KD data, _) => data.deaths.values[i],
                      pointColorMapper: (KD data, _) => lineClearsColors[i]
                    )
                  ]
                ),
              ],
            ),
            if (data.length > 1) Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: FixedColumnWidth(125.0)
              },
              children: <TableRow>[
                TableRow(
                  children: <Widget>[
                    Container(),
                    for (KD e in data) Text(e.nickname, textAlign: TextAlign.end),
                  ],
                ),
                for (int i = 0; i < data[0].kills.values.length; i++) TableRow(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
                          child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: lineClearsColors[i])),
                        ),
                        Text("${killsLabels[i]}:")
                      ],
                    ),
                    for (KD e in data) Text("${intf.format(e.kills.values[i])}", textAlign: TextAlign.end)
                  ],
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}