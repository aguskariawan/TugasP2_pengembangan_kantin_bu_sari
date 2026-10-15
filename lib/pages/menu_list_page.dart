import 'dart:async';
import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/menu_item.dart';
import '../state/cart_state.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_image.dart';
import '../widgets/order_history_sheet.dart';

class MenuListPage extends StatefulWidget {
  const MenuListPage({super.key});

  @override
  State<MenuListPage> createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  final CartState _cartState = CartState();
  final TextEditingController _searchController = TextEditingController();
  final PageController _bannerController = PageController();

  String _selectedCategory = 'Semua';
  String _sortBy = 'popular';
  bool _isGridView = true;
  int _currentBannerIndex = 0;
  Timer? _bannerTimer;

  // Filter sheet states
  RangeValues _priceRange = const RangeValues(0, 40000);
  bool _onlyPromo = false;
  bool _onlyBestSeller = false;

  @override
  void initState() {
    super.initState();
    _startBannerTimer();
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerController.hasClients) {
        final nextPage = (_currentBannerIndex + 1) % DummyData.banners.length;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<MenuItem> get _filteredMenuItems {
    return DummyData.menuItems.where((item) {
      // Category filter
      if (_selectedCategory != 'Semua' && item.category != _selectedCategory) {
        return false;
      }

      // Search query filter
      final query = _searchController.text.trim().toLowerCase();
      if (query.isNotEmpty) {
        final matchesName = item.name.toLowerCase().contains(query);
        final matchesDesc = item.description.toLowerCase().contains(query);
        if (!matchesName && !matchesDesc) return false;
      }

      // Price filter
      if (item.price < _priceRange.start || item.price > _priceRange.end) {
        return false;
      }

      // Promo filter
      if (_onlyPromo && !item.isPromo) return false;

      // Best Seller filter
      if (_onlyBestSeller && !item.isBestSeller) return false;

      return true;
    }).toList()
      ..sort((a, b) {
        if (_sortBy == 'price_low') {
          return a.price.compareTo(b.price);
        } else if (_sortBy == 'price_high') {
          return b.price.compareTo(a.price);
        } else if (_sortBy == 'rating') {
          return b.rating.compareTo(a.rating);
        } else {
          // Popular (rating & review count combined)
          return (b.rating * b.reviewCount).compareTo(a.rating * a.reviewCount);
        }
      });
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter & Urutkan Menu',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _priceRange = const RangeValues(0, 40000);
                            _onlyPromo = false;
                            _onlyBestSeller = false;
                          });
                          setState(() {});
                        },
                        child: const Text('Reset', style: TextStyle(color: AppTheme.accentGold)),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'Rentang Harga (Rp)',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 40000,
                    divisions: 8,
                    activeColor: AppTheme.darkBackground,
                    inactiveColor: Colors.grey.shade200,
                    labels: RangeLabels(
                      'Rp ${_priceRange.start.toInt()}',
                      'Rp ${_priceRange.end.toInt()}',
                    ),
                    onChanged: (values) {
                      setModalState(() => _priceRange = values);
                      setState(() {});
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Rp ${_priceRange.start.toInt()}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      Text('Rp ${_priceRange.end.toInt()}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Hanya Menu Promo Diskon', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    activeThumbColor: AppTheme.accentGold,
                    value: _onlyPromo,
                    onChanged: (val) {
                      setModalState(() => _onlyPromo = val);
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Hanya Menu Best Seller', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    activeThumbColor: AppTheme.accentGold,
                    value: _onlyBestSeller,
                    onChanged: (val) {
                      setModalState(() => _onlyBestSeller = val);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.darkBackground,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Terapkan Filter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _cartState,
      builder: (context, _) {
        final items = _filteredMenuItems;

        return Scaffold(
          backgroundColor: AppTheme.lightBackground,
          appBar: _buildAppBar(),
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // Search & Quick Filter
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: _buildSearchBar(),
                    ),
                  ),

                  // Promo Carousel Banner
                  SliverToBoxAdapter(
                    child: _buildBannerCarousel(),
                  ),

                  // Category Selector Chips
                  SliverToBoxAdapter(
                    child: _buildCategoryChips(),
                  ),

                  // Results Header & Sort/View Controls
                  SliverToBoxAdapter(
                    child: _buildResultControls(items.length),
                  ),

                  // Menu Items (Grid or List)
                  items.isEmpty
                      ? SliverToBoxAdapter(child: _buildEmptyState())
                      : _isGridView
                          ? SliverPadding(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                              sliver: SliverGrid(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 14,
                                  crossAxisSpacing: 14,
                                  childAspectRatio: 0.68,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => _buildMenuGridCard(items[index]),
                                  childCount: items.length,
                                ),
                              ),
                            )
                          : SliverPadding(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => _buildMenuListCard(items[index]),
                                  childCount: items.length,
                                ),
                              ),
                            ),
                ],
              ),

              // Persistent Floating Cart Bottom Bar
              if (_cartState.totalItemCount > 0)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: _buildFloatingCartBar(),
                ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.darkBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.restaurant_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'KANTIN BU SARI',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        'Buka • ${_cartState.diningOption == DiningOption.dineIn ? _cartState.tableNumber : "Bungkus (Takeaway)"}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/pesan');
          },
          icon: Badge(
            isLabelVisible: _cartState.totalItemCount > 0,
            label: Text(
              '${_cartState.totalItemCount}',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppTheme.darkBackground,
            child: const Icon(Icons.shopping_bag_outlined, color: AppTheme.textPrimary, size: 24),
          ),
          tooltip: 'Lihat Keranjang Pesanan',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.lightBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Cari ayam geprek, nasi goreng, es teh...',
                hintStyle: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textSecondary, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18, color: AppTheme.textSecondary),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: _openFilterBottomSheet,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: (_onlyPromo || _onlyBestSeller || _priceRange.start > 0 || _priceRange.end < 40000)
                  ? AppTheme.darkBackground
                  : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.lightBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.tune_rounded,
              color: (_onlyPromo || _onlyBestSeller || _priceRange.start > 0 || _priceRange.end < 40000)
                  ? Colors.white
                  : AppTheme.textPrimary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (index) {
              setState(() => _currentBannerIndex = index);
            },
            itemCount: DummyData.banners.length,
            itemBuilder: (context, index) {
              final banner = DummyData.banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: AppTheme.darkCardGradient,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Background Image with gradient overlay
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(18)),
                          child: ShaderMask(
                            shaderCallback: (rect) {
                              return const LinearGradient(
                                colors: [Colors.transparent, Colors.black],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(rect);
                            },
                            blendMode: BlendMode.dstIn,
                            child: CustomImage(
                              imageUrl: banner.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Text Info
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.accentGold,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                banner.tag,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              banner.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 190,
                              child: Text(
                                banner.subtitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  height: 1.25,
                                ),
                              ),
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
        ),
        const SizedBox(height: 8),
        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            DummyData.banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentBannerIndex == index ? 18 : 6,
              height: 5,
              decoration: BoxDecoration(
                color: _currentBannerIndex == index ? AppTheme.darkBackground : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: DummyData.categories.map((category) {
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedCategory = category);
                }
              },
              selectedColor: AppTheme.darkBackground,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12,
              ),
              side: BorderSide(
                color: isSelected ? AppTheme.darkBackground : AppTheme.lightBorder,
                width: 1,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              showCheckmark: false,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildResultControls(int resultCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Daftar Menu ($resultCount)',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sort Dropdown
              Container(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.lightBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _sortBy,
                    icon: const Icon(Icons.arrow_drop_down, size: 18),
                    style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary, fontWeight: FontWeight.w500),
                    onChanged: (val) {
                      if (val != null) setState(() => _sortBy = val);
                    },
                    items: const [
                      DropdownMenuItem(value: 'popular', child: Text('Terpopuler')),
                      DropdownMenuItem(value: 'price_low', child: Text('Termurah')),
                      DropdownMenuItem(value: 'price_high', child: Text('Termahal')),
                      DropdownMenuItem(value: 'rating', child: Text('Rating')),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // View switcher: Grid vs List
              Container(
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.lightBorder),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => setState(() => _isGridView = true),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _isGridView ? AppTheme.darkBackground : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.grid_view_rounded,
                          size: 16,
                          color: _isGridView ? Colors.white : AppTheme.textMuted,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => _isGridView = false),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: !_isGridView ? AppTheme.darkBackground : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.view_list_rounded,
                          size: 16,
                          color: !_isGridView ? Colors.white : AppTheme.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGridCard(MenuItem item) {
    final isFav = _cartState.isFavorite(item.id);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: item);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.lightBorder, width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Overlays
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Hero(
                    tag: 'menu_image_${item.id}',
                    child: CustomImage(
                      imageUrl: item.imageUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: () => _cartState.toggleFavorite(item.id),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : AppTheme.textPrimary,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                // Promo / Best Seller Badge
                if (item.isPromo)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.badgePromo,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'PROMO',
                        style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                else if (item.isBestSeller)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.darkBackground,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'BEST',
                        style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),

            // Card Body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rating & prep time
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppTheme.accentGold, size: 15),
                        const SizedBox(width: 3),
                        Text(
                          '${item.rating}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' (${item.reviewCount})',
                          style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                        ),
                        const Spacer(),
                        if (item.spicyLevelAvailable)
                          const Icon(Icons.local_fire_department_rounded, color: Colors.deepOrange, size: 14),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Title
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const Spacer(),
                    // Price & Quick Add Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (item.originalPrice != null)
                              Text(
                                item.formattedOriginalPrice,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.textMuted,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              item.formattedPrice,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        // Quick Add (+) Button
                        InkWell(
                          onTap: () {
                            _cartState.addItem(
                              menuItem: item,
                              quantity: 1,
                              portion: item.availablePortions.first,
                              spicyLevel: item.defaultSpicyLevel,
                            );
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item.name} ditambahkan ke pesanan'),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                backgroundColor: AppTheme.darkBackground,
                                action: SnackBarAction(
                                  label: 'Lihat',
                                  textColor: AppTheme.accentGold,
                                  onPressed: () => Navigator.pushNamed(context, '/pesan'),
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppTheme.darkBackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildMenuListCard(MenuItem item) {
    final isFav = _cartState.isFavorite(item.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.lightBorder, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/detail', arguments: item),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Hero(
                  tag: 'menu_image_list_${item.id}',
                  child: CustomImage(
                    imageUrl: item.imageUrl,
                    width: 85,
                    height: 85,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (item.isPromo)
                          Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppTheme.badgePromo,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'PROMO',
                              style: TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold),
                            ),
                          ),
                        Expanded(
                          child: Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => _cartState.toggleFavorite(item.id),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : AppTheme.textMuted,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.2),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              item.formattedPrice,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            if (item.originalPrice != null) ...[
                              const SizedBox(width: 6),
                              Text(
                                item.formattedOriginalPrice,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.textMuted,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _cartState.addItem(
                              menuItem: item,
                              quantity: 1,
                              portion: item.availablePortions.first,
                              spicyLevel: item.defaultSpicyLevel,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item.name} ditambahkan'),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: AppTheme.darkBackground,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.darkBackground,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: const Size(0, 32),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Tambah', style: TextStyle(fontSize: 11, color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_off_rounded, size: 48, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 16),
            const Text(
              'Menu Tidak Ditemukan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 6),
            const Text(
              'Coba ubah kata kunci pencarian atau sesuaikan filter rentang harga Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _selectedCategory = 'Semua';
                  _priceRange = const RangeValues(0, 40000);
                  _onlyPromo = false;
                  _onlyBestSeller = false;
                });
              },
              child: const Text('Reset Pencarian & Filter'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingCartBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.darkBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_cartState.totalItemCount} Menu Dipilih',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
                Text(
                  _cartState.formattedSubtotal,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/pesan');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentGold,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Row(
              children: [
                Text('Lihat Pesanan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
