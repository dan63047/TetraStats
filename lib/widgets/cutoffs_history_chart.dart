import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:tetra_stats/data_objects/p1nkl0bst3r.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/widgets/future_error.dart';
import 'package:tetra_stats/widgets/vertical_range_slider.dart';

/// The Tetra League cutoffs history chart with custom zoom sliders:
/// a vertical [VerticalRangeSlider] drives the Y axis zoom, a horizontal
/// [RangeSlider] drives the X axis zoom.
///
/// The zoom state is owned by this widget, so dragging the sliders
/// rebuilds only this subtree and never refetches [future].
class CutoffsHistoryChart extends StatefulWidget {
  const CutoffsHistoryChart({
    super.key,
    required this.future,
    required this.yChart,
    required this.zoomPanBehavior,
    required this.tooltipBehavior,
    required this.onYAxisTitle,
  });

  /// The data source. Must be a stable instance: if it is recreated on
  /// every build, the chart refetches the data.
  final Future<List<Cutoffs>> future;

  /// The metric plotted on the Y axis.
  final Stats yChart;

  final ZoomPanBehavior zoomPanBehavior;
  final TooltipBehavior tooltipBehavior;

  /// Called with the short title of [yChart]; used by the parent's tooltip.
  final ValueChanged<String> onYAxisTitle;

  @override
  State<CutoffsHistoryChart> createState() => _CutoffsHistoryChartState();
}

class _CutoffsHistoryChartState extends State<CutoffsHistoryChart> {
  RangeValues _yRange = const RangeValues(0.0, 1.0);
  RangeValues _xRange = const RangeValues(0.0, 1.0);
  DateTimeAxisController? _xAxisController;
  NumericAxisController? _yAxisController;
  DateTime? _xMin;
  DateTime? _xMax;
  double? _yMin;
  double? _yMax;
  // Track the axes' visible ranges so the sliders stay in sync when the
  // user zooms/pans with the mouse wheel, pinch or selection zoom.
  late RangeController _xRangeController;
  late RangeController _yRangeController;

  @override
  void initState() {
    _xRangeController =
        RangeController(start: DateTime(1970, 1, 1), end: DateTime.now());
    _yRangeController = RangeController(start: 0.0, end: 25000.0);
    _xRangeController.addListener(_onXAxisRangeChanged);
    _yRangeController.addListener(_onYAxisRangeChanged);
    super.initState();
  }

  @override
  void dispose() {
    _xRangeController.removeListener(_onXAxisRangeChanged);
    _yRangeController.removeListener(_onYAxisRangeChanged);
    super.dispose();
  }

  void _onYRangeChanged(RangeValues values) {
    setState(() {
      _yRange = values;
      final yMin = _yMin;
      final yMax = _yMax;
      if (yMin == null || yMax == null) return;
      _yAxisController?.visibleMinimum = yMin + values.start * (yMax - yMin);
      _yAxisController?.visibleMaximum = yMin + values.end * (yMax - yMin);
    });
  }

  void _onXRangeChanged(RangeValues values) {
    setState(() {
      _xRange = values;
      final xMin = _xMin;
      final xMax = _xMax;
      if (xMin == null || xMax == null) return;
      final span = xMax.difference(xMin);
      _xAxisController?.visibleMinimum = xMin.add(
          Duration(milliseconds: (values.start * span.inMilliseconds).round()));
      _xAxisController?.visibleMaximum = xMin.add(
          Duration(milliseconds: (values.end * span.inMilliseconds).round()));
    });
  }

  // Keeps the sliders in sync with range changes triggered by the chart
  // itself (mouse wheel zoom, pinch, selection zoom, panning).
  //
  // The range controllers are updated during the chart's layout, which
  // happens while this widget is building, so defer the state update.
  void _onXAxisRangeChanged() {
    final start = _xRangeController.start;
    final end = _xRangeController.end;
    if (start is! DateTime || end is! DateTime) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _syncXRange(start, end);
    });
  }

  void _onYAxisRangeChanged() {
    final start = _yRangeController.start;
    final end = _yRangeController.end;
    if (start is! double || end is! double) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _syncYRange(start, end);
    });
  }

  void _syncYRange(double min, double max) {
    final yMin = _yMin;
    final yMax = _yMax;
    if (yMin == null || yMax == null) return;
    final span = yMax - yMin;
    if (span == 0) return;
    final values = RangeValues(((min - yMin) / span).clamp(0.0, 1.0),
        ((max - yMin) / span).clamp(0.0, 1.0));
    if (values.start == _yRange.start && values.end == _yRange.end) return;
    setState(() => _yRange = values);
  }

  void _syncXRange(DateTime min, DateTime max) {
    final xMin = _xMin;
    final xMax = _xMax;
    if (xMin == null || xMax == null) return;
    final span = xMax.difference(xMin).inMilliseconds;
    if (span == 0) return;
    final values = RangeValues(
        (min.difference(xMin).inMilliseconds / span).clamp(0.0, 1.0),
        (max.difference(xMin).inMilliseconds / span).clamp(0.0, 1.0));
    if (values.start == _xRange.start && values.end == _xRange.end) return;
    setState(() => _xRange = values);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cutoffs>>(
      future: widget.future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            _xRangeController.start = DateTime(1970, 1, 1);
            _xRangeController.end = DateTime.now();
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              widget.onYAxisTitle(chartsShortTitles[widget.yChart]!);
              final data = snapshot.data!;
              final xMin = data.first.ts;
              final xMax = data.last.ts;
              double yMin = double.infinity;
              double yMax = double.negativeInfinity;
              for (Cutoffs entry in data) {
                for (String rank in ranks) {
                  final value = switch (widget.yChart) {
                    Stats.glicko => entry.glicko[rank],
                    Stats.gxe => entry.gxe[rank],
                    _ => entry.tr[rank],
                  };
                  if (value != null) {
                    yMin = math.min(yMin, value);
                    yMax = math.max(yMax, value);
                  }
                }
              }
              if (yMin == double.infinity) {
                yMin = 0;
                yMax = 1;
              }
              final span = xMax.difference(xMin);
              final visXMin = xMin.add(Duration(
                  milliseconds: (_xRange.start * span.inMilliseconds).round()));
              final visXMax = xMin.add(Duration(
                  milliseconds: (_xRange.end * span.inMilliseconds).round()));
              final visYMin = yMin + _yRange.start * (yMax - yMin);
              final visYMax = yMin + _yRange.end * (yMax - yMin);
              _xMin = xMin;
              _xMax = xMax;
              _yMin = yMin;
              _yMax = yMax;
              return LayoutBuilder(
                builder: (context, constraints) {
                  final height = constraints.maxHeight;
                  return Row(
                    children: [
                      VerticalRangeSlider(
                        values: _yRange,
                        onChanged: _onYRangeChanged,
                        height: height,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: SfCartesianChart(
                                tooltipBehavior: widget.tooltipBehavior,
                                zoomPanBehavior: widget.zoomPanBehavior,
                                primaryXAxis: DateTimeAxis(
                                  minimum: xMin,
                                  maximum: xMax,
                                  initialVisibleMinimum: visXMin,
                                  initialVisibleMaximum: visXMax,
                                  onRendererCreated: (controller) =>
                                      _xAxisController = controller,
                                  rangeController: _xRangeController,
                                ),
                                primaryYAxis: NumericAxis(
                                  minimum: yMin,
                                  maximum: yMax,
                                  initialVisibleMinimum: visYMin,
                                  initialVisibleMaximum: visYMax,
                                  onRendererCreated: (controller) =>
                                      _yAxisController = controller,
                                  rangeController: _yRangeController,
                                ),
                                margin: const EdgeInsets.all(0),
                                series: <CartesianSeries>[
                                  for (String rank in ranks)
                                    SplineSeries<Cutoffs, DateTime>(
                                        enableTooltip: true,
                                        dataSource: data,
                                        animationDuration: 0,
                                        //opacity: 0.5,
                                        xValueMapper: (Cutoffs entry, _) =>
                                            entry.ts,
                                        yValueMapper: (Cutoffs entry, _) =>
                                            switch (widget.yChart) {
                                              Stats.glicko =>
                                                entry.glicko[rank],
                                              Stats.gxe => entry.gxe[rank],
                                              _ => entry.tr[rank]
                                            },
                                        color: rankColors[rank]!)
                                ],
                              ),
                            ),
                            RangeSlider(
                              values: _xRange,
                              onChanged: _onXRangeChanged,
                            )
                          ],
                        ),
                      )
                    ],
                  );
                },
              );
            } else {
              return FutureError(snapshot);
            }
        }
      },
    );
  }
}
