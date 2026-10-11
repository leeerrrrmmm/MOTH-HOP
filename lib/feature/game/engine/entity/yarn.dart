import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:moth_hop/feature/game/engine/entity/platform.dart';
import 'package:moth_hop/feature/game/engine/game_cfg/game_config.dart';

class Yarn extends PositionComponent {
  Yarn({
    required super.position,
    this.value = 1,
    this.platform,
    Vector2? localOffset,
  }) : localOffset = localOffset ?? Vector2.zero(),
       super(
         size: GameConfig.yarnSize.clone(),
         anchor: Anchor.center,
         priority: 12,
       );

  final int value;
  PlatformEntity? platform;
  final Vector2 localOffset;

  @override
  void update(double dt) {
    super.update(dt);
    final host = platform;
    if (host == null) return;
    if (!host.isMounted) {
      platform = null;
      return;
    }
    position.setFrom(host.position + localOffset);
  }

  @override
  void render(Canvas canvas) {
    final cx = size.x / 2;
    final cy = size.y / 2;
    final radius = size.x / 2 - 1.5;

    canvas.drawCircle(
      Offset(cx, cy),
      radius,
      Paint()..color = const Color(0xFF8B3A3A),
    );
    canvas.drawCircle(
      Offset(cx - 2, cy - 2),
      radius * 0.72,
      Paint()..color = const Color(0xFFB54A4A),
    );

    final swirl = Paint()
      ..color = const Color(0xFF6E2C2C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    final path = Path();
    for (var i = 0; i < 18; i++) {
      final t = i / 18;
      final a = t * math.pi * 2.4;
      final r = radius * (0.18 + t * 0.7);
      final p = Offset(cx + math.cos(a) * r, cy + math.sin(a) * r);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(path, swirl);

    final needle = Paint()
      ..color = const Color(0xFFE8E0D4)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx + 3, cy - radius + 1), Offset(cx + 7, 1), needle);
    canvas.drawCircle(
      Offset(cx + 7.4, 1.2),
      1.3,
      Paint()..color = const Color(0xFFF4EEE4),
    );
  }
}
