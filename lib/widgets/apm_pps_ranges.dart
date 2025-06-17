import 'package:flutter/material.dart' hide Badge;
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

class ApmPps{
  final String nickname;
  final double openerAPM;
  final double APM;
  final double midgameAPM;
  final double openerPPS;
  final double PPS;
  final double midgamePPS;
  ApmPps(this.nickname, this.openerAPM, this.APM, this.midgameAPM, this.openerPPS, this.PPS, this.midgamePPS);
}

class ApmPpsThingy extends StatelessWidget{
  final List<ApmPps> data;
  const ApmPpsThingy(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    List<List<LinearGaugeRange>> apmRanges = [];
    List<List<LinearGaugeRange>> ppsRanges = [];
    int longestNicknameLength = 0;
    for (ApmPps e in data){
      List<LinearGaugeRange> apm = [
        LinearGaugeRange(
          startValue: 0,
          endValue: e.openerAPM,
          startWidth: 25,
          endWidth: 25,
          color: Colors.yellow.shade300,
          position: LinearElementPosition.cross
        ),
        LinearGaugeRange(
          startValue: 0,
          endValue: e.APM,
          startWidth: 25,
          endWidth: 25,
          color: Colors.red.shade300,
          position: LinearElementPosition.cross
        ),
        LinearGaugeRange(
          startValue: 0,
          endValue: e.midgameAPM,
          startWidth: 25,
          endWidth: 25,
          color: Colors.green.shade300,
          position: LinearElementPosition.cross
        )
      ];
      List<LinearGaugeRange> pps = [
        LinearGaugeRange(
          startValue: 0,
          endValue: e.openerPPS,
          startWidth: 25,
          endWidth: 25,
          color: Colors.yellow.shade300,
          position: LinearElementPosition.cross
        ),
        LinearGaugeRange(
          startValue: 0,
          endValue: e.PPS,
          startWidth: 25,
          endWidth: 25,
          color: Colors.red.shade300,
          position: LinearElementPosition.cross
        ),
        LinearGaugeRange(
          startValue: 0,
          endValue: e.midgamePPS,
          startWidth: 25,
          endWidth: 25,
          color: Colors.green.shade300,
          position: LinearElementPosition.cross
        )
      ];
      apm.sort((a, b) => a.endValue > b.endValue ? -1 : 1);
      pps.sort((a, b) => a.endValue > b.endValue ? -1 : 1);
      apmRanges.add(apm);
      ppsRanges.add(pps);
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
              for (int i = 0; i < data.length; i++) SfLinearGauge(
                minimum: 0,
                maximum: 300,
                interval: 25, 
                ranges: apmRanges[i],
                markerPointers: [
                  LinearWidgetPointer(value: 0, child: Container(width: data.length == 1 ? 36.0 : 36.0 + longestNicknameLength*8, child: Text(data.length == 1 ? "APM" : "${data[i].nickname} APM")), markerAlignment: LinearMarkerAlignment.end)
                ],
                isMirrored: false,
                showTicks: true,
                showLabels: false
              ),
              SizedBox(height: 8.0),
              for (int i = 0; i < data.length; i++) SfLinearGauge(
                minimum: 0,
                maximum: 4.00,
                interval: .25, 
                ranges: ppsRanges[i],
                markerPointers: [
                  LinearWidgetPointer(value: 0, child: Container(width: data.length == 1 ? 36.0 : 36.0 + longestNicknameLength*8, child: Text(data.length == 1 ? "PPS" : "${data[i].nickname} PPS")), markerAlignment: LinearMarkerAlignment.end)
                ],
                isMirrored: false,
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
                        child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.green.shade300)),
                      ),
                      Text("${t.stats.midgame}: ${f2.format(data[0].midgameAPM)} APM, ${f2.format(data[0].midgamePPS)} PPS")
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
                        child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.red.shade300)),
                      ),
                      Text("${t.stats.overall}: ${f2.format(data[0].APM)} APM, ${f2.format(data[0].PPS)} PPS")
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
                        child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.yellow.shade300)),
                      ),
                      Text("${t.stats.opener.full}: ${f2.format(data[0].openerAPM)} APM, ${f2.format(data[0].openerPPS)} PPS")
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
                      for (ApmPps e in data) Text(e.nickname, textAlign: TextAlign.end),
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
                          Text("${t.stats.midgame}:")
                        ],
                      ),
                      for (ApmPps e in data) Text("${f2.format(e.midgameAPM)} APM, ${f2.format(e.midgamePPS)} PPS", textAlign: TextAlign.end)
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
                          Text("${t.stats.overall}:")
                        ],
                      ),
                      for (ApmPps e in data) Text("${f2.format(e.APM)} APM, ${f2.format(e.PPS)} PPS", textAlign: TextAlign.end)
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
                          Text("${t.stats.opener.full}:")
                        ],
                      ),
                      for (ApmPps e in data) Text("${f2.format(e.openerAPM)} APM, ${f2.format(e.openerPPS)} PPS", textAlign: TextAlign.end)
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