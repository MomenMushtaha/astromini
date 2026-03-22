import 'package:flutter/material.dart';
import '../models/social_post.dart';
import '../theme/app_theme.dart';
import '../services/astro/zodiac_util.dart';

class SocialPostCard extends StatelessWidget {
  final SocialPost post;
  final VoidCallback onReact;

  const SocialPostCard({
    super.key,
    required this.post,
    required this.onReact,
  });

  @override
  Widget build(BuildContext context) {
    final signIdx = ZodiacUtil.signNames.indexOf(post.authorSign);
    final signSymbol =
        signIdx >= 0 ? ZodiacUtil.signSymbols[signIdx] : '\u2728';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withAlpha(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentPurple.withAlpha(30),
                ),
                child: Center(
                  child: Text(signSymbol,
                      style: const TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(post.authorAlias,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            )),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppTheme.accentPurple.withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            post.authorSign,
                            style: const TextStyle(
                              color: AppTheme.accentPurple,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(_timeAgo(post.timestamp),
                        style: const TextStyle(
                            color: AppTheme.textSecondary, fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _typeColor(post.type).withAlpha(20),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _typeLabel(post.type),
                  style: TextStyle(
                    color: _typeColor(post.type),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Content
          Text(post.content,
              style: const TextStyle(
                  color: AppTheme.textPrimary, fontSize: 14, height: 1.4)),

          const SizedBox(height: 10),

          // Reactions
          Row(
            children: [
              GestureDetector(
                onTap: onReact,
                child: Row(
                  children: [
                    Icon(
                      post.hasReacted
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 18,
                      color: post.hasReacted
                          ? const Color(0xFFEF5350)
                          : AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post.reactions}',
                      style: TextStyle(
                        color: post.hasReacted
                            ? const Color(0xFFEF5350)
                            : AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.chat_bubble_outline,
                  size: 16, color: AppTheme.textSecondary),
              const SizedBox(width: 4),
              Text('${post.comments.length}',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
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

  Color _typeColor(PostType type) {
    switch (type) {
      case PostType.reading:
        return AppTheme.accentGold;
      case PostType.question:
        return const Color(0xFF42A5F5);
      case PostType.insight:
        return const Color(0xFF66BB6A);
    }
  }
}
