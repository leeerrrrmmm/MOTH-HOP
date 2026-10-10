import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moth_hop/core/app_assets/app_assets.dart';

class ArcCarousel extends StatefulWidget {
  const ArcCarousel({
    super.key,
    required this.itemCount,
    this.visibleCount = 5,
    this.onSelected,
  });

  final int itemCount;
  final int visibleCount;
  final ValueChanged<int>? onSelected;

  @override
  State<ArcCarousel> createState() => _ArcCarouselState();
}

class _ArcCarouselState extends State<ArcCarousel>
    with SingleTickerProviderStateMixin {
  final List<String> images = [
    AppAssets.arcCarousel1,
    AppAssets.arcCarousel2,
    AppAssets.arcCarousel3,
    AppAssets.arcCarousel4,
    AppAssets.arcCarousel5,
  ];

  static const _startAngle = math.pi / 120;
  static const _endAngle = 6 * math.pi / 6;

  late final AnimationController _ctrl;
  int _selected = -1;

  double get _centerSlot => (widget.visibleCount - 1) / 2;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController.unbounded(vsync: this, value: 0)
      ..addListener(_notifySelected);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifySelected();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  int _wrap(int index) {
    final c = widget.itemCount;
    return ((index % c) + c) % c;
  }

  void _notifySelected() {
    final index = _wrap((_ctrl.value + _centerSlot).round());
    if (index != _selected) {
      _selected = index;
      widget.onSelected?.call(index);
    }
  }

  ({double cx, double cy, double rx, double ry, double step}) _layout() {
    final size = MediaQuery.of(context).size;
    final rx = size.width * 0.33;
    final step = 1 * rx * math.cos(_startAngle) / (widget.visibleCount - 1);
    return (
      cx: size.width / 2,
      cy: size.height * 0.52,
      rx: rx,
      ry: size.height * 0.14,
      step: step,
    );
  }

  void _animateTo(double target) {
    _ctrl.animateTo(
      target,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _onDragUpdate(DragUpdateDetails d) {
    _ctrl.stop();
    final step = _layout().step;
    _ctrl.value -= d.delta.dx / step;
  }

  void _onDragEnd(DragEndDetails d) {
    final step = _layout().step;
    final velocity = d.primaryVelocity ?? 0;
    final projected = _ctrl.value - velocity / step * 0.12;
    _animateTo(projected.roundToDouble());
  }

  @override
  Widget build(BuildContext context) {
    final l = _layout();
    final itemSize = 70.w;
    final visible = widget.visibleCount;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          // Берём запас слотов слева и справа, чтобы элементы появлялись с другой стороны
          final from = (_ctrl.value - 1).floor();
          final to = (_ctrl.value + visible + 1).ceil();

          return Stack(
            clipBehavior: Clip.none,
            children: [
              for (int i = from; i <= to; i++)
                _buildItem(i, l, itemSize, visible),
            ],
          );
        },
      ),
    );
  }

  Widget _buildItem(
    int logicalIndex,
    ({double cx, double cy, double rx, double ry, double step}) l,
    double itemSize,
    int visible,
  ) {
    final t = logicalIndex - _ctrl.value; // позиция на дуге

    if (t < -1.2 || t > visible + 0.2) {
      return const SizedBox.shrink();
    }

    final index = _wrap(logicalIndex);

    final u = t / (visible - 1);
    final angle = _endAngle - (_endAngle - _startAngle) * u;

    final x = l.cx + l.rx * math.cos(angle);
    final y = l.cy + l.ry * math.sin(angle);

    // симметричное затухание по краям
    final outside = t < 0 ? -t : (t > visible - 1 ? t - (visible - 1) : 0.0);
    final opacity = (1.0 - outside * 1.4).clamp(0.0, 1.0);

    final distToCenter = (t - _centerSlot).abs();
    final isSelected = distToCenter < 0.5;
    final scale = isSelected ? 1.28 : 1.0;

    return Positioned(
      left: x - itemSize / 2,
      top: y - itemSize / 2,
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTap: () {
              // Кратчайший путь до центра
              final current = _ctrl.value + _centerSlot;
              final target = logicalIndex.toDouble();
              final delta = target - current;

              // нормализуем delta в [-itemCount/2, itemCount/2]
              final half = widget.itemCount / 2;
              double shortest = delta;
              if (delta > half) shortest -= widget.itemCount;
              if (delta < -half) shortest += widget.itemCount;

              _animateTo(_ctrl.value + shortest);
            },
            child: _circleAvatar(index, itemSize, isSelected),
          ),
        ),
      ),
    );
  }

  Widget _circleAvatar(int index, double size, bool isSelected) {
    final imageIndex = index % images.length;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
        ],
        image: DecorationImage(
          image: AssetImage(images[imageIndex]),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
