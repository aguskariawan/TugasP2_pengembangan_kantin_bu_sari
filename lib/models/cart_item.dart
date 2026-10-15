import 'menu_item.dart';

class CartItem {
  final String id;
  final MenuItem menuItem;
  int quantity;
  final String portion;
  final int spicyLevel;
  final List<AddOnItem> selectedAddOns;
  final String notes;

  CartItem({
    required this.id,
    required this.menuItem,
    this.quantity = 1,
    this.portion = 'Reguler',
    this.spicyLevel = 0,
    this.selectedAddOns = const [],
    this.notes = '',
  });

  double get unitPrice {
    double total = menuItem.price;
    if (menuItem.portionExtraPrice.containsKey(portion)) {
      total += menuItem.portionExtraPrice[portion]!;
    }
    for (final addon in selectedAddOns) {
      total += addon.price;
    }
    return total;
  }

  double get totalPrice => unitPrice * quantity;

  String get formattedTotalPrice => 'Rp ${totalPrice.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      )}';

  String get formattedUnitPrice => 'Rp ${unitPrice.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      )}';

  CartItem copyWith({
    String? id,
    MenuItem? menuItem,
    int? quantity,
    String? portion,
    int? spicyLevel,
    List<AddOnItem>? selectedAddOns,
    String? notes,
  }) {
    return CartItem(
      id: id ?? this.id,
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      portion: portion ?? this.portion,
      spicyLevel: spicyLevel ?? this.spicyLevel,
      selectedAddOns: selectedAddOns ?? List.from(this.selectedAddOns),
      notes: notes ?? this.notes,
    );
  }
}
