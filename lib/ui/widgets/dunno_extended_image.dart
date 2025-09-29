import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DunnoExtendedImage extends StatefulWidget {
  final String? url;
  final BoxFit fit;

  const DunnoExtendedImage({super.key, this.url, this.fit = BoxFit.cover});

  @override
  State<DunnoExtendedImage> createState() => _DunnoExtendedImageState();
}

class _DunnoExtendedImageState extends State<DunnoExtendedImage> {
  _loadingImage() {
    return Container(
      color: Colors.grey.shade400,
      child: const Center(
        child: Icon(
          Icons.person,
          color: Colors.white70,
          size: 100,
        ),
      ),
    );
  }

  _content() {
    if (widget.url != null && widget.url!.isNotEmpty && (widget.url!.startsWith('http') || widget.url!.startsWith('https'))) {
      try {
        return CachedNetworkImage(
          key: Key(widget.url!),
          imageUrl: widget.url ?? '',
          errorWidget: (context, url, error) {
            return _loadingImage();
          },
          progressIndicatorBuilder: (context, url, downloadProgress) {
            return Opacity(
              opacity: downloadProgress.progress ?? 0.01,
              child: _loadingImage(),
            );
          },
          fit: widget.fit,
          fadeInDuration: const Duration(milliseconds: 100),
          fadeOutDuration: const Duration(milliseconds: 100),
          fadeInCurve: Curves.easeInOut,
          fadeOutCurve: Curves.easeInOut,
          scale: 5 / 4,
        );
      } catch (e) {
        return _loadingImage();
      }
    } else {
      return _loadingImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _content();
  }
}
