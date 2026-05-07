import 'package:hey_buddy/features/feed/domain/entity/feed_item_entity.dart';
import 'package:hey_buddy/features/feed/domain/entity/timestamps_entity.dart';

abstract class CommentEntity {
  final String id;
  final String userId;
  final CommentContentEntity content;
  final TimestampsEntity timestamps;

  CommentEntity({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamps,
  });
}

abstract class CommentContentEntity {
  final String? text;
  final MediaEntity? mediaEntity;

  CommentContentEntity({required this.text, this.mediaEntity});
}
