import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final Color? color;
  final bool forceAssets;
  final double? height;
  final double? width;
  final bool gaplessPlayback;

  const ImageView(this.url,
      {this.fit = BoxFit.contain,
      this.color,
      this.forceAssets = false,
      this.height,
      this.width,
      this.gaplessPlayback = false,
      Key? key})
      : super(key: key);

  bool get isAssets => url.startsWith('assets/') || url.startsWith('lib/') || forceAssets;

  @override
  Widget build(BuildContext context) {
    return isAssets
        ? ExtendedImage.asset(url,
            fit: fit, color: color, height: height, width: width, gaplessPlayback: gaplessPlayback)
        : ExtendedImage.network(url,
            fit: fit, color: color, height: height, width: width, gaplessPlayback: gaplessPlayback);
    /*CachedNetworkImage(
        imageUrl: url,
        fit: fit, color: color,
        height: height, width: width,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
     );*/
  }
}
