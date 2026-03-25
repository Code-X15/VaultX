import 'package:flutter/material.dart';
import '../utils/platform_data.dart';

class PlatformIcon extends StatelessWidget {
  final String platform;
  final double size;
  final double iconSize;

  const PlatformIcon({
    super.key,
    required this.platform,
    this.size = 48,
    this.iconSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    final info = PlatformData.getInfo(platform);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: info.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(info.icon, color: info.color, size: iconSize),
    );
  }
}
