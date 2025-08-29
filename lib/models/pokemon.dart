// -------- Models --------
class PokemonItem {
  final int id;
  final String name;
  final String imageUrl;

  PokemonItem({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
      };

  factory PokemonItem.fromJson(Map<String, dynamic> json) => PokemonItem(
        id: json['id'],
        name: json['name'],
        imageUrl: json['imageUrl'],
      );

  // เพื่อให้ .contains() ใช้ id ในการเปรียบเทียบ
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}