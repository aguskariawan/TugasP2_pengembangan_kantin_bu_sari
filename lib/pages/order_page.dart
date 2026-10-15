import 'package:flutter/material.dart';
import '../state/cart_state.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_image.dart';
import '../widgets/order_history_sheet.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final CartState _cartState = CartState();
  final TextEditingController _voucherController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tableController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController.text = _cartState.customerName;
    _tableController.text = _cartState.tableNumber;
    _notesController.text = _cartState.generalNotes;
    if (_cartState.appliedVoucherCode != null) {
      _voucherController.text = _cartState.appliedVoucherCode!;
    }
  }

  @override
  void dispose() {
    _voucherController.dispose();
    _nameController.dispose();
    _tableController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _applyVoucher() {
    final code = _voucherController.text.trim();
    if (code.isEmpty) return;

    final success = _cartState.applyVoucher(code);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voucher "$code" berhasil digunakan! Hemat ${_cartState.formattedDiscount}'),
          backgroundColor: Colors.green.shade800,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode voucher tidak valid. Coba "BUSARIHEMAT" atau "MAHASISWA"'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showOrderSuccessReceipt() {
    // Record this completed order into CartState orderHistory
    final orderRecord = _cartState.checkoutCurrentOrder();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Success Icon Animation
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green.shade300, width: 2),
                ),
                child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 44),
              ),
              const SizedBox(height: 14),

              const Text(
                'Pesanan Berhasil Diterima!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Dapur Bu Sari sedang menyiapkan hidangan lezatmu.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 20),

              // Receipt Ticket Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.lightBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.lightBorder),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Nomor Pesanan', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                        Text(
                          orderRecord.orderId,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Pemesan', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                        Text(orderRecord.customerName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tipe Pesanan', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                        Text(orderRecord.diningDescription, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Metode Bayar', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                        Text(
                          orderRecord.paymentMethodDescription,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Pembayaran', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        Text(
                          orderRecord.formattedTotal,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.textPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // QR Code representation
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.lightBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.qr_code_2_rounded, size: 36, color: AppTheme.darkBackground),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Tunjukkan QR ke Kasir', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Text('Untuk verifikasi atau pembayaran tunai', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Actions
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close sheet
                    Navigator.popUntil(context, (route) => route.isFirst); // return to menu
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.darkBackground,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Kembali ke Daftar Menu', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _cartState,
      builder: (context, _) {
        final items = _cartState.items;

        return Scaffold(
          backgroundColor: AppTheme.lightBackground,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            title: const Text(
              'Keranjang & Checkout',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            actions: [
              IconButton(
                onPressed: () => OrderHistorySheet.show(context),
                icon: Badge(
                  isLabelVisible: _cartState.orderHistory.isNotEmpty,
                  label: Text(
                    '${_cartState.orderHistory.length}',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: AppTheme.accentGold,
                  child: const Icon(Icons.receipt_long_rounded, color: AppTheme.textPrimary, size: 22),
                ),
                tooltip: 'Riwayat Pesanan',
              ),
              if (items.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Kosongkan Keranjang?'),
                        content: const Text('Semua menu yang telah Anda pilih akan dihapus dari daftar pesanan.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                          TextButton(
                            onPressed: () {
                              _cartState.clearCart();
                              Navigator.pop(ctx);
                            },
                            child: const Text('Kosongkan', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_sweep_outlined, size: 18, color: Colors.redAccent),
                  label: const Text('Hapus', style: TextStyle(color: Colors.redAccent, fontSize: 13)),
                ),
            ],
          ),
          body: items.isEmpty
              ? _buildEmptyCartView()
              : Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                    children: [
                      // Section 1: Dining Option (Dine-in vs Takeaway)
                      _buildDiningOptionSection(),
                      const SizedBox(height: 14),

                      // Section 2: Items List
                      _buildOrderItemsSection(items),
                      const SizedBox(height: 14),

                      // Section 3: Cutlery Toggle
                      _buildCutleryPreference(),
                      const SizedBox(height: 14),

                      // Section 4: Voucher / Promo
                      _buildVoucherSection(),
                      const SizedBox(height: 14),

                      // Section 5: Payment Method
                      _buildPaymentMethodSection(),
                      const SizedBox(height: 14),

                      // Section 6: Order Summary Price Breakdown
                      _buildOrderSummarySection(),
                    ],
                  ),
                ),
          bottomSheet: items.isEmpty ? null : _buildCheckoutBottomBar(),
        );
      },
    );
  }

  Widget _buildEmptyCartView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.lightBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: const Icon(
                Icons.remove_shopping_cart_outlined,
                size: 64,
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Keranjang Masih Kosong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Perut lapar? Pilih menu masakan khas Bu Sari yang nikmat sekarang juga!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.restaurant_menu_rounded, size: 18),
              label: const Text('Jelajahi Menu Sekarang'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.darkBackground,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiningOptionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tipe & Lokasi Pesanan',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 12),
          // Segmented Button
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<DiningOption>(
              segments: const [
                ButtonSegment(
                  value: DiningOption.dineIn,
                  label: Text('Makan di Tempat (Dine-in)'),
                  icon: Icon(Icons.table_restaurant_rounded, size: 16),
                ),
                ButtonSegment(
                  value: DiningOption.takeAway,
                  label: Text('Bungkus (Takeaway)'),
                  icon: Icon(Icons.shopping_bag_outlined, size: 16),
                ),
              ],
              selected: {_cartState.diningOption},
              onSelectionChanged: (newSelection) {
                _cartState.setDiningOption(newSelection.first);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppTheme.darkBackground;
                  }
                  return Colors.white;
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return AppTheme.textPrimary;
                }),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Inputs based on dining option
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Pemesan',
                    hintText: 'Nama kamu',
                    prefixIcon: Icon(Icons.person_outline, size: 20),
                  ),
                  onChanged: (val) => _cartState.setCustomerName(val),
                ),
              ),
              if (_cartState.diningOption == DiningOption.dineIn) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _tableController,
                    decoration: const InputDecoration(
                      labelText: 'Nomor Meja',
                      hintText: 'Contoh: Meja 12',
                      prefixIcon: Icon(Icons.pin_outlined, size: 20),
                    ),
                    onChanged: (val) => _cartState.setTableNumber(val),
                  ),
                ),
              ],
            ],
          ),

          if (_cartState.diningOption == DiningOption.dineIn) ...[
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Meja 01', 'Meja 04', 'Meja 08', 'Meja 12', 'Meja 15', 'Area Outdoor'].map((t) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ActionChip(
                      label: Text(t, style: const TextStyle(fontSize: 11)),
                      backgroundColor: _tableController.text == t ? AppTheme.darkBackground : Colors.grey.shade100,
                      labelStyle: TextStyle(
                        color: _tableController.text == t ? Colors.white : AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      onPressed: () {
                        setState(() {
                          _tableController.text = t;
                          _cartState.setTableNumber(t);
                        });
                      },
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderItemsSection(List<dynamic> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Menu (${_cartState.totalItemCount})',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                const Text(
                  'Geser untuk hapus',
                  style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
            itemBuilder: (context, index) {
              final item = items[index];

              return Dismissible(
                key: Key(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red.shade600,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 26),
                ),
                onDismissed: (direction) {
                  _cartState.removeItem(item.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.menuItem.name} dihapus dari pesanan'),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CustomImage(
                          imageUrl: item.menuItem.imageUrl,
                          width: 65,
                          height: 65,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.menuItem.name,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Porsi: ${item.portion}${item.spicyLevel > 0 ? " • Level ${item.spicyLevel} 🌶️" : ""}',
                              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                            ),
                            if (item.selectedAddOns.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  '+ ${item.selectedAddOns.map((e) => e.name).join(", ")}',
                                  style: const TextStyle(fontSize: 10.5, color: AppTheme.accentGold),
                                ),
                              ),
                            if (item.notes.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  'Catatan: "${item.notes}"',
                                  style: const TextStyle(fontSize: 10.5, fontStyle: FontStyle.italic, color: AppTheme.textMuted),
                                ),
                              ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.formattedTotalPrice,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                // Quantity Stepper
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.lightBackground,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppTheme.lightBorder),
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () => _cartState.decrementQuantity(item.id),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                          child: Icon(Icons.remove, size: 14),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                        child: Text(
                                          '${item.quantity}',
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => _cartState.incrementQuantity(item.id),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                          child: Icon(Icons.add, size: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCutleryPreference() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.lightBorder),
      ),
      child: SwitchListTile(
        title: const Text(
          'Sertakan Sendok & Alat Makan',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        subtitle: const Text(
          'Dukung kelestarian lingkungan jika Anda telah memiliki alat makan.',
          style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
        ),
        activeThumbColor: AppTheme.darkBackground,
        value: _cartState.needCutlery,
        onChanged: (val) => _cartState.setNeedCutlery(val),
      ),
    );
  }

  Widget _buildVoucherSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.confirmation_number_outlined, size: 18, color: AppTheme.accentGold),
                  SizedBox(width: 6),
                  Text(
                    'Voucher Promo Diskon',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                ],
              ),
              if (_cartState.appliedVoucherCode != null)
                TextButton(
                  onPressed: () {
                    _voucherController.clear();
                    _cartState.removeVoucher();
                  },
                  child: const Text('Hapus', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: TextField(
                    controller: _voucherController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Masukkan kode voucher',
                      hintStyle: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      fillColor: AppTheme.lightBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppTheme.lightBorder),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _applyVoucher,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.darkBackground,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  minimumSize: const Size(0, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Terapkan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Suggested codes
          Wrap(
            spacing: 8,
            children: [
              ActionChip(
                label: const Text('BUSARIHEMAT (-Rp 5rb)', style: TextStyle(fontSize: 10)),
                backgroundColor: AppTheme.lightBackground,
                onPressed: () {
                  _voucherController.text = 'BUSARIHEMAT';
                  _applyVoucher();
                },
              ),
              ActionChip(
                label: const Text('MAHASISWA (-10%)', style: TextStyle(fontSize: 10)),
                backgroundColor: AppTheme.lightBackground,
                onPressed: () {
                  _voucherController.text = 'MAHASISWA';
                  _applyVoucher();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Metode Pembayaran',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 12),
          _buildPaymentOptionTile(
            method: PaymentMethod.qris,
            title: 'QRIS / Dompet Digital',
            subtitle: 'GoPay, OVO, Dana, ShopeePay, BCA QR',
            badgeText: 'Instan Bebas Antre',
            icon: Icons.qr_code_scanner_rounded,
          ),
          const SizedBox(height: 8),
          _buildPaymentOptionTile(
            method: PaymentMethod.cash,
            title: 'Tunai di Kasir Bu Sari',
            subtitle: 'Bayar langsung saat mengambil pesanan',
            icon: Icons.payments_outlined,
          ),
          const SizedBox(height: 8),
          _buildPaymentOptionTile(
            method: PaymentMethod.bankTransfer,
            title: 'Transfer Bank / Virtual Account',
            subtitle: 'BCA, Mandiri, BRI, BNI Virtual Account',
            icon: Icons.account_balance_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptionTile({
    required PaymentMethod method,
    required String title,
    required String subtitle,
    required IconData icon,
    String? badgeText,
  }) {
    final isSelected = _cartState.paymentMethod == method;

    return InkWell(
      onTap: () => _cartState.setPaymentMethod(method),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black.withValues(alpha: 0.03) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.darkBackground : AppTheme.lightBorder,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.darkBackground : AppTheme.lightBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : AppTheme.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      if (badgeText != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.green.shade200, width: 0.5),
                          ),
                          child: Text(
                            badgeText,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppTheme.darkBackground : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppTheme.darkBackground,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummarySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rincian Pembayaran',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal (${_cartState.totalItemCount} Menu)', style: const TextStyle(fontSize: 12.5, color: AppTheme.textSecondary)),
              Text(_cartState.formattedSubtotal, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Biaya Layanan & Kebersihan (5%)', style: TextStyle(fontSize: 12.5, color: AppTheme.textSecondary)),
              Text(_cartState.formattedTax, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
            ],
          ),
          if (_cartState.voucherDiscount > 0) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Diskon Voucher ', style: TextStyle(fontSize: 12.5, color: Colors.green, fontWeight: FontWeight.w600)),
                    Text('(${_cartState.appliedVoucherCode})', style: const TextStyle(fontSize: 11, color: Colors.green)),
                  ],
                ),
                Text('- ${_cartState.formattedDiscount}', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
          ],
          const Divider(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pembayaran',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              Text(
                _cartState.formattedFinalTotal,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: AppTheme.lightBorder)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Tagihan', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                Text(
                  _cartState.formattedFinalTotal,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 18),
            Expanded(
              child: ElevatedButton(
                onPressed: _showOrderSuccessReceipt,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.darkBackground,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline_rounded, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Pesan Sekarang',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
