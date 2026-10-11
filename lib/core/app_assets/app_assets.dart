class AppAssets {
  const AppAssets._();

  static const String splashBackground = 'assets/images/splash.png';
  static const String logo = 'assets/images/logo.png';
  static const String mainCharacter = 'assets/images/main_character.png';
  static const String mainPillow = 'assets/images/main_pillow.png';
  static const String bottomElement = 'assets/images/bottom_element.png';
  static const String settingsIcon = 'assets/images/btn_settings.png';
  static const String counBtn = 'assets/images/count.png';
  static const String playBtn = 'assets/images/btn_play.png';
  static const String scoreBtn = 'assets/images/btn_score.png';
  static const String shopBtn = 'assets/images/btn_shop.png';
  static const String btnSoundOn = 'assets/images/btn_sound_on.png';
  static const String btnSoundOff = 'assets/images/btn_sound_off.png';
  static const String btnVibrationOn = 'assets/images/btn_vibro_on.png';
  static const String btnVibrationOff = 'assets/images/btn_vibro_off.png';
  static const String pauseBtn = 'assets/images/btn_pause.png';

  static const String normalPlatform = 'assets/images/normal_plat.png';
  static const String fragilePlatform = 'assets/images/fragile_plat.png';
  static const String breakablePlatform = 'assets/images/breakable_plat.png';
  static const String almostBreakablePlatform =
      'assets/images/almost_breakable_plat.png';
  static const String breakedPlatform = 'assets/images/breaked_plat.png';
  static const String jumpPadPlatform = 'assets/images/jump_plat.png';
  static const String teleportPlatform = 'assets/images/teleport_plat.png';
  static const String movingPlatform = 'assets/images/moving_plat.png';
  static const String spikePlatform = 'assets/images/spike_plat.png';

  static const String fBackgroundSelector =
      'assets/images/f_game_background_selector.png';

  static const String arcCarousel4 = 'assets/images/level_1.png';
  static const String arcCarousel2 = 'assets/images/level_2.png';
  static const String arcCarousel1 = 'assets/images/level_3.png';
  static const String arcCarousel5 = 'assets/images/level_4.png';
  static const String arcCarousel3 = 'assets/images/level_5.png';

  static const String blockedLevel = 'assets/images/blocked_level.png';

  static const String gameBackground1 = 'assets/images/game_bg_1.png';
  static const String gameBackground2 = 'assets/images/game_bg_2.png';

  static const String _imagesPrefix = 'assets/images/';

  /// Flame loads images relative to `assets/images/`.
  static String flameName(String assetPath) {
    return assetPath.startsWith(_imagesPrefix)
        ? assetPath.substring(_imagesPrefix.length)
        : assetPath;
  }

  static List<String> get flameGameImages => [
    flameName(mainCharacter),
    flameName(normalPlatform),
    flameName(fragilePlatform),
    flameName(breakablePlatform),
    flameName(almostBreakablePlatform),
    flameName(breakedPlatform),
    flameName(jumpPadPlatform),
    flameName(teleportPlatform),
    flameName(movingPlatform),
    flameName(spikePlatform),
    flameName(gameBackground1),
    flameName(gameBackground2),
  ];

  /// Усі ассети для прелоаду.
  static const List<String> all = [
    splashBackground,
    logo,
    mainCharacter,
    mainPillow,
    bottomElement,
    settingsIcon,
    counBtn,
    playBtn,
    scoreBtn,
    shopBtn,
    btnSoundOn,
    btnSoundOff,
    btnVibrationOn,
    btnVibrationOff,
    fBackgroundSelector,
    arcCarousel1,
    arcCarousel2,
    arcCarousel3,
    arcCarousel4,
    arcCarousel5,
    blockedLevel,
    gameBackground1,
    gameBackground2,
    pauseBtn,
    normalPlatform,
    fragilePlatform,
    breakablePlatform,
    almostBreakablePlatform,
    breakedPlatform,
    jumpPadPlatform,
    teleportPlatform,
    movingPlatform,
    spikePlatform,
  ];
}
