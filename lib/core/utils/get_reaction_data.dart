import 'package:hey_buddy/core/model/reaction_data.dart';
import 'package:hey_buddy/core/model/reaction.dart';

ReactionData getReactionData({
  required List<Reaction> reactions,
  required String uid,
}) {
  Map<String, ReactionCount> data = {};
  Reaction? myReaction;

  for (Reaction r in reactions) {
    if (data.containsKey(r.reactionName)) {
      ReactionCount oldReaction = data[r.reactionName]!;
      data[r.reactionName] = oldReaction.increaseValue();
    } else {
      data[r.reactionName] = ReactionCount(
        reactionName: r.reactionName,
        reactionEmoji: r.reactionEmoji,
      );
    }

    if (myReaction == null && r.userId == uid) {
      myReaction = r;
    }
  }
  List<ReactionCount> reactionsCount = data.keys
      .map((String key) => data[key]!)
      .toList();

  reactionsCount.sort((a, b) => b.count.compareTo(a.count));
  String displayText = reactionsCount
      .take(3)
      .map((r) => r.reactionEmoji)
      .toList()
      .join('');
  return ReactionData(
    reactionsCount: reactionsCount,
    displayText: displayText,
    myReaction: myReaction,
  );
}
