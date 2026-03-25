import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../utils/password_generator.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() =>
      _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  int _length = 16;
  bool _lower = true;
  bool _upper = true;
  bool _digits = true;
  bool _symbols = true;
  bool _avoidAmbiguous = false;
  String _password = '';
  final List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _generate();
  }

  void _generate() {
    final p = PasswordGenerator.generate(
      length: _length,
      useLowercase: _lower,
      useUppercase: _upper,
      useDigits: _digits,
      useSymbols: _symbols,
      avoidAmbiguous: _avoidAmbiguous,
    );
    setState(() {
      _password = p;
      if (_history.length >= 5) _history.removeAt(0);
      _history.add(p);
    });
  }

  void _copy(String pass) {
    Clipboard.setData(ClipboardData(text: pass));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Password copied!')));
  }

  @override
  Widget build(BuildContext context) {
    final score = PasswordGenerator.strengthScore(_password);
    final color = PasswordGenerator.strengthColor(score);
    final label = PasswordGenerator.strengthLabel(score);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Generator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Password display box
            GestureDetector(
              onTap: () => _copy(_password),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.cardGrey,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppTheme.primaryRed.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    SelectableText(
                      _password,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'monospace',
                        color: AppTheme.white,
                        letterSpacing: 2,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: score,
                        backgroundColor: AppTheme.borderGrey,
                        valueColor: AlwaysStoppedAnimation(color),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Tap to copy',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _generate,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Generate'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _copy(_password),
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Length slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Length',
                  style: TextStyle(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRed.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_length',
                    style: const TextStyle(
                      color: AppTheme.primaryRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Slider(
              value: _length.toDouble(),
              min: 6,
              max: 48,
              divisions: 42,
              activeColor: AppTheme.primaryRed,
              inactiveColor: AppTheme.borderGrey,
              label: _length.toString(),
              onChanged: (v) {
                setState(() => _length = v.toInt());
                _generate();
              },
            ),

            const SizedBox(height: 8),
            const Text(
              'Character Types',
              style: TextStyle(
                color: AppTheme.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _chip(
                  'Lowercase (a-z)',
                  _lower,
                  (v) => setState(() {
                    _lower = v;
                    _generate();
                  }),
                ),
                _chip(
                  'Uppercase (A-Z)',
                  _upper,
                  (v) => setState(() {
                    _upper = v;
                    _generate();
                  }),
                ),
                _chip(
                  'Numbers (0-9)',
                  _digits,
                  (v) => setState(() {
                    _digits = v;
                    _generate();
                  }),
                ),
                _chip(
                  'Symbols (!@#)',
                  _symbols,
                  (v) => setState(() {
                    _symbols = v;
                    _generate();
                  }),
                ),
                _chip(
                  'Avoid Ambiguous',
                  _avoidAmbiguous,
                  (v) => setState(() {
                    _avoidAmbiguous = v;
                    _generate();
                  }),
                ),
              ],
            ),

            // History
            if (_history.length > 1) ...[
              const SizedBox(height: 28),
              const Text(
                'Recent',
                style: TextStyle(
                  color: AppTheme.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              ..._history.reversed
                  .skip(1)
                  .map(
                    (p) => GestureDetector(
                      onTap: () => _copy(p),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.cardGrey,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.borderGrey),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                p,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 13,
                                  color: AppTheme.textGrey,
                                  letterSpacing: 1,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(Icons.copy, size: 16, color: Colors.grey[700]),
                          ],
                        ),
                      ),
                    ),
                  ),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, bool selected, Function(bool) onChanged) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onChanged,
      selectedColor: AppTheme.primaryRed.withValues(alpha: 0.2),
      checkmarkColor: AppTheme.primaryRed,
      labelStyle: TextStyle(
        color: selected ? AppTheme.primaryRed : AppTheme.textGrey,
        fontSize: 13,
      ),
      side: BorderSide(
        color: selected ? AppTheme.primaryRed : AppTheme.borderGrey,
      ),
    );
  }
}
