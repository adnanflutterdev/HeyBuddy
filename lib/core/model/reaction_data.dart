import 'package:hey_buddy/core/model/reaction.dart';

class ReactionData {
  final List<ReactionCount> reactionsCount;
  final String displayText;
  final Reaction? myReaction;

  ReactionData({
    required this.reactionsCount,
    required this.displayText,
    this.myReaction,
  });
}

class ReactionCount {
  final int count;
  final String reactionName;
  final String reactionEmoji;

  ReactionCount({
    this.count = 1,
    required this.reactionName,
    required this.reactionEmoji,
  });

  ReactionCount increaseValue() {
    return ReactionCount(
      count: count + 1,
      reactionName: reactionName,
      reactionEmoji: reactionEmoji,
    );
  }
}
