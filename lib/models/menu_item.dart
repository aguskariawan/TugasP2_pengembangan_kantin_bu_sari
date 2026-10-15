class AddOnItem {
  final String id;
  final String name;
  final double price;

  const AddOnItem({
    required this.id,
    required this.name,
    required this.price,
  });
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final bool isBestSeller;
  final bool isPromo;
  final bool spicyLevelAvailable;
  final int defaultSpicyLevel;
  final List<String> availablePortions;
  final Map<String, double> portionExtraPrice;
  final List<AddOnItem> availableAddOns;
  final int prepTimeMinutes;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.category,
    required this.imageUrl,
    this.rating = 4.8,
    this.reviewCount = 120,
    this.isBestSeller = false,
    this.isPromo = false,
    this.spicyLevelAvailable = false,
    this.defaultSpicyLevel = 0,
    this.availablePortions = const ['Reguler', 'Jumbo'],
    this.portionExtraPrice = const {'Reguler': 0.0, 'Jumbo': 5000.0},
    this.availableAddOns = const [],
    this.prepTimeMinutes = 15,
  });

  String get formattedPrice => 'Rp ${price.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      )}';

  String get formattedOriginalPrice => originalPrice == null
      ? ''
      : 'Rp ${originalPrice!.toInt().toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          )}';
}
