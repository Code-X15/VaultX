import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/password_entry.dart';
import '../providers/password_provider.dart';
import '../theme/app_theme.dart';
import '../utils/platform_data.dart';
import '../widgets/platform_icon.dart';
import 'add_password_screen.dart';

class PasswordDetailScreen extends StatefulWidget {
  final PasswordEntry entry;
  const PasswordDetailScreen({super.key, required this.entry});

  @override
  State<PasswordDetailScreen> createState() => _PasswordDetailScreenState();
}

class _PasswordDetailScreenState extends State<PasswordDetailScreen> {
  bool _showPass = false;

  void _copy(String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: AppTheme.primaryRed,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text('$label copied!'),
          ],
        ),
      ),
    );
  }

  Future<void> _delete() async {
    final navigator = Navigator.of(context);
    final provider = context.read<PasswordProvider>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Account'),
        content: Text(
          'Remove ${widget.entry.platform} account? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textGrey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.primaryRed),
            ),
          ),
        ],
      ),
    );
    if (!mounted || confirm != true) return;

    await provider.delete(widget.entry.id);
    if (!mounted) return;
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final info = PlatformData.getInfo(widget.entry.platform);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry.platform),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppTheme.primaryRed),
            onPressed: () async {
              final navigator = Navigator.of(context);
              await navigator.push(
                MaterialPageRoute(
                  builder: (_) => AddPasswordScreen(existing: widget.entry),
                ),
              );
              if (!mounted) return;
              navigator.pop();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red[300]),
            onPressed: _delete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: info.color.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: info.color.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      PlatformIcon(
                        platform: widget.entry.platform,
                        size: 72,
                        iconSize: 34,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        widget.entry.platform,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        info.category,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: info.color),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 300.ms)
                .scale(begin: const Offset(0.97, 0.97)),

            const SizedBox(height: 20),

            // Fields
            _fieldCard(
              context,
              label: 'Email / Login',
              value: widget.entry.email,
              icon: Icons.email_outlined,
              onCopy: () => _copy(widget.entry.email, 'Email'),
            ),
            if (widget.entry.username != null)
              _fieldCard(
                context,
                label: 'Username',
                value: widget.entry.username!,
                icon: Icons.person_outline,
                onCopy: () => _copy(widget.entry.username!, 'Username'),
              ),
            _passwordCard(context),
            if (widget.entry.notes != null)
              _fieldCard(
                context,
                label: 'Notes',
                value: widget.entry.notes!,
                icon: Icons.notes,
                onCopy: () => _copy(widget.entry.notes!, 'Notes'),
              ),

            const SizedBox(height: 16),
            Text(
              'Created: ${_fmt(widget.entry.createdAt)}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 4),
            Text(
              'Updated: ${_fmt(widget.entry.updatedAt)}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _fieldCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onCopy,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardGrey,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderGrey),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryRed, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.textGrey,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(color: AppTheme.white, fontSize: 15),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy, color: Colors.grey[600], size: 18),
            onPressed: onCopy,
          ),
        ],
      ),
    );
  }

  Widget _passwordCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardGrey,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderGrey),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline, color: AppTheme.primaryRed, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Password',
                  style: TextStyle(color: AppTheme.textGrey, fontSize: 11),
                ),
                const SizedBox(height: 3),
                Text(
                  _showPass ? widget.entry.password : '• ' * 10,
                  style: TextStyle(
                    color: AppTheme.white,
                    fontSize: _showPass ? 15 : 12,
                    letterSpacing: _showPass ? 1 : 2,
                    fontFamily: _showPass ? null : 'monospace',
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _showPass ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[600],
              size: 18,
            ),
            onPressed: () => setState(() => _showPass = !_showPass),
          ),
          IconButton(
            icon: Icon(Icons.copy, color: Colors.grey[600], size: 18),
            onPressed: () => _copy(widget.entry.password, 'Password'),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime dt) =>
      '${dt.day}/${dt.month}/${dt.year}  ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
}
