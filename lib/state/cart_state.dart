import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';
import '../models/order_record.dart';

enum DiningOption { dineIn, takeAway }

enum PaymentMethod { qris, cash, bankTransfer, kantinPay }

class CartState extends ChangeNotifier {
  static final CartState _instance = CartState._internal();
  factory CartState() => _instance;
  CartState._internal();

  final List<CartItem> _items = [];
  final List<OrderRecord> _orderHistory = [];
  final Set<String> _favoriteIds = {'m1', 'm9'}; // Default favorite items

  DiningOption _diningOption = DiningOption.dineIn;
  PaymentMethod _paymentMethod = PaymentMethod.qris;
  String _customerName = 'Budi Santoso';
  String _tableNumber = 'Meja 12';
  String _generalNotes = '';
  bool _needCutlery = true;
  String? _appliedVoucherCode;
  double _voucherDiscount = 0.0;

  // Getters
  List<CartItem> get items => List.unmodifiable(_items);
  List<OrderRecord> get orderHistory => List.unmodifiable(_orderHistory);
  Set<String> get favoriteIds => _favoriteIds;
  DiningOption get diningOption => _diningOption;
  PaymentMethod get paymentMethod => _paymentMethod;
  String get customerName => _customerName;
  String get tableNumber => _tableNumber;
  String get generalNotes => _generalNotes;
  bool get needCutlery => _needCutlery;
  String? get appliedVoucherCode => _appliedVoucherCode;
  double get voucherDiscount => _voucherDiscount;

  int get totalItemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  bool isFavorite(String menuItemId) => _favoriteIds.contains(menuItemId);

  void toggleFavorite(String menuItemId) {
    if (_favoriteIds.contains(menuItemId)) {
      _favoriteIds.remove(menuItemId);
    } else {
      _favoriteIds.add(menuItemId);
    }
    notifyListeners();
  }

  void setDiningOption(DiningOption option) {
    _diningOption = option;
    notifyListeners();
  }

  void setPaymentMethod(PaymentMethod method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void setCustomerName(String name) {
    _customerName = name;
    notifyListeners();
  }

  void setTableNumber(String table) {
    _tableNumber = table;
    notifyListeners();
  }

  void setGeneralNotes(String notes) {
    _generalNotes = notes;
    notifyListeners();
  }

  void setNeedCutlery(bool value) {
    _needCutlery = value;
    notifyListeners();
  }

  void addItem({
    required MenuItem menuItem,
    int quantity = 1,
    String portion = 'Reguler',
    int spicyLevel = 0,
    List<AddOnItem> selectedAddOns = const [],
    String notes = '',
  }) {
    // Check if matching item already exists in cart
    final existingIndex = _items.indexWhere((item) =>
        item.menuItem.id == menuItem.id &&
        item.portion == portion &&
        item.spicyLevel == spicyLevel &&
        _areAddOnsEqual(item.selectedAddOns, selectedAddOns) &&
        item.notes == notes);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      final newItem = CartItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        menuItem: menuItem,
        quantity: quantity,
        portion: portion,
        spicyLevel: spicyLevel,
        selectedAddOns: selectedAddOns,
        notes: notes,
      );
      _items.add(newItem);
    }
    notifyListeners();
  }

  void incrementQuantity(String cartItemId) {
    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      _items[index].quantity += 1;
      notifyListeners();
    }
  }

  void decrementQuantity(String cartItemId) {
    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity -= 1;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeItem(String cartItemId) {
    _items.removeWhere((item) => item.id == cartItemId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _appliedVoucherCode = null;
    _voucherDiscount = 0.0;
    notifyListeners();
  }

  /// Converts active cart items into an official OrderRecord in order history
  OrderRecord checkoutCurrentOrder({String? customOrderId}) {
    final orderId = customOrderId ?? 'KBS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final record = OrderRecord(
      orderId: orderId,
      orderTime: DateTime.now(),
      items: List.from(_items),
      subtotal: subtotal,
      tax: taxAndService,
      discount: _voucherDiscount,
      totalAmount: finalTotal,
      diningOption: _diningOption,
      tableNumber: _tableNumber,
      customerName: _customerName.isNotEmpty ? _customerName : 'Pelanggan',
      paymentMethod: _paymentMethod,
      status: 'Sedang Disiapkan',
    );

    _orderHistory.insert(0, record);
    clearCart();
    return record;
  }

  bool applyVoucher(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'BUSARIHEMAT') {
      _appliedVoucherCode = 'BUSARIHEMAT';
      _voucherDiscount = 5000.0;
      notifyListeners();
      return true;
    } else if (cleanCode == 'MAHASISWA') {
      _appliedVoucherCode = 'MAHASISWA';
      _voucherDiscount = (subtotal * 0.1).clamp(0, 10000.0);
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeVoucher() {
    _appliedVoucherCode = null;
    _voucherDiscount = 0.0;
    notifyListeners();
  }

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get taxAndService => subtotal > 0 ? (subtotal * 0.05) : 0.0; // 5% Pb1 / Service

  double get finalTotal => (subtotal + taxAndService - _voucherDiscount).clamp(0.0, double.infinity);

  String formatCurrency(double amount) {
    return 'Rp ${amount.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  String get formattedSubtotal => formatCurrency(subtotal);
  String get formattedTax => formatCurrency(taxAndService);
  String get formattedDiscount => formatCurrency(_voucherDiscount);
  String get formattedFinalTotal => formatCurrency(finalTotal);

  static bool _areAddOnsEqual(List<AddOnItem> a, List<AddOnItem> b) {
    if (a.length != b.length) return false;
    final aIds = a.map((e) => e.id).toSet();
    final bIds = b.map((e) => e.id).toSet();
    return aIds.containsAll(bIds);
  }
}
