abstract class MyPosts {
  final List<String> myPosts;
  final List<String> likedPosts;
  final List<String> dislikedPosts;
  MyPosts({
    required this.myPosts,
    required this.likedPosts,
    required this.dislikedPosts,
  });
}

abstract class MyVideos {
  final List<String> myVideos;
  final List<String> likedVideos;
  final List<String> dislikedVideos;
  MyVideos({
    required this.myVideos,
    required this.likedVideos,
    required this.dislikedVideos,
  });
}
