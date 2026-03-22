enum PostType { reading, question, insight }

class SocialComment {
  final String id;
  final String authorAlias;
  final String authorSign;
  final String content;
  final DateTime timestamp;

  const SocialComment({
    required this.id,
    required this.authorAlias,
    required this.authorSign,
    required this.content,
    required this.timestamp,
  });
}

class SocialPost {
  final String id;
  final String authorAlias;
  final String authorSign;
  final String content;
  final DateTime timestamp;
  final PostType type;
  int reactions;
  bool hasReacted;
  final List<SocialComment> comments;

  SocialPost({
    required this.id,
    required this.authorAlias,
    required this.authorSign,
    required this.content,
    required this.timestamp,
    required this.type,
    required this.reactions,
    this.hasReacted = false,
    this.comments = const [],
  });
}
