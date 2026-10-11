import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:moth_hop/core/app_assets/app_assets.dart';
import 'package:moth_hop/feature/game/engine/behaviors/platform_behavior.dart';
import 'package:moth_hop/feature/game/engine/entity/platform.dart';
import 'package:moth_hop/feature/game/engine/entity/player.dart';
import 'package:moth_hop/feature/game/engine/entity/yarn.dart';
import 'package:moth_hop/feature/game/engine/enums/game_status.dart';
import 'package:moth_hop/feature/game/engine/enums/platform_kind.dart';
import 'package:moth_hop/feature/game/engine/game_cfg/game_config.dart';
import 'package:moth_hop/feature/game/engine/system/background_system.dart';
import 'package:moth_hop/feature/game/engine/system/cleanup_system.dart';
import 'package:moth_hop/feature/game/engine/system/collect_system.dart';
import 'package:moth_hop/feature/game/engine/system/physics_system.dart';
import 'package:moth_hop/feature/game/engine/system/score_system.dart';
import 'package:moth_hop/feature/game/engine/system/spawn_system.dart';

class GameWorld extends FlameGame with PanDetector {
  GameWorld({required this.onScoreChanged, required this.onGameOver});

  final void Function(int score, int yarns) onScoreChanged;
  final void Function() onGameOver;

  final Random _rng = Random();
  final ScoreSystem _scoreSystem = ScoreSystem();
  final CollectSystem _collectSystem = CollectSystem();

  late final SpawnSystem _spawnSystem;
  late final CleanupSystem _cleanupSystem;
  late final PhysicsSystem _physicsSystem;
  late final ScrollingBackground _background;
  late final _GameContextImpl _ctx;

  late Player _player;
  GameStatus _status = GameStatus.running;
  bool _imagesReady = false;

  GameStatus get status => _status;

  @override
  Color backgroundColor() => const Color(0xFF2B2420);

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    camera.viewfinder.anchor = Anchor.topLeft;
    camera.viewfinder.position = Vector2.zero();
  }

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    camera.viewfinder.position = Vector2.zero();

    await images.loadAll(AppAssets.flameGameImages);
    _imagesReady = true;

    _ctx = _GameContextImpl().._game = this;
    _spawnSystem = SpawnSystem(world: world, rng: _rng, screenWidth: size.x);
    _cleanupSystem = CleanupSystem(world);
    _physicsSystem = PhysicsSystem(_ctx);

    _background = ScrollingBackground(images: images, viewSize: size.clone());
    await camera.backdrop.add(_background);

    _setupRound();
  }

  void _setupRound() {
    _status = GameStatus.running;

    final startY = size.y - 150;
    final startWidth = GameConfig.platformSize(PlatformKind.normal).x;
    final startX = size.x / 2 - startWidth / 2;

    _player = Player(position: Vector2(size.x / 2, startY - 4))
      ..velocityY = GameConfig.jumpVelocity;
    world.add(_player);

    _spawnSystem.seed(startY);
    _spawnSystem.spawnFixed(
      kind: PlatformKind.normal,
      x: startX,
      y: startY,
      withYarn: false,
    );
    for (var i = 0; i < GameConfig.platformsAhead; i++) {
      _spawnSystem.spawnOne();
    }

    _scoreSystem.reset(_player.position.y);
    onScoreChanged(_player.score, _player.yarns);
  }

  Future<void> restart() async {
    resumeEngine();
    world.removeAll(world.children.toList());
    _spawnSystem.reset();
    if (_imagesReady) {
      _background.reset();
    }
    _setupRound();
  }

  void pauseGame() {
    if (_status == GameStatus.gameOver) return;
    _status = GameStatus.paused;
    pauseEngine();
  }

  void resumeGame() {
    if (_status != GameStatus.paused) return;
    _status = GameStatus.running;
    resumeEngine();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (_status != GameStatus.running || _player.isDead) return;
    _player.position.x += info.delta.global.x;
    _player.wrapX(size.x);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_status != GameStatus.running) return;

    final keepY = size.y * GameConfig.cameraKeepLine;
    if (_player.position.y < keepY) {
      _scrollWorld(keepY - _player.position.y);
    }

    _physicsSystem.update(
      _player,
      world.children.whereType<PlatformEntity>().toList(),
      dt,
      size.x,
    );

    _collectSystem.update(_player, world.children.whereType<Yarn>());
    _scoreSystem.update(_player);
    _background.onScore(_player.score);
    onScoreChanged(_player.score, _player.yarns);
    _cleanupSystem.update(size.y);
    _fillAhead();

    if (_player.position.y > size.y + 120) {
      _status = GameStatus.gameOver;
      onGameOver();
    }
  }

  void _scrollWorld(double dy) {
    for (final c in world.children.whereType<PositionComponent>()) {
      c.position.y += dy;
    }
    _scoreSystem.shiftBy(dy);
    _spawnSystem.shiftBy(dy);
    _background.scroll(dy);
  }

  void _fillAhead() {
    var guard = 0;
    while (_spawnSystem.highestY >
            -GameConfig.platformsAhead * GameConfig.maxPlatformGap &&
        guard < 80) {
      _spawnSystem.spawnOne();
      guard++;
    }
  }
}

class _GameContextImpl implements GameContext {
  late GameWorld _game;

  GameWorld get g => _game;

  @override
  void bounce(double velocity) {
    g._player.velocityY = velocity;
  }

  @override
  void killPlayer() {
    if (g._player.isDead) return;
    g._player.isDead = true;
    g._player.velocityY = -280;
  }

  @override
  void teleportUp(PlatformEntity from) {
    final partner = from.teleportPartner;
    if (partner == null || !partner.isMounted) {
      g._player.velocityY = GameConfig.jumpVelocity;
      return;
    }
    g._player.position.x = partner.position.x + partner.size.x / 2;
    g._player.position.y = partner.position.y;
    g._player.velocityY = -260;
  }

  @override
  void breakPlatform(PlatformEntity p) => p.beginFadeOut();

  @override
  void changePlatformSprite(PlatformEntity p) {
    if (p.isMounted) p.refreshSprite();
  }

  @override
  void boostJump(PlatformEntity p, int tiles) {
    g._player.velocityY = GameConfig.jumpPadVelocity;
  }
}
