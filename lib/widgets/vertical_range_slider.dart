import 'package:flutter/material.dart';

/// A vertical range slider with two independently draggable thumbs.
///
/// Oriented like a chart's Y axis: [min] is at the bottom, [max] at the top.
///
/// Uncontrolled: [values] is the initial value; subsequent changes are
/// reported through [onChanged].
class VerticalRangeSlider extends StatefulWidget {
  const VerticalRangeSlider({
    super.key,
    required this.values,
    this.min = 0.0,
    this.max = 1.0,
    required this.height,
    this.width = 24,
    this.onChanged,
  });

  /// The initial (start, end) values of the slider.
  final RangeValues values;

  /// The minimum value.
  final double min;

  /// The maximum value.
  final double max;

  /// The total height of the slider.
  final double height;

  /// The total width of the slider.
  final double width;

  /// Called whenever a thumb is dragged.
  final ValueChanged<RangeValues>? onChanged;

  @override
  State<VerticalRangeSlider> createState() => _VerticalRangeSliderState();
}

enum _Thumb { start, end }

class _VerticalRangeSliderState extends State<VerticalRangeSlider> {
  static const double _thumbSize = 20;

  late RangeValues _values = widget.values;
  final Map<int, _Thumb> _pointerThumbs = {};

  double get _trackLength => widget.height - _thumbSize;

  double _thumbCenterY(double value) {
    final range = widget.max - widget.min;
    if (range == 0) return widget.height / 2;
    final fraction = (value - widget.min) / range;
    // Inverted: min at the bottom, max at the top.
    return widget.height - (_thumbSize / 2 + fraction * _trackLength);
  }

  double _valueAt(double dy) {
    final range = widget.max - widget.min;
    if (range == 0) return widget.min;
    final fraction =
        ((widget.height - dy - _thumbSize / 2) / _trackLength).clamp(0.0, 1.0);
    return widget.min + fraction * range;
  }

  void _onPointerDown(PointerDownEvent event) {
    if (_pointerThumbs.length >= 2) return;
    final dy = event.localPosition.dy;
    final thumb = (dy - _thumbCenterY(_values.start)).abs() <=
            (dy - _thumbCenterY(_values.end)).abs()
        ? _Thumb.start
        : _Thumb.end;
    if (_pointerThumbs.values.contains(thumb)) return;
    _pointerThumbs[event.pointer] = thumb;
  }

  void _onPointerMove(PointerMoveEvent event) {
    final thumb = _pointerThumbs[event.pointer];
    if (thumb == null) return;
    final value = _valueAt(event.localPosition.dy);
    final clamped = switch (thumb) {
      _Thumb.start => value.clamp(widget.min, _values.end),
      _Thumb.end => value.clamp(_values.start, widget.max),
    };
    final current = thumb == _Thumb.start ? _values.start : _values.end;
    if (clamped == current) return;
    _values = switch (thumb) {
      _Thumb.start => RangeValues(clamped, _values.end),
      _Thumb.end => RangeValues(_values.start, clamped),
    };
    setState(() {});
    widget.onChanged?.call(_values);
  }

  void _releasePointer(int pointer) => _pointerThumbs.remove(pointer);

  @override
  void didUpdateWidget(VerticalRangeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.values != widget.values) {
      _values = widget.values;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: (event) => _releasePointer(event.pointer),
      onPointerCancel: (event) => _releasePointer(event.pointer),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: CustomPaint(
          painter: _VerticalRangeSliderPainter(
            values: _values,
            min: widget.min,
            max: widget.max,
            thumbSize: _thumbSize,
            activeColor: colorScheme.primary,
            inactiveColor: colorScheme.primary.withValues(alpha: 0.25),
          ),
        ),
      ),
    );
  }
}

class _VerticalRangeSliderPainter extends CustomPainter {
  const _VerticalRangeSliderPainter({
    required this.values,
    required this.min,
    required this.max,
    required this.thumbSize,
    required this.activeColor,
    required this.inactiveColor,
  });

  final RangeValues values;
  final double min;
  final double max;
  final double thumbSize;
  final Color activeColor;
  final Color inactiveColor;

  double _centerY(double value, double height) {
    final range = max - min;
    if (range == 0) return height / 2;
    // Inverted: min at the bottom, max at the top.
    return height -
        (thumbSize / 2 + (value - min) / range * (height - thumbSize));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final start = _centerY(values.start, size.height);
    final end = _centerY(values.end, size.height);

    final trackPaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4
      ..isAntiAlias = true;
    canvas.drawLine(
        Offset(centerX, 0), Offset(centerX, size.height), trackPaint);

    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4
      ..isAntiAlias = true;
    canvas.drawLine(Offset(centerX, start), Offset(centerX, end), activePaint);

    final thumbPaint = Paint()
      ..color = activeColor
      ..isAntiAlias = true;
    canvas.drawCircle(Offset(centerX, start), thumbSize / 2, thumbPaint);
    canvas.drawCircle(Offset(centerX, end), thumbSize / 2, thumbPaint);
  }

  @override
  bool shouldRepaint(_VerticalRangeSliderPainter old) {
    return old.values != values ||
        old.min != min ||
        old.max != max ||
        old.activeColor != activeColor ||
        old.inactiveColor != inactiveColor;
  }
}
