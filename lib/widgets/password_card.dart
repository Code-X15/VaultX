import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/password_entry.dart';
import '../utils/platform_data.dart';
import '../theme/app_theme.dart';

class PasswordCard extends StatelessWidget {
  final PasswordEntry entry;
  final int index;
  final VoidCallback onTap;

  const PasswordCard({
    super.key,
    required this.entry,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final info = PlatformData.getInfo(entry.platform);

    return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardGrey,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderGrey),
            ),
            child: Row(
              children: [
                // Platform icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: info.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(info.icon, color: info.color, size: 22),
                ),
                const SizedBox(width: 14),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.platform,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        entry.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textGrey,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
              ],
            ),
          ),
        )
        .animate(delay: (index * 50).ms)
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.08, end: 0, curve: Curves.easeOut);
  }
}
