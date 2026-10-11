import 'package:moth_hop/feature/game/engine/behaviors/breakable_behavior.dart';
import 'package:moth_hop/feature/game/engine/behaviors/fragile_behavior.dart';
import 'package:moth_hop/feature/game/engine/behaviors/jump_behavior.dart';
import 'package:moth_hop/feature/game/engine/behaviors/moving_behavior.dart';
import 'package:moth_hop/feature/game/engine/behaviors/normal_behavior.dart';
import 'package:moth_hop/feature/game/engine/behaviors/platform_behavior.dart';
import 'package:moth_hop/feature/game/engine/behaviors/spike_behavior.dart';
import 'package:moth_hop/feature/game/engine/behaviors/teleport_behavior.dart';
import 'package:moth_hop/feature/game/engine/enums/platform_kind.dart';

/// Маппінг тип → поведінка
final Map<PlatformKind, PlatformBehavior> platformBehaviors = {
  PlatformKind.normal: NormalBehavior(),
  PlatformKind.fragile: FragileBehavior(),
  PlatformKind.breakable: BreakableBehavior(),
  PlatformKind.jumpPad: JumpPadBehavior(),
  PlatformKind.teleport: TeleportBehavior(),
  PlatformKind.moving: MovingBehavior(),
  PlatformKind.spike: SpikeBehavior(),
};
