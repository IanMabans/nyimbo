class Hymn {
  final String name;
  final int number;
  final String assetPath;
  final int id;
  bool isFavorite;
  final String content;

  Hymn({
    required this.id,
    required this.name,
    required this.number,
    required this.assetPath,
    this.isFavorite = false,
    required this.content,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}
