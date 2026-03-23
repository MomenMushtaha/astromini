import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/social_post.dart';
import '../providers/social_feed_provider.dart';
import '../providers/birth_chart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/social_post_card.dart';
import '../widgets/sign_filter_chips.dart';

class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final feedProvider = context.read<SocialFeedProvider>();
      if (feedProvider.posts.isEmpty) {
        feedProvider.loadPosts();
      }
      // Auto-filter to user's sign if chart exists and no filter set yet
      if (feedProvider.filterSign == null) {
        final chartProvider = context.read<BirthChartProvider>();
        if (chartProvider.hasChart) {
          feedProvider.filterBySign(chartProvider.chart!.sunSign.sign);
        }
      }
    });
  }

  void _showComposeDialog() {
    final contentController = TextEditingController();
    PostType selectedType = PostType.insight;

    final chartProvider = context.read<BirthChartProvider>();
    final userSign = chartProvider.hasChart
        ? chartProvider.chart!.sunSign.sign
        : 'Unknown';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Share with the cosmos',
                      style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  Row(
                    children: PostType.values.map((type) {
                      final isSelected = type == selectedType;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(_typeLabel(type)),
                          selected: isSelected,
                          selectedColor: AppTheme.accentPurple.withAlpha(60),
                          backgroundColor: AppTheme.cardDark,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppTheme.accentPurple
                                : AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? AppTheme.accentPurple.withAlpha(80)
                                : Colors.transparent,
                          ),
                          onSelected: (_) =>
                              setSheetState(() => selectedType = type),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: contentController,
                    maxLines: 4,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'What\'s on your cosmic mind?',
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (contentController.text.trim().isNotEmpty) {
                          context.read<SocialFeedProvider>().createPost(
                                contentController.text.trim(),
                                selectedType,
                                userSign,
                              );
                          Navigator.pop(ctx);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Post'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _typeLabel(PostType type) {
    switch (type) {
      case PostType.reading:
        return 'Reading';
      case PostType.question:
        return 'Question';
      case PostType.insight:
        return 'Insight';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cosmic Feed')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showComposeDialog,
        backgroundColor: AppTheme.accentPurple,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      body: Consumer<SocialFeedProvider>(
        builder: (ctx, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                  color: AppTheme.accentPurple),
            );
          }

          return Column(
            children: [
              SignFilterChips(
                selectedSign: provider.filterSign,
                onSignSelected: (sign) => provider.filterBySign(sign),
              ),
              Expanded(
                child: provider.posts.isEmpty
                    ? const Center(
                        child: Text('No posts yet.',
                            style: TextStyle(
                                color: AppTheme.textSecondary)),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: provider.posts.length,
                        itemBuilder: (ctx, i) {
                          final post = provider.posts[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: SocialPostCard(
                              post: post,
                              onReact: () =>
                                  provider.toggleReaction(post.id),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
