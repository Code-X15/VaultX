import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/password_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/password_card.dart';
import 'add_password_screen.dart';
import 'generator_screen.dart';
import 'password_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PasswordProvider>();

    return Scaffold(
      backgroundColor: AppTheme.black,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: AppTheme.black,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.shield,
                    color: AppTheme.primaryRed,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'VaultX',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.wandMagicSparkles,
                  color: AppTheme.primaryRed,
                  size: 18,
                ),
                tooltip: 'Password Generator',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PasswordGeneratorScreen(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Stats bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: _StatsBar(count: provider.totalCount),
            ),
          ),

          // Search
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: TextField(
                controller: _searchCtrl,
                onChanged: provider.search,
                decoration: InputDecoration(
                  hintText: 'Search platforms or emails...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchCtrl.clear();
                            provider.clearSearch();
                          },
                        )
                      : null,
                ),
              ).animate().fadeIn(duration: 300.ms),
            ),
          ),

          // Empty state or list
          provider.isLoading
              ? const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryRed,
                    ),
                  ),
                )
              : provider.entries.isEmpty
              ? SliverFillRemaining(
                  child: _EmptyState(
                    hasSearch: provider.searchQuery.isNotEmpty,
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((ctx, i) {
                      final entry = provider.entries[i];
                      return PasswordCard(
                        entry: entry,
                        index: i,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PasswordDetailScreen(entry: entry),
                            ),
                          );
                        },
                      );
                    }, childCount: provider.entries.length),
                  ),
                ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddPasswordScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add Account'),
      ).animate().scale(delay: 400.ms, curve: Curves.elasticOut),
    );
  }
}

class _StatsBar extends StatelessWidget {
  final int count;
  const _StatsBar({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryRed.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryRed.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.security, color: AppTheme.primaryRed, size: 18),
          const SizedBox(width: 10),
          Text(
            '$count account${count != 1 ? 's' : ''} stored securely',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryRed,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasSearch;
  const _EmptyState({required this.hasSearch});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasSearch ? Icons.search_off : FontAwesomeIcons.lock,
            size: 72,
            color: AppTheme.borderGrey,
          ),
          const SizedBox(height: 20),
          Text(
            hasSearch ? 'No results found' : 'No accounts saved yet',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppTheme.textGrey),
          ),
          const SizedBox(height: 8),
          Text(
            hasSearch
                ? 'Try a different search term'
                : 'Tap + to add your first account',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.borderGrey),
          ),
        ],
      ).animate().fadeIn(duration: 500.ms),
    );
  }
}
