import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/password_entry.dart';
import '../providers/password_provider.dart';
import '../theme/app_theme.dart';
import '../utils/password_generator.dart';
import '../utils/platform_data.dart';
import '../widgets/platform_icon.dart';

class AddPasswordScreen extends StatefulWidget {
  final PasswordEntry? existing;
  const AddPasswordScreen({super.key, this.existing});

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  late String _platform;
  bool _obscure = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _platform = widget.existing?.platform ?? 'Google';
    if (widget.existing != null) {
      _emailCtrl.text = widget.existing!.email;
      _passCtrl.text = widget.existing!.password;
      _userCtrl.text = widget.existing!.username ?? '';
      _notesCtrl.text = widget.existing!.notes ?? '';
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _userCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final now = DateTime.now();
    final entry = PasswordEntry(
      id: widget.existing?.id ?? const Uuid().v4(),
      platform: _platform,
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      username: _userCtrl.text.trim().isEmpty ? null : _userCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      createdAt: widget.existing?.createdAt ?? now,
      updatedAt: now,
    );
    final ok = await context.read<PasswordProvider>().save(entry);
    if (mounted) {
      if (ok) {
        Navigator.pop(context);
      } else {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save. Try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = PlatformData.getInfo(_platform);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Add Account' : 'Edit Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Platform picker
              _sectionLabel('Platform'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceGrey,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderGrey),
                ),
                child: DropdownButton<String>(
                  value: _platform,
                  isExpanded: true,
                  dropdownColor: AppTheme.cardGrey,
                  underline: const SizedBox(),
                  items: PlatformData.names.map((p) {
                    final pi = PlatformData.getInfo(p);
                    return DropdownMenuItem(
                      value: p,
                      child: Row(
                        children: [
                          Icon(pi.icon, color: pi.color, size: 18),
                          const SizedBox(width: 12),
                          Text(
                            p,
                            style: const TextStyle(color: AppTheme.white),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => _platform = v!),
                ),
              ),

              const SizedBox(height: 24),
              // Selected platform preview
              Center(
                child: Column(
                  children: [
                    PlatformIcon(platform: _platform, size: 64, iconSize: 30),
                    const SizedBox(height: 8),
                    Text(
                      info.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Email
              _sectionLabel('Email / Login'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: info.hint,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Email is required' : null,
              ),

              const SizedBox(height: 16),
              // Username (optional)
              _sectionLabel('Username (optional)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _userCtrl,
                decoration: const InputDecoration(
                  hintText: 'Optional display name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 16),
              // Password
              _sectionLabel('Password'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passCtrl,
                obscureText: _obscure,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Enter or generate password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.wandMagicSparkles,
                          color: AppTheme.primaryRed,
                          size: 16,
                        ),
                        tooltip: 'Generate',
                        onPressed: () => setState(() {
                          _passCtrl.text = PasswordGenerator.generate();
                          _obscure = false;
                        }),
                      ),
                    ],
                  ),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Password is required' : null,
              ),

              // Strength meter
              if (_passCtrl.text.isNotEmpty) ...[
                const SizedBox(height: 10),
                _StrengthMeter(password: _passCtrl.text),
              ],

              const SizedBox(height: 16),
              // Notes
              _sectionLabel('Notes (optional)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Any extra info...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.notes),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.existing == null
                              ? 'Save Account'
                              : 'Update Account',
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: Theme.of(context).textTheme.bodySmall?.copyWith(
      color: AppTheme.textGrey,
      letterSpacing: 0.5,
    ),
  );
}

class _StrengthMeter extends StatelessWidget {
  final String password;
  const _StrengthMeter({required this.password});

  @override
  Widget build(BuildContext context) {
    final score = PasswordGenerator.strengthScore(password);
    final color = PasswordGenerator.strengthColor(score);
    final label = PasswordGenerator.strengthLabel(score);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score,
            backgroundColor: AppTheme.borderGrey,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 4),
        Text('Strength: $label', style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}
