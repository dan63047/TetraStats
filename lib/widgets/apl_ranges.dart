import 'package:flutter/material.dart' hide Badge;
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

class Apl{
  final String nickname;
  final double upstackAPL;
  final double downstackAPL;
  final double cheeseAPL;
  Apl(this.nickname, this.upstackAPL, this.downstackAPL, this.cheeseAPL);
}

class AplThingy extends StatelessWidget{
  final List<Apl> data;
  final bool wide;
  const AplThingy(this.data, this.wide, {super.key});

  @override
  Widget build(BuildContext context) {
    List<List<LinearGaugeRange>> aplRanges = [];
    int longestNicknameLength = 0;
    for (Apl e in data){
      List<LinearGaugeRange> apl = [
        LinearGaugeRange(
          startValue: 0,
          endValue: e.cheeseAPL,
          startWidth: 25,
          endWidth: 25,
          color: Colors.yellow.shade300,
          position: LinearElementPosition.cross
        ),
        LinearGaugeRange(
          startValue: 0,
          endValue: e.downstackAPL,
          startWidth: 25,
          endWidth: 25,
          color: Colors.red.shade300,
          position: LinearElementPosition.cross
        ),
        LinearGaugeRange(
          startValue: 0,
          endValue: e.upstackAPL,
          startWidth: 25,
          endWidth: 25,
          color: Colors.green.shade300,
          position: LinearElementPosition.cross
        )
      ];
      apl.sort((a, b) => a.endValue > b.endValue ? -1 : 1);
      aplRanges.add(apl);
      if (e.nickname.length > longestNicknameLength) longestNicknameLength = e.nickname.length;
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Attack Per Line", style: wide ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleSmall),
              SizedBox(height: 8.0),
              for (int i = 0; i < data.length; i++) SfLinearGauge(
                minimum: 0,
                maximum: 2,
                interval: .25, 
                ranges: aplRanges[i],
                showTicks: true,
                showLabels: false,
                markerPointers: data.length == 1 ? null : [
                  LinearWidgetPointer(value: 0, child: Container(width: longestNicknameLength*8, child: Text(data[i].nickname)), markerAlignment: LinearMarkerAlignment.end)
                ],
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
                        child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.green.shade300)),
                      ),
                      Text("Upstack: ${f3.format(data[0].upstackAPL)} APL")
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
                        child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.red.shade300)),
                      ),
                      Text("Downstack: ${f3.format(data[0].downstackAPL)} APL")
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
                        child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.yellow.shade300)),
                      ),
                      Text("Cheese: ${f3.format(data[0].cheeseAPL)} APL")
                    ],
                  ),
                ],
              )
              else Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: FixedColumnWidth(85.0)
                },
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      Container(),
                      for (Apl e in data) Text(e.nickname, textAlign: TextAlign.end),
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
                          Text("Upstack:")
                        ],
                      ),
                      for (Apl e in data) Text("${f3.format(e.upstackAPL)} APL", textAlign: TextAlign.end)
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
                            child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.red.shade300)),
                          ),
                          Text("Downstack:")
                        ],
                      ),
                      for (Apl e in data) Text("${f3.format(e.downstackAPL)} APL", textAlign: TextAlign.end)
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
                            child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.yellow.shade300)),
                          ),
                          Text("Cheese:")
                        ],
                      ),
                      for (Apl e in data) Text("${f3.format(e.cheeseAPL)} APL", textAlign: TextAlign.end)
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