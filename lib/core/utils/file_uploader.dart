import 'dart:io';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
// ignore: implementation_imports
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/model/upload_progress.dart';
import 'package:hey_buddy/core/riverpod/upload_progress_provider.dart';
import 'package:hey_buddy/keys.dart';

enum FileType { image, video }

class FileUploader {
  static final cloudinary = Cloudinary.fromStringUrl(
    'cloudinary://$cloudinaryApiKey:$cloudinaryApiSecret@$cloudinaryCloudName',
  );

  FileUploader._() {
    cloudinary.config.urlConfig.secure = true;
  }

  static Future<void> uploadFiles(
    List<File> files,
    FileType type,
    WidgetRef ref,
  ) async {
    final uploadNotifier = ref.read(uploadProgressProvider.notifier);
    Map<int, UploadProgress> uploadProgress = {};
    final response = await Future.wait(
      files.asMap().entries.map((entry) async {
        int index = entry.key;
        File file = entry.value;
        return cloudinary.uploader().upload(
          file,
          params: UploadParams(
            publicId: '${type.name}/${file.path}',
            uniqueFilename: false,
            overwrite: true,
            useFilename: true,
          ),
          completion: (response) {
            print(response.rawResponse);
          },
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
            print(progress);
            uploadNotifier.updateProgress(progress);
          },
        );
      }),
    );

    for (final x in response) {
      print(x?.rawResponse);
      print(x?.responseCode);
    }
  }
}
