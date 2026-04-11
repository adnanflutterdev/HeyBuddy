class UploadProgress {
  final int total;
  final int uploaded;

  UploadProgress({this.total = 0, this.uploaded = 0});

  UploadProgress copyWith({int? total, int? uploaded}) {
    return UploadProgress(
      total: total ?? this.total,
      uploaded: uploaded ?? this.uploaded,
    );
  }
}
