import 'dart:io';
import 'dart:convert';
import 'package:hey_buddy/core/model/image_upload_data.dart';
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

  static Future<List<ImageUploadData>?> uploadFiles(
    List<File> files,
    List<String> names,
    WidgetRef ref,
  ) async {
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
              publicId: names[index].split('/').sublist(1).toString(),
              uniqueFilename: false,
              overwrite: true,
              folder: names[index].split('/').first,
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

      List<ImageUploadData> urls = [];

      for (final r in response) {
        if (r != null && r.rawResponse != null) {
          final uploadData = jsonDecode(r.rawResponse!);
          urls.add(
            ImageUploadData(
              url: uploadData['secure_url'],
              width: uploadData['width'],
              height: uploadData['height'],
              aspectRatio: uploadData['width'] / uploadData['height'],
            ),
          );
        }
      }
      return urls;
    } catch (err) {
      return null;
    }
  }
}
