import 'cart_item.dart';
import '../state/cart_state.dart';

class OrderRecord {
  final String orderId;
  final DateTime orderTime;
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double discount;
  final double totalAmount;
  final DiningOption diningOption;
  final String tableNumber;
  final String customerName;
  final PaymentMethod paymentMethod;
  final String status; // 'Sedang Disiapkan', 'Siap Diambil', 'Selesai'

  OrderRecord({
    required this.orderId,
    required this.orderTime,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.totalAmount,
    required this.diningOption,
    required this.tableNumber,
    required this.customerName,
    required this.paymentMethod,
    this.status = 'Sedang Disiapkan',
  });

  String get formattedTotal => 'Rp ${totalAmount.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      )}';

  String get formattedTime {
    final hour = orderTime.hour.toString().padLeft(2, '0');
    final minute = orderTime.minute.toString().padLeft(2, '0');
    final day = orderTime.day.toString().padLeft(2, '0');
    final month = orderTime.month.toString().padLeft(2, '0');
    return '$day/$month/${orderTime.year} • $hour:$minute WIB';
  }

  String get diningDescription => diningOption == DiningOption.dineIn
      ? 'Makan di Tempat ($tableNumber)'
      : 'Bungkus (Takeaway)';

  String get paymentMethodDescription {
    switch (paymentMethod) {
      case PaymentMethod.qris:
        return 'QRIS / E-Wallet';
      case PaymentMethod.cash:
        return 'Tunai (Kasir)';
      case PaymentMethod.bankTransfer:
        return 'Transfer Bank';
      case PaymentMethod.kantinPay:
        return 'KantinPay';
    }
  }
}
