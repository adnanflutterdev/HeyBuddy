class MediaMeta {
  final int width;
  final int height;
  final String url;
  final String? thumbnail;
  final double aspectRatio;

  MediaMeta({
    required this.url,
    required this.width,
    required this.height,
    required this.aspectRatio,
    this.thumbnail,
  });

  factory MediaMeta.fromFirebase(Map<String, dynamic> imageData) {
    return MediaMeta(
      url: imageData['url'],
      width: imageData['width'],
      height: imageData['height'],
      aspectRatio: imageData['aspectRatio'],
      thumbnail: imageData['thumbnail'],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'url': url,
      'width': width,
      'height': height,
      'aspectRatio': aspectRatio,
      'thumbnail': thumbnail,
    };
  }
}
