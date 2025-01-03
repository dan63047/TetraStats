// ignore_for_file: unused_field, unused_local_variable, invalid_use_of_visible_for_testing_member, implementation_imports, overridden_fields

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_painter.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_renderer.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:tetra_stats/data_objects/nerd_stats.dart';
import 'package:tetra_stats/data_objects/playstyle.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/main.dart' show prefs;
import 'package:flutter/material.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

class MyRadarChartPainter extends RadarChartPainter{
  MyRadarChartPainter() : super() {
    _backgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    _borderPaint = Paint()..style = PaintingStyle.stroke;

    _gridPaint = Paint()..style = PaintingStyle.stroke;

    _tickPaint = Paint()..style = PaintingStyle.stroke;

    _graphPaint = Paint();
    _graphBorderPaint = Paint();
    _graphPointPaint = Paint();
    _ticksTextPaint = TextPainter();
    _titleTextPaint = TextPainter();
    sheetbotRadarGraphs = prefs.getBool("sheetbotRadarGraphs")??false;
  }
  late Paint _borderPaint;
  late Paint _backgroundPaint;
  late Paint _gridPaint;
  late Paint _tickPaint;
  late Paint _graphPaint;
  late Paint _graphBorderPaint;
  late Paint _graphPointPaint;

  late TextPainter _ticksTextPaint;
  late TextPainter _titleTextPaint;

  late bool sheetbotRadarGraphs;

  @override
  double getChartCenterValue(RadarChartData data) {
    final dataSetMaxValue = sheetbotRadarGraphs ? max(data.maxEntry.value, data.minEntry.value.abs()) : data.maxEntry.value;
    final dataSetMinValue = data.minEntry.value;
    final tickSpace = getSpaceBetweenTicks(data);
    final centerValue = (dataSetMinValue < 0 && sheetbotRadarGraphs) ? 0.0 : dataSetMinValue;

    return dataSetMaxValue == dataSetMinValue
        ? getDefaultChartCenterValue()
        : centerValue;
  }

  @override
  double getSpaceBetweenTicks(RadarChartData data) {
    final defaultCenterValue = getDefaultChartCenterValue();
    final dataSetMaxValue = sheetbotRadarGraphs ? max(data.maxEntry.value, data.minEntry.value.abs()) : data.maxEntry.value;
    final dataSetMinValue = (data.minEntry.value < 0 && sheetbotRadarGraphs) ? 0.0 : data.minEntry.value;
    final tickSpace = sheetbotRadarGraphs ? dataSetMaxValue / data.tickCount : (dataSetMaxValue - dataSetMinValue) / data.tickCount;
    final defaultTickSpace =
        (dataSetMaxValue - defaultCenterValue) / (data.tickCount + 1);

    return dataSetMaxValue == dataSetMinValue ? defaultTickSpace : tickSpace;
  }

  @override
  double getScaledPoint(RadarEntry point, double radius, RadarChartData data) {
    final centerValue = getChartCenterValue(data);
    final distanceFromPointToCenter = point.value - centerValue;
    final distanceFromMaxToCenter = max(data.maxEntry.value, data.minEntry.value.abs()) - centerValue;

    if (distanceFromMaxToCenter == 0) {
      return radius * distanceFromPointToCenter / 0.001;
    }

    return radius * distanceFromPointToCenter / distanceFromMaxToCenter;
  }

  @override
  double getFirstTickValue(RadarChartData data) {
    final defaultCenterValue = getDefaultChartCenterValue();
    final dataSetMaxValue = sheetbotRadarGraphs ? max(data.maxEntry.value, data.minEntry.value.abs()) : data.maxEntry.value;
    final dataSetMinValue = (data.minEntry.value < 0 && sheetbotRadarGraphs) ? 0.0 : data.minEntry.value;

    return dataSetMaxValue == dataSetMinValue
        ? (dataSetMaxValue - defaultCenterValue) / (data.tickCount + 1) +
            defaultCenterValue
        : dataSetMinValue;
  }

  @override
  void drawTicks(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    PaintHolder<RadarChartData> holder,
  ) {
    final data = holder.data;
    final size = canvasWrapper.size;

    final centerX = radarCenterX(size);
    final centerY = radarCenterY(size);
    final centerOffset = Offset(centerX, centerY);

    /// controls Radar chart size
    final radius = radarRadius(size);

    _backgroundPaint.color = data.radarBackgroundColor;

    _borderPaint
      ..color = data.radarBorderData.color
      ..strokeWidth = data.radarBorderData.width;

    if (data.radarShape == RadarShape.circle) {
      /// draw radar background
      canvasWrapper
        ..drawCircle(centerOffset, radius, _backgroundPaint)

        /// draw radar border
        ..drawCircle(centerOffset, radius, _borderPaint);
    } else {
      final path =
          _generatePolygonPath(centerX, centerY, radius, data.titleCount);

      /// draw radar background
      canvasWrapper
        ..drawPath(path, _backgroundPaint)

        /// draw radar border
        ..drawPath(path, _borderPaint);
    }

    final tickSpace = getSpaceBetweenTicks(data);
    final ticks = <double>[];
    var tickValue = getFirstTickValue(data);

    for (var i = 0; i <= data.tickCount; i++) {
      ticks.add(tickValue);
      tickValue += tickSpace;
    }

    final tickDistance = radius / (ticks.length-1);

    _tickPaint
      ..color = data.tickBorderData.color
      ..strokeWidth = data.tickBorderData.width;

    /// draw radar ticks
    ticks.sublist(1, ticks.length).asMap().forEach(
      (index, tick) {
        final tickRadius = tickDistance * (index + 1);
        if (data.radarShape == RadarShape.circle) {
          canvasWrapper.drawCircle(centerOffset, tickRadius, _tickPaint);
        } else {
          canvasWrapper.drawPath(
            _generatePolygonPath(centerX, centerY, tickRadius, data.titleCount),
            _tickPaint,
          );
        }

        // _ticksTextPaint
        //   ..text = TextSpan(
        //     text: percentage.format(tick),
        //     style: Utils().getThemeAwareTextStyle(context, data.ticksTextStyle),
        //   )
        //   ..textDirection = TextDirection.ltr
        //   ..layout(maxWidth: size.width);
        // canvasWrapper.drawText(
        //   _ticksTextPaint,
        //   Offset(centerX + 5, centerY - tickRadius - _ticksTextPaint.height/2),
        // );
      },
    );
  }

  Path _generatePolygonPath(
    double centerX,
    double centerY,
    double radius,
    int count,
  ) {
    final path = Path()..moveTo(centerX, centerY - radius);
    final angle = (2 * pi) / count;
    for (var index = 0; index < count; index++) {
      final xAngle = cos(angle * index - pi / 2);
      final yAngle = sin(angle * index - pi / 2);
      path.lineTo(centerX + radius * xAngle, centerY + radius * yAngle);
    }
    path.lineTo(centerX, centerY - radius);
    return path;
  }
}

class MyRadarChartLeaf extends RadarChartLeaf{
  const MyRadarChartLeaf({super.key, required super.data, required super.targetData});

  @override
  RenderRadarChart createRenderObject(BuildContext context) => MyRenderRadarChart(
    context,
    data,
    targetData,
    MediaQuery.of(context).textScaler,
  );
}

class MyRenderRadarChart extends RenderRadarChart{
  MyRenderRadarChart(super.context, super.data, super.targetData, super.textScaler);

  @override
  RadarChartPainter painter = MyRadarChartPainter();
}

class MyRadarChart extends ImplicitlyAnimatedWidget {
  const MyRadarChart(
    this.data, {
    super.key,
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
    Curve swapAnimationCurve = Curves.linear,
  }) : super(
          duration: swapAnimationDuration,
          curve: swapAnimationCurve,
        );

  /// Determines how the [RadarChart] should be look like.
  final RadarChartData data;

  @override
  RadarChartState createState() => RadarChartState();
}

class RadarChartState extends AnimatedWidgetBaseState<MyRadarChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [RadarChartData] to the new one.
  RadarChartDataTween? _radarChartDataTween;

  @override
  Widget build(BuildContext context) {
    final showingData = _getDate();

    return MyRadarChartLeaf(
      data: _radarChartDataTween!.evaluate(animation),
      targetData: showingData,
    );
  }

  RadarChartData _getDate() {
    return widget.data;
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _radarChartDataTween = visitor(
      _radarChartDataTween,
      widget.data,
      (dynamic value) =>
          RadarChartDataTween(begin: value as RadarChartData, end: widget.data),
    ) as RadarChartDataTween?;
  }
}

class Graphs extends StatelessWidget{

  const Graphs(
    this.apm,
    this.pps,
    this.vs,
    this.nerdStats,
    this.playstyle, {super.key}
  );

  final double apm;
  final double pps;
  final double vs;
  final NerdStats nerdStats;
  final Playstyle playstyle;

  @override
  Widget build(BuildContext context) {
    double attack = apm / 60 * 0.4;
    double speed = pps / 3.75;
    double defense = nerdStats.dss * 1.15;
    double cheese = nerdStats.cheese / 110;
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Center(
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            spacing: 25,
            crossAxisAlignment: WrapCrossAlignment.start,
            clipBehavior: Clip.hardEdge,
            children: [
              if (true) Padding( // vs graph
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
                child: SizedBox(
                  height: 310,
                  width: 310,
                  child: MyRadarChart(
                    RadarChartData(
                      radarShape: RadarShape.circle,
                      tickCount: 4,
                      radarBackgroundColor: Colors.black.withAlpha(170),
                      radarBorderData: const BorderSide(color: Colors.white24, width: 1),
                      gridBorderData: const BorderSide(color: Colors.white24, width: 1),
                      tickBorderData: const BorderSide(color: Colors.white24, width: 1),
                      getTitle: (index, angle) {
                        switch (index) {
                          case 0:
                            return RadarChartTitle(text: t.stats.apm.short, angle: angle, positionPercentageOffset: 0.05);
                          case 1:
                            return RadarChartTitle(text: t.stats.pps.short, angle: angle, positionPercentageOffset: 0.05);
                          case 2:
                            return RadarChartTitle(text: t.stats.vs.short, angle: angle, positionPercentageOffset: 0.05);
                          case 3:
                            return RadarChartTitle(text: t.stats.app.short, angle: angle + 180, positionPercentageOffset: 0.05);
                          case 4:
                            return RadarChartTitle(text: t.stats.dss.short, angle: angle + 180, positionPercentageOffset: 0.05);
                          case 5:
                            return RadarChartTitle(text: t.stats.dsp.short, angle: angle + 180, positionPercentageOffset: 0.05);
                          case 6:
                            return RadarChartTitle(text: t.stats.appdsp.short, angle: angle + 180, positionPercentageOffset: 0.05);
                          case 7:
                            return RadarChartTitle(text: t.stats.vsapm.short, angle: angle + 180, positionPercentageOffset: 0.05);
                          case 8:
                            return RadarChartTitle(text: t.stats.cheese.short, angle: angle, positionPercentageOffset: 0.05);
                          case 9:
                            return RadarChartTitle(text: t.stats.gbe.short, angle: angle, positionPercentageOffset: 0.05);
                          default:
                            return const RadarChartTitle(text: '');
                        }
                      },
                      dataSets: [
                        RadarDataSet(
                          fillColor: Theme.of(context).colorScheme.primary.withAlpha(170),
                          borderColor: Theme.of(context).colorScheme.primary,
                          dataEntries: [
                            RadarEntry(value: apm * apmWeight),
                            RadarEntry(value: pps * ppsWeight),
                            RadarEntry(value: vs * vsWeight),
                            RadarEntry(value: nerdStats.app * appWeight),
                            RadarEntry(value: nerdStats.dss * dssWeight),
                            RadarEntry(value: nerdStats.dsp * dspWeight),
                            RadarEntry(value: nerdStats.appdsp * appdspWeight),
                            RadarEntry(value: nerdStats.vsapm * vsapmWeight),
                            RadarEntry(value: nerdStats.cheese * cheeseWeight),
                            RadarEntry(value: nerdStats.gbe * gbeWeight),
                          ],
                        ),
                        RadarDataSet(
                          fillColor: Colors.transparent,
                          borderColor: Colors.transparent,
                          dataEntries: [
                            const RadarEntry(value: 0),
                            const RadarEntry(value: 180),
                            const RadarEntry(value: 0),
                            const RadarEntry(value: 0),
                            const RadarEntry(value: 0),
                            const RadarEntry(value: 0),
                            const RadarEntry(value: 0),
                            const RadarEntry(value: 0),
                            const RadarEntry(value: 0),
                            const RadarEntry(value: 0),
                          ],
                        )
                      ],
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 150), // Optional
                    swapAnimationCurve: Curves.linear, // Optional
                  ),
                ),
              ),
              Padding( // psq graph
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
                child: SizedBox(
                  height: 310,
                  width: 310,
                  child: MyRadarChart(
                    RadarChartData(
                      radarShape: RadarShape.circle,
                      tickCount: 4,
                      radarBackgroundColor: Colors.black.withAlpha(170),
                      radarBorderData: const BorderSide(color: Colors.white24, width: 1),
                      gridBorderData: const BorderSide(color: Colors.white24, width: 1),
                      tickBorderData: const BorderSide(color: Colors.white24, width: 1),
                      titleTextStyle: const TextStyle(height: 1.1),
                      radarTouchData: RadarTouchData(),
                      getTitle: (index, angle) {
                        switch (index) {
                          case 0:
                            return RadarChartTitle(text: '${t.stats.opener.short}\n${percentage.format(playstyle.opener)}', angle: 0, positionPercentageOffset: 0.05);
                          case 1:
                            return RadarChartTitle(text: '${t.stats.stride.short}\n${percentage.format(playstyle.stride)}', angle: 0, positionPercentageOffset: 0.05);
                          case 2:
                            return RadarChartTitle(text: '${t.stats.infds.short}\n${percentage.format(playstyle.infds)}', angle: angle + 180, positionPercentageOffset: 0.05);
                          case 3:
                            return RadarChartTitle(text: '${t.stats.plonk.short}\n${percentage.format(playstyle.plonk)}', angle: 0, positionPercentageOffset: 0.05);
                          default:
                            return const RadarChartTitle(text: '');
                        }
                      },
                      dataSets: [
                        RadarDataSet(
                          fillColor: Theme.of(context).colorScheme.primary.withAlpha(170),
                          borderColor: Theme.of(context).colorScheme.primary,
                          dataEntries: [
                            RadarEntry(value: playstyle.opener),
                            RadarEntry(value: playstyle.stride),
                            RadarEntry(value: playstyle.infds),
                            RadarEntry(value: playstyle.plonk),
                          ],
                        ),
                        RadarDataSet(
                          fillColor: Colors.transparent,
                          borderColor: Colors.transparent,
                          dataEntries: [
                            const RadarEntry(value: 0),
                            const RadarEntry(value: 1),
                            const RadarEntry(value: 0),
                            const RadarEntry(value: 0),
                          ],
                        )
                      ],
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 150), // Optional
                    swapAnimationCurve: Curves.linear, // Optional
                  ),
                ),
              ),
              Padding( // sq graph
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
                child: SizedBox(
                  height: 310,
                  width: 310,
                  child: MyRadarChart(
                    RadarChartData(
                      radarShape: RadarShape.circle,
                      tickCount: 4,
                      radarBackgroundColor: Colors.black.withAlpha(170),
                      radarBorderData: const BorderSide(color: Colors.white24, width: 1),
                      gridBorderData: const BorderSide(color: Colors.white24, width: 1),
                      tickBorderData: const BorderSide(color: Colors.white24, width: 1),
                      titleTextStyle: const TextStyle(height: 1.1),
                      radarTouchData: RadarTouchData(),
                      getTitle: (index, angle) {
                        switch (index) {
                          case 0:
                            return RadarChartTitle(text: '${t.stats.graphs.attack}\n${f2.format(apm)} APM', angle: 0, positionPercentageOffset: 0.05);
                          case 1:
                            return RadarChartTitle(text: '${t.stats.graphs.speed}\n${f2.format(pps)} PPS', angle: 0, positionPercentageOffset: 0.05);
                          case 2:
                            return RadarChartTitle(text: '${t.stats.graphs.defense}\n${f2.format(nerdStats.dss)} DS/S', angle: angle + 180, positionPercentageOffset: 0.05);
                          case 3:
                            return RadarChartTitle(text: '${t.stats.graphs.cheese}\n${f3.format(nerdStats.cheese)}', angle: 0, positionPercentageOffset: 0.05);
                          default:
                            return const RadarChartTitle(text: '');
                        }
                      },
                      dataSets: [
                        RadarDataSet(
                          fillColor: Theme.of(context).colorScheme.primary.withAlpha(170),
                          borderColor: Theme.of(context).colorScheme.primary,
                          dataEntries: [
                            RadarEntry(value: attack),
                            RadarEntry(value: speed),
                            RadarEntry(value: defense),
                            RadarEntry(value: cheese),
                          ],
                        ),
                        RadarDataSet(
                          fillColor: Colors.transparent,
                          borderColor: Colors.transparent,
                          dataEntries: [
                            const RadarEntry(value: 0),
                            const RadarEntry(value: 1.2),
                            const RadarEntry(value: 0),
                            const RadarEntry(value: 0),
                          ],
                        )
                      ],
                    )
                  )
                )
              )
            ],
          ),
        ),
      ),
    );
  }

}