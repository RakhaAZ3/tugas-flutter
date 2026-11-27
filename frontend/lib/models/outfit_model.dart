
class Outfit {
  final int id;
  final String name;
  final int wardrobeItemsCount;

  Outfit({
    required this.id,
    required this.name,
    this.wardrobeItemsCount = 0,
  });

  factory Outfit.fromJson(Map<String, dynamic> json) {
    return Outfit(
      id: json['id'],
      name: json['name'],
      wardrobeItemsCount: json['wardrobe_items_count'] ?? 0,
    );
  }
}
