/*
{
asset_id: d9004f91dbba4e119994c4e62fb2aee2, 
public_id: clip/0BHzS0VBMeY8YsaXJwnh2N5Fpfv2/5f07b560-cd17-4539-b3b6-3952e657b380/97129fdd-61b4-4a85-b3d0-2a2b0656d41d, 
version: 1780675142, version_id: e9313877bafb7bdd742d1fedeaec1458, 
signature: 65178552de2b042ec196e998e0854fda75838263,
width: 864, height: 1920, format: mp4, resource_type: video, 
created_at: 2026-06-05T15:59:02Z, tags: [], pages: 0, bytes: 2408510, type: upload, 
etag: 3491cfbf78ae5273b97756795acfedd5, placeholder: false,
url: http://res.cloudinary.com/hey-buddy/video/upload/v1780675142/clip/0BHzS0VBMeY8YsaXJwnh2N5Fpfv2/5f07b560-cd17-4539-b3b6-3952e657b380/97129fdd-61b4-4a85-b3d0-2a2b0656d41d.mp4,
secure_url: https://res.cloudinary.com/hey-buddy/video/upload/v1780675142/clip/0BHzS0VBMeY8YsaXJwnh2N5Fpfv2/5f07b560-cd17-4539-b3b6-3952e657b380/97129fdd-61b4-4a85-b3d0-2a2b0656d41d.mp4, playback_url: https://res.cloudinary.com/hey-buddy/video/upload/sp_auto/v1780675142/clip/0BHzS0VBMeY8YsaXJwnh2N5Fpfv2/5f07b560-cd17-4539-b3b6-3952e657b380/97129fdd-61b4-4a85-b3d0-2a2b0656d41d.m3u8, asset_folder: clip/0BHzS0VBMeY8YsaXJwnh2N5Fpfv2/5f07b560-cd17-4539-b3b6-3952e657b380,
display_name: 97129fdd-61b4-4a85-b3d0-2a2b0656d41d, 
audio: {codec: aac, bit_rate: 260781, frequency: 44100, channels: 1, channel_layout: mono}, 
video: {pix_format: yuvj420p, codec: hevc, level: 153, profile: Main, bit_rate: 1916451, time_base: 1/90000}, is_audio: false, frame_rate: 90000.0, bit_rate: 2175266, duration: 8.812, rotation: 0, nb_frames: 736, original_filename: 1000059619, api_key: 859426117493374}
*/

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
