import 'package:flutter/foundation.dart';
import '../models/social_post.dart';
import '../services/social_feed_service.dart';

class SocialFeedProvider extends ChangeNotifier {
  final SocialFeedService _service = SocialFeedService();
  List<SocialPost> _allPosts = [];
  List<SocialPost> _filteredPosts = [];
  String? _filterSign;
  bool _isLoading = false;

  List<SocialPost> get posts => _filteredPosts;
  String? get filterSign => _filterSign;
  bool get isLoading => _isLoading;

  Future<void> loadPosts() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));
    _allPosts = _service.generatePosts();
    _applyFilter();

    _isLoading = false;
    notifyListeners();
  }

  void filterBySign(String? signName) {
    _filterSign = signName;
    _applyFilter();
    notifyListeners();
  }

  void toggleReaction(String postId) {
    final post = _allPosts.firstWhere((p) => p.id == postId);
    if (post.hasReacted) {
      post.reactions--;
      post.hasReacted = false;
    } else {
      post.reactions++;
      post.hasReacted = true;
    }
    notifyListeners();
  }

  void createPost(String content, PostType type, String userSign) {
    final post = SocialPost(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      authorAlias: 'You',
      authorSign: userSign,
      content: content,
      timestamp: DateTime.now(),
      type: type,
      reactions: 0,
    );
    _allPosts.insert(0, post);
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_filterSign == null) {
      _filteredPosts = List.from(_allPosts);
    } else {
      _filteredPosts =
          _allPosts.where((p) => p.authorSign == _filterSign).toList();
    }
  }
}
