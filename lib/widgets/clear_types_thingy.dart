import 'package:flutter/material.dart' hide Badge;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/data_objects/minomuncher.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

class ClearTypesThingy extends StatelessWidget{
  final List<ClearsChartData> data;
  final double width;
  const ClearTypesThingy(this.data, this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
        child: Column(
          children: [
            SfCartesianChart(
              primaryXAxis: CategoryAxis(isVisible: data.length > 1),
              primaryYAxis: NumericAxis(minimum: 0, maximum: 100),
              title: ChartTitle(text: "Clear Types", textStyle: width > 768 ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleSmall),
              legend: data.length == 1 ? Legend(
                isVisible: true,
                position: LegendPosition.left,
                itemPadding: 2,
                legendItemBuilder: (legendText, series, point, seriesIndex) {
                  return Container(
                    height: 20,
                    width: 210,
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
                          Text("${data[0].clearName[seriesIndex]}:"),
                        ],
                        ),
                        Text("${intf.format(point.y)} (${percentage.format(point.y!/data[0].total)})")
                      ],
                    ),
                  );
                }, 
              ) : const Legend(),
              series: width > 580 ? <CartesianSeries>[
                for (int i = 0; i < data[0].byID.length; i++) StackedBar100Series<ClearsChartData, String>(
                  dataSource: data,
                  xValueMapper: (ClearsChartData data, _) => data.nick,
                  yValueMapper: (ClearsChartData data, _) => data.byID[i],
                  pointColorMapper: (ClearsChartData data, _) => lineClearsColors[i]
                )
              ] : <CartesianSeries>[
                for (int i = 0; i < data[0].byID.length; i++) StackedColumn100Series<ClearsChartData, String>(
                  dataSource: data,
                  xValueMapper: (ClearsChartData data, _) => data.nick,
                  yValueMapper: (ClearsChartData data, _) => data.byID[i],
                  pointColorMapper: (ClearsChartData data, _) => lineClearsColors[i]
                )
              ]
            ),
            if (data.length > 1) Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: FixedColumnWidth(120.0)
              },
              children: <TableRow>[
                TableRow(
                  children: <Widget>[
                    Container(),
                    for (ClearsChartData e in data) Text(e.nick, textAlign: TextAlign.end),
                  ],
                ),
                for (int i = 0; i < data[0].byID.length; i++) TableRow(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
                          child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: lineClearsColors[i])),
                        ),
                        Text("${data[0].clearName[i]}:")
                      ],
                    ),
                    for (ClearsChartData e in data) Text("${intf.format(e.byID[i])} (${percentage.format(e.byID[i]/e.total)})", textAlign: TextAlign.end)
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