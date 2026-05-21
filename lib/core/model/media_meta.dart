class MediaMeta {
  final String url;
  final int width;
  final int height;
  final double aspectRatio;

  MediaMeta({
    required this.url,
    required this.width,
    required this.height,
    required this.aspectRatio,
  });

  factory MediaMeta.fromFirebase(Map<String, dynamic> imageData) {
    return MediaMeta(
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
