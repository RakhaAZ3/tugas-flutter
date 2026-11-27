class WardrobeItem {
  final int id;
  final int outfitId;
  final String title;
  final double? price;
  final String? color;
  final String? notes;
  final String? imageUrl;

  WardrobeItem({
    required this.id,
    required this.outfitId,
    required this.title,
    this.price,
    this.color,
    this.notes,
    this.imageUrl,
  });

  factory WardrobeItem.fromJson(Map<String, dynamic> json) {
    return WardrobeItem(
      id: json['id'],
      outfitId: json['outfit_id'],
      title: json['title'],
      price: json['price'] == null
          ? null
          : double.parse(json['price'].toString()),
      color: json['color'],
      notes: json['notes'],
      imageUrl: json['image_url'],
    );
  }
}