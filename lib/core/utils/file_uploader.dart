import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:hey_buddy/core/model/media_meta.dart';
import 'package:hey_buddy/keys.dart';
// ignore_for_file: implementation_imports
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/model/upload_progress.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:hey_buddy/core/riverpod/upload_progress_provider.dart';

class FileUploader {
  static final cloudinary = Cloudinary.fromStringUrl(
    'cloudinary://$cloudinaryApiKey:$cloudinaryApiSecret@$cloudinaryCloudName',
  );

  FileUploader._() {
    cloudinary.config.urlConfig.secure = true;
  }

  static Future<List<MediaMeta>?> uploadFiles({
    required WidgetRef ref,
    required dynamic folder,
    required List<File> files,
    required List<String> names,
  }) async {
    try {
      final uploadNotifier = ref.read(uploadProgressProvider.notifier);
      Map<int, UploadProgress> uploadProgress = {};
      final response = await Future.wait(
        files.asMap().entries.map((entry) async {
          int index = entry.key;
          File file = entry.value;
          return cloudinary.uploader().upload(
            file,
            params: UploadParams(
              publicId: names[index],
              uniqueFilename: false,
              overwrite: true,
              folder: (folder is String) ? folder : folder[index],
              useFilename: true,
            ),
            progressCallback: (bytesUploaded, totalBytes) {
              uploadProgress[index] = UploadProgress(
                total: totalBytes,
                uploaded: bytesUploaded,
              );
              int totalUploaded = uploadProgress.values.fold(
                0,
                (previousValue, element) => previousValue + element.uploaded,
              );
              int totalSize = uploadProgress.values.fold(
                0,
                (previousValue, element) => previousValue + element.total,
              );
              double progress = totalSize == 0
                  ? 0
                  : (totalUploaded / totalSize) * 100;
              uploadNotifier.updateProgress(progress);
            },
          );
        }),
      );

      List<MediaMeta> urls = [];

      for (final r in response) {
        if (r != null && r.rawResponse != null) {
          final uploadData = jsonDecode(r.rawResponse!);
          int width = uploadData['width'] ?? 0;
          int height = uploadData['height'] ?? 0;
          urls.add(
            MediaMeta(
              url: uploadData['secure_url'],
              width: width,
              height: height,
              aspectRatio: (width / height).clamp(0.5, 1.8),
            ),
          );
        }
      }
      return urls;
    } catch (_) {
      return null;
    }
  }

  static Future<MediaMeta?> uploadVideo({
    required WidgetRef ref,
    required String folder,
    required File video,
    required String name,
  }) async {
    try {
      final uploadNotifier = ref.read(uploadProgressProvider.notifier);
      final response = await cloudinary.uploader().upload(
        video,
        params: UploadParams(
          publicId: name,
          uniqueFilename: false,
          overwrite: true,
          folder: folder,
          useFilename: true,
          resourceType: 'video',
        ),
        progressCallback: (bytesUploaded, totalBytes) {
          double progress = totalBytes == 0
              ? 0
              : (bytesUploaded / totalBytes) * 100;
          uploadNotifier.updateProgress(progress);
        },
      );

      MediaMeta? meta;

      if (response != null && response.rawResponse != null) {
        final uploadData = jsonDecode(response.rawResponse!);
        log(uploadData.toString());
        int width = uploadData['width'] ?? 0;
        int height = uploadData['height'] ?? 0;

        meta = MediaMeta(
          url: uploadData['secure_url'],
          width: width,
          height: height,
          aspectRatio: (width > 0 && height > 0)
              ? (width / height).clamp(0.5, 1.8)
              : 1,
          thumbnail:
              'https://res.cloudinary.com/$cloudinaryCloudName/video/upload/so_1/${uploadData['public_id']}.jpg',
        );
      }

      return meta;
    } catch (_) {
      return null;
    }
  }
}
