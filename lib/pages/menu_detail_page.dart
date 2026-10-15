import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/menu_item.dart';
import '../state/cart_state.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_image.dart';

class MenuDetailPage extends StatefulWidget {
  const MenuDetailPage({super.key});

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  final CartState _cartState = CartState();
  final TextEditingController _notesController = TextEditingController();

  MenuItem? _item;
  late String _selectedPortion;
  late int _spicyLevel;
  final Set<String> _selectedAddOnIds = {};
  int _quantity = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_item == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is MenuItem) {
        _item = args;
      } else {
        // Fallback to first dummy item if accessed directly
        _item = DummyData.menuItems.first;
      }
      _selectedPortion = _item!.availablePortions.first;
      _spicyLevel = _item!.defaultSpicyLevel;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double get _calculateUnitPrice {
    if (_item == null) return 0;
    double price = _item!.price;
    if (_item!.portionExtraPrice.containsKey(_selectedPortion)) {
      price += _item!.portionExtraPrice[_selectedPortion]!;
    }
    for (final addon in _item!.availableAddOns) {
      if (_selectedAddOnIds.contains(addon.id)) {
        price += addon.price;
      }
    }
    return price;
  }

  double get _calculateTotalPrice => _calculateUnitPrice * _quantity;

  String _formatRupiah(double amount) {
    return 'Rp ${amount.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  String _getSpicyDescription(int level) {
    switch (level) {
      case 0:
        return 'Level 0 • Tanpa Pedas (Aman untuk lambung)';
      case 1:
        return 'Level 1 • Pedas Manis Santai';
      case 2:
        return 'Level 2 • Pedas Pas Khas Kantin (Rekomendasi)';
      case 3:
        return 'Level 3 • Ekstra Pedas Bikin Melek';
      case 4:
        return 'Level 4 • Pedas Nendang Menggelegar';
      case 5:
        return 'Level 5 • Pedas Sultan Maksimal!';
      default:
        return 'Level $level';
    }
  }

  void _onAddToCart() {
    if (_item == null) return;

    final selectedAddOnsList = _item!.availableAddOns
        .where((addon) => _selectedAddOnIds.contains(addon.id))
        .toList();

    _cartState.addItem(
      menuItem: _item!,
      quantity: _quantity,
      portion: _selectedPortion,
      spicyLevel: _item!.spicyLevelAvailable ? _spicyLevel : 0,
      selectedAddOns: selectedAddOnsList,
      notes: _notesController.text.trim(),
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_quantity x ${_item!.name} berhasil dipesan'),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppTheme.darkBackground,
        action: SnackBarAction(
          label: 'Ke Pembayaran',
          textColor: AppTheme.accentGold,
          onPressed: () {
            Navigator.pushNamed(context, '/pesan');
          },
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_item == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final item = _item!;

    return ListenableBuilder(
      listenable: _cartState,
      builder: (context, _) {
        final isFav = _cartState.isFavorite(item.id);

        return Scaffold(
          backgroundColor: AppTheme.lightBackground,
          body: CustomScrollView(
            slivers: [
              // Hero App Bar with Image & Overlay
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                elevation: 0,
                backgroundColor: AppTheme.darkBackground,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withValues(alpha: 0.6),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.6),
                      child: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.white,
                          size: 20,
                        ),
                        onPressed: () => _cartState.toggleFavorite(item.id),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.6),
                      child: IconButton(
                        icon: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tautan menu disalin ke clipboard!'),
                              duration: Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'menu_image_${item.id}',
                        child: CustomImage(
                          imageUrl: item.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Top gradient for app bar buttons readability
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 90,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      // Bottom subtle gradient overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, AppTheme.lightBackground],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Detail Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge tags & Category
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.darkBackground,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.category.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          if (item.isPromo) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.badgePromo,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'PROMO SPESIAL',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          if (item.isBestSeller) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.accentGold,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'BEST SELLER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Title & Base Price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (item.originalPrice != null)
                                Text(
                                  item.formattedOriginalPrice,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textMuted,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              Text(
                                item.formattedPrice,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Rating & Prep Time Bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.lightBorder),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: AppTheme.accentGold, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  '${item.rating}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                Text(
                                  ' (${item.reviewCount} ulasan)',
                                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                                ),
                              ],
                            ),
                            Container(width: 1, height: 18, color: AppTheme.lightBorder),
                            Row(
                              children: [
                                const Icon(Icons.schedule_rounded, color: AppTheme.textSecondary, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  '± ${item.prepTimeMinutes} Menit Siap',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description
                      const Text(
                        'Deskripsi Menu',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.description,
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Section: Pilihan Porsi (SegmentedButton)
                      _buildPortionSection(item),
                      const SizedBox(height: 20),

                      // Section: Level Pedas (Slider)
                      if (item.spicyLevelAvailable) ...[
                        _buildSpicyLevelSection(),
                        const SizedBox(height: 20),
                      ],

                      // Section: Pilihan Topping & Add-ons (CheckboxListTile)
                      if (item.availableAddOns.isNotEmpty) ...[
                        _buildAddOnsSection(item),
                        const SizedBox(height: 20),
                      ],

                      // Section: Catatan Pesanan (TextField)
                      _buildNotesSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Bar for Quantity & Add to Cart
          bottomSheet: _buildBottomActionSheet(),
        );
      },
    );
  }

  Widget _buildPortionSection(MenuItem item) {
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
              const Text(
                'Pilihan Porsi',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Wajib Pilih 1', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Segmented Button
          SegmentedButton<String>(
            segments: item.availablePortions.map((portion) {
              final extra = item.portionExtraPrice[portion] ?? 0;
              final extraText = extra > 0
                  ? ' (+${_formatRupiah(extra)})'
                  : extra < 0
                      ? ' (${_formatRupiah(extra)})'
                      : '';
              return ButtonSegment<String>(
                value: portion,
                label: Text(
                  '$portion$extraText',
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                ),
              );
            }).toList(),
            selected: {_selectedPortion},
            onSelectionChanged: (newSelection) {
              setState(() {
                _selectedPortion = newSelection.first;
              });
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
        ],
      ),
    );
  }

  Widget _buildSpicyLevelSection() {
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
              Row(
                children: [
                  const Icon(Icons.local_fire_department_rounded, color: Colors.deepOrange, size: 20),
                  const SizedBox(width: 6),
                  const Text(
                    'Tingkat Kepedasan',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Level $_spicyLevel',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _getSpicyDescription(_spicyLevel),
            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          // Interactive Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.deepOrange,
              inactiveTrackColor: Colors.grey.shade200,
              thumbColor: Colors.deepOrange,
              overlayColor: Colors.deepOrange.withValues(alpha: 0.2),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: _spicyLevel.toDouble(),
              min: 0,
              max: 5,
              divisions: 5,
              label: 'Level $_spicyLevel',
              onChanged: (val) {
                setState(() => _spicyLevel = val.toInt());
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('0 (Tidak Pedas)', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
              Text('3 (Pedas)', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
              Text('5 (Maksimal)', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddOnsSection(MenuItem item) {
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Topping & Tambahan (Opsional)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                Text(
                  '${_selectedAddOnIds.length} dipilih',
                  style: const TextStyle(fontSize: 11, color: AppTheme.accentGold, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const Divider(),
          ...item.availableAddOns.map((addon) {
            final isChecked = _selectedAddOnIds.contains(addon.id);
            return CheckboxListTile(
              title: Text(
                addon.name,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                addon.price == 0 ? 'Gratis' : '+ ${_formatRupiah(addon.price)}',
                style: TextStyle(
                  fontSize: 12,
                  color: addon.price == 0 ? Colors.green : AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              value: isChecked,
              activeColor: AppTheme.darkBackground,
              checkColor: Colors.white,
              dense: true,
              controlAffinity: ListTileControlAffinity.trailing,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedAddOnIds.add(addon.id);
                  } else {
                    _selectedAddOnIds.remove(addon.id);
                  }
                });
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
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
          const Row(
            children: [
              Icon(Icons.edit_note_rounded, color: AppTheme.textSecondary, size: 20),
              SizedBox(width: 6),
              Text(
                'Catatan untuk Dapur Bu Sari',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            maxLines: 2,
            maxLength: 100,
            decoration: InputDecoration(
              hintText: 'Contoh: Nasi dipisah, jangan pakai timun, es sedikit...',
              hintStyle: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
              fillColor: AppTheme.lightBackground,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppTheme.lightBorder),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionSheet() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: AppTheme.lightBorder, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Stepper Quantity
            Container(
              decoration: BoxDecoration(
                color: AppTheme.lightBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.lightBorder),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_rounded, size: 18),
                    color: _quantity > 1 ? AppTheme.textPrimary : AppTheme.textMuted,
                    onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                  ),
                  Text(
                    '$_quantity',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_rounded, size: 18),
                    color: AppTheme.textPrimary,
                    onPressed: () => setState(() => _quantity++),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Dynamic Add to Cart Button
            Expanded(
              child: ElevatedButton(
                onPressed: _onAddToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.darkBackground,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Pesan • ${_formatRupiah(_calculateTotalPrice)}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
