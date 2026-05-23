import 'package:flutter/material.dart';

class StoreImage extends StatelessWidget {
  const StoreImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
  });

  final String image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final imagePath = _normalizedImagePath(image);
    if (imagePath.isEmpty) {
      return _fallback();
    }

    if (_isNetworkImage(imagePath)) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) => _fallback(),
      );
    }

    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      errorBuilder: (context, error, stackTrace) => _fallback(),
    );
  }

  Widget _fallback() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF2F2F2),
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported, color: Colors.black26),
    );
  }

  bool _isNetworkImage(String value) {
    return value.startsWith('http://') || value.startsWith('https://');
  }

  String _normalizedImagePath(String value) {
    var decoded = value.trim();
    for (var index = 0; index < 3; index++) {
      final next = _decodeOnce(decoded);
      if (next == decoded) {
        break;
      }
      decoded = next;
    }
    return decoded;
  }

  String _decodeOnce(String value) {
    try {
      return Uri.decodeComponent(value);
    } catch (_) {
      try {
        return Uri.decodeFull(value);
      } catch (_) {
        return value;
      }
    }
  }
}
