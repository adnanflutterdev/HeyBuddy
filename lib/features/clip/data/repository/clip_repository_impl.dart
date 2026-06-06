import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/clip/data/data_sources/clip_remote_data_source.dart';
import 'package:hey_buddy/features/clip/data/models/clip_model.dart';
import 'package:hey_buddy/features/clip/domain/entity/clip.dart';
import 'package:hey_buddy/features/clip/domain/repository/clip_repository.dart';

class ClipRepositoryImpl extends ClipRepository {
  final ClipRemoteDataSource remote;
  ClipRepositoryImpl(this.remote);
  @override
  ResultFuture uploadClip(Clip clip) async {
    try {
      await remote.uploadClip(ClipModel.fromEntity(clip));
      return Result.success('Clip created successfully');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to create clip');
    } catch (e) {
      return Result.failure('Failed to create clip');
    }
  }

  @override
  ResultStream<List<Clip>> getAllClips() {
    try {
      return remote.getAllClips();
    } catch (_) {
      return Stream.error('Failed to fetch clips');
    }
  }

  @override
  ResultFuture<Clip> getClipData(String id) async {
    try {
      final clip = await remote.getClipData(id);
      return Result.success('Clip Data Fetched', data: clip);
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to fetch Clip');
    } catch (_) {
      return Result.failure('Failed to fetch Clip');
    }
  }

  @override
  ResultStream<List<String>> getLikeStream(String id) {
    return remote.getLikeStream(id);
  }

  @override
  ResultFuture toggleClipLike({
    required String id,
    required String uid,
    required bool isLiked,
  }) async {
    try {
      await remote.toggleClipLike(id: id, uid: uid, isLiked: isLiked);
      return Result.success('Liked toggled Successfully');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to toggle like');
    } catch (e) {
      return Result.failure('Failed liked to toggle like');
    }
  }
}
