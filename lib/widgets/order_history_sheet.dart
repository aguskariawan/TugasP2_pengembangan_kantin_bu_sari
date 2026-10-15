import 'package:flutter/material.dart';
import '../models/order_record.dart';
import '../state/cart_state.dart';
import '../theme/app_theme.dart';

class OrderHistorySheet extends StatelessWidget {
  const OrderHistorySheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const OrderHistorySheet(),
    );
  }

  void _showReceiptDetail(BuildContext context, OrderRecord record) {
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
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Struk Digital Pesanan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                record.orderTime.toString().substring(0, 16),
                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 16),
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
                        Text(record.orderId, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Pemesan', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                        Text(record.customerName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tipe Pesanan', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                        Text(record.diningDescription, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Metode Bayar', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                        Text(record.paymentMethodDescription, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const Divider(height: 16),
                    // Items
                    ...record.items.map((it) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${it.quantity}x ${it.menuItem.name} (${it.portion})',
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(it.formattedTotalPrice, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        )),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Pembayaran', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        Text(
                          record.formattedTotal,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.textPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.darkBackground,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Tutup'),
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
    final cartState = CartState();

    return ListenableBuilder(
      listenable: cartState,
      builder: (context, _) {
        final orders = cartState.orderHistory;

        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.receipt_long_rounded, color: AppTheme.darkBackground, size: 22),
                          const SizedBox(width: 8),
                          const Text(
                            'Riwayat Pesanan',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.lightBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.lightBorder),
                        ),
                        child: Text(
                          '${orders.length} Transaksi',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Expanded(
                    child: orders.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.history_rounded, size: 48, color: AppTheme.textMuted),
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  'Belum Ada Riwayat Pesanan',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Pesanan yang Anda selesaikan akan tercatat di sini.',
                                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            controller: scrollController,
                            itemCount: orders.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final record = orders[index];
                              return Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppTheme.lightBorder),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.02),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          record.orderId,
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.4),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.amber.shade50,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: Colors.amber.shade300, width: 0.6),
                                          ),
                                          child: Text(
                                            record.status,
                                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber.shade900),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      record.formattedTime,
                                      style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      record.items.map((e) => '${e.quantity}x ${e.menuItem.name}').join(', '),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          record.formattedTotal,
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppTheme.textPrimary),
                                        ),
                                        InkWell(
                                          onTap: () => _showReceiptDetail(context, record),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                            child: Row(
                                              children: [
                                                Text('Lihat Struk', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.accentGold)),
                                                SizedBox(width: 4),
                                                Icon(Icons.chevron_right_rounded, size: 16, color: AppTheme.accentGold),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
