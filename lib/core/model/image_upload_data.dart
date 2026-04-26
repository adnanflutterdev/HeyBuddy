class ImageUploadData {
  final String url;
  final int width;
  final int height;
  final double aspectRatio;

  ImageUploadData({
    required this.url,
    required this.width,
    required this.height,
    required this.aspectRatio,
  });

  factory ImageUploadData.fromFirebase(Map<String, dynamic> imageData) {
    return ImageUploadData(
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
