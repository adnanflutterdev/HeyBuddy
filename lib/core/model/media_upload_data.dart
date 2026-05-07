class MediaUploadData {
  final String url;
  final int width;
  final int height;
  final double aspectRatio;

  MediaUploadData({
    required this.url,
    required this.width,
    required this.height,
    required this.aspectRatio,
  });

  factory MediaUploadData.fromFirebase(Map<String, dynamic> imageData) {
    return MediaUploadData(
      url: imageData['url'],
      width: imageData['width'],
      height: imageData['height'],
      aspectRatio: imageData['aspectRatio'],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'url': url,
      'width': width,
      'height': height,
      'aspectRatio': aspectRatio,
    };
  }
}
