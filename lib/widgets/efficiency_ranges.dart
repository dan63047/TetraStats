import 'package:flutter/material.dart' hide Badge;
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

class Eff{
  final String nickname;
  final double iEfficiency;
  final double tEfficiency;
  final double allspinEfficiency;
  Eff(this.nickname, this.iEfficiency, this.tEfficiency, this.allspinEfficiency);
  get p1 => iEfficiency;
  get p2 => iEfficiency+tEfficiency;
  get p3 => iEfficiency+tEfficiency+allspinEfficiency;
}

class EffThingy extends StatelessWidget{
  final List<Eff> data;
  final bool wide;
  const EffThingy(this.data, this.wide, {super.key});

  @override
  Widget build(BuildContext context) {
    int longestNicknameLength = 0;
    for (Eff e in data) if (e.nickname.length > longestNicknameLength) longestNicknameLength = e.nickname.length;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(t.stats.efficiency, style: wide ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleSmall),
              SizedBox(height: 8.0),
              for (Eff e in data) SfLinearGauge(
                minimum: 0,
                maximum: e.p3,
                interval: .25,
                markerPointers: data.length == 1 ? null : [
                  LinearWidgetPointer(value: 0, child: Container(width: longestNicknameLength*8, child: Text(e.nickname)), markerAlignment: LinearMarkerAlignment.end)
                ],
                ranges: [
                  LinearGaugeRange(
                    startValue: 0,
                    endValue: e.p1,
                    startWidth: 25,
                    endWidth: 25,
                    color: Colors.blue.shade300,
                    position: LinearElementPosition.cross
                  ),
                  LinearGaugeRange(
                    startValue: e.p1,
                    endValue: e.p2,
                    startWidth: 25,
                    endWidth: 25,
                    color: Colors.purple.shade300,
                    position: LinearElementPosition.cross
                  ),
                  LinearGaugeRange(
                    startValue: e.p2,
                    endValue: e.p3,
                    startWidth: 25,
                    endWidth: 25,
                    color: Colors.green.shade300,
                    position: LinearElementPosition.cross
                  )
                ],
                showTicks: true,
                showLabels: false
              ),
              SizedBox(height: 8.0),
              if (data.length == 1) Wrap(
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 20,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
                        child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.blue.shade300)),
                      ),
                      Text("${t.stats.quadEfficiency.full}: ${percentage.format(data[0].iEfficiency)}")
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
                        child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.purple.shade300)),
                      ),
                      Text("${t.stats.tspinEfficiency.full}: ${percentage.format(data[0].tEfficiency)}")
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
                        child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.green.shade300)),
                      ),
                      Text("${t.stats.allspinEfficiency.full}: ${percentage.format(data[0].allspinEfficiency)}")
                    ],
                  ),
                ],
              )
              else Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: FixedColumnWidth(120.0)
                },
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      Container(),
                      for (Eff e in data) Text(e.nickname, textAlign: TextAlign.end),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
                            child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.blue.shade300)),
                          ),
                          Text("${t.stats.quadEfficiency.full}:")
                        ],
                      ),
                      for (Eff e in data) Text(percentage.format(e.iEfficiency), textAlign: TextAlign.end)
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
                            child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.purple.shade300)),
                          ),
                          Text("${t.stats.tspinEfficiency.full}:")
                        ],
                      ),
                      for (Eff e in data) Text(percentage.format(e.tEfficiency), textAlign: TextAlign.end)
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
                            child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.green.shade300)),
                          ),
                          Text("${t.stats.allspinEfficiency.full}:")
                        ],
                      ),
                      for (Eff e in data) Text(percentage.format(e.allspinEfficiency), textAlign: TextAlign.end)
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}