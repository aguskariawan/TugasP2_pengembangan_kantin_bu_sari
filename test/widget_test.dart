import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app1/main.dart';
import 'package:app1/data/dummy_data.dart';
import 'package:app1/state/cart_state.dart';

void main() {
  setUp(() {
    CartState().clearCart();
  });

  testWidgets('Kantin Bu Sari - Unit and Widget Integration Test', (WidgetTester tester) async {
    // Configure mobile phone viewport (e.g. 412 x 915)
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const KantinBuSariApp());
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Brand title & Header
    expect(find.text('KANTIN BU SARI'), findsOneWidget);

    // Verify Search bar
    expect(find.byType(TextField), findsWidgets);

    // Verify Category chips
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Makanan Berat'), findsOneWidget);
    expect(find.text('Minuman Segar'), findsOneWidget);

    // Verify Promo Tag
    expect(find.text('PROMO HARI INI'), findsOneWidget);

    // Test CartState logic
    final cartState = CartState();
    expect(cartState.totalItemCount, 0);

    // Add item programmatically to verify state and cart calculations
    cartState.addItem(
      menuItem: DummyData.menuItems.first,
      quantity: 2,
      portion: 'Reguler',
      spicyLevel: 2,
    );

    expect(cartState.totalItemCount, 2);
    expect(cartState.subtotal, 36000.0);
    expect(cartState.taxAndService, 1800.0);

    // Test voucher discount
    final voucherApplied = cartState.applyVoucher('BUSARIHEMAT');
    expect(voucherApplied, isTrue);
    expect(cartState.voucherDiscount, 5000.0);
    expect(cartState.finalTotal, 32800.0);

    // Test dining options and payment methods
    cartState.setDiningOption(DiningOption.takeAway);
    expect(cartState.diningOption, DiningOption.takeAway);

    cartState.setPaymentMethod(PaymentMethod.qris);
    expect(cartState.paymentMethod, PaymentMethod.qris);

    // Re-pump to verify UI reflects cart state
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Lihat Pesanan'), findsOneWidget);

    // Test checkout into order history
    final completedRecord = cartState.checkoutCurrentOrder();
    expect(cartState.totalItemCount, 0);
    expect(cartState.orderHistory.length, 1);
    expect(cartState.orderHistory.first.orderId, completedRecord.orderId);
    expect(cartState.orderHistory.first.totalAmount, 32800.0);
  });
}
