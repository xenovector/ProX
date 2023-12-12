// R stands for Resources.
class R {
  static final lottie = _Lottie();
  static final image = _Image();
  static final icons = _Icons();
  static final prox = _ProXAssets();
}

// Prox Internal Assets
class _ProXAssets {
  static const path = 'lib/ProX/Assets';
  final tick = '$path/tick.png';
  final greenTick = '$path/green_tick.png';
}

// Project Icons
class _Icons {
  static const path = 'assets/img';
  final iconsX = '$path/iconsX.png';
}

// Project Image
class _Image {
  static const path = 'assets/img';
  final bannerX = '$path/bannerX.png';
}

// Project Lottie
class _Lottie {
  static const path = 'assets/lottie';
  final loading = '$path/loading.json';
}