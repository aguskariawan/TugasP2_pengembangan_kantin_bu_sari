import '../models/menu_item.dart';

class PromoBanner {
  final String title;
  final String subtitle;
  final String tag;
  final String imageUrl;

  const PromoBanner({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.imageUrl,
  });
}

class DummyData {
  static const List<String> categories = [
    'Semua',
    'Makanan Berat',
    'Cemilan & Gorengan',
    'Minuman Segar',
    'Minuman Hangat',
    'Paket Hemat',
  ];

  static const List<PromoBanner> banners = [
    PromoBanner(
      title: 'Diskon Spesial 20%',
      subtitle: 'Paket Nasi Geprek + Es Teh Jumbo hanya Rp 21.000',
      tag: 'PROMO HARI INI',
      imageUrl:
          'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?auto=format&fit=crop&w=800&q=80',
    ),
    PromoBanner(
      title: 'Ayam Geprek Sambal Bawang',
      subtitle: 'Sensasi pedas nagih dengan ayam renyah Bu Sari',
      tag: 'BEST SELLER',
      imageUrl:
          'https://images.unsplash.com/photo-1562967914-608f82629710?auto=format&fit=crop&w=800&q=80',
    ),
    PromoBanner(
      title: 'Cemilan Mendoan Hangat',
      subtitle: 'Gurih, renyah di luar lembut di dalam dengan sambal kecap',
      tag: 'FAVORIT KAMPUS',
      imageUrl:
          'https://images.unsplash.com/photo-1541544741938-0af808871cc0?auto=format&fit=crop&w=800&q=80',
    ),
  ];

  static const List<AddOnItem> commonFoodAddOns = [
    AddOnItem(id: 'add_egg', name: 'Telur Dadar / Ceplok', price: 4000),
    AddOnItem(id: 'add_rice', name: 'Ekstra Nasi Putih', price: 3000),
    AddOnItem(id: 'add_crackers', name: 'Kerupuk Kaleng (2 pcs)', price: 2000),
    AddOnItem(id: 'add_sambal', name: 'Ekstra Sambal Bawang', price: 3000),
    AddOnItem(id: 'add_tempe', name: 'Tempe Goreng Tepung', price: 2500),
  ];

  static const List<AddOnItem> drinkAddOns = [
    AddOnItem(id: 'add_jelly', name: 'Grass Jelly / Cincau', price: 2000),
    AddOnItem(id: 'add_less_sugar', name: 'Less Sugar / Rendah Gula', price: 0),
    AddOnItem(id: 'add_extra_ice', name: 'Ekstra Es Batu', price: 1000),
  ];

  static const List<MenuItem> menuItems = [
    MenuItem(
      id: 'm1',
      name: 'Nasi Ayam Geprek Sambal Bawang',
      description:
          'Ayam krispi gurih digeprek bersama sambal bawang pedas segar khas Bu Sari. Disajikan dengan nasi hangat dan lalapan ketimun.',
      price: 18000,
      originalPrice: 22000,
      category: 'Makanan Berat',
      imageUrl:
          'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?auto=format&fit=crop&w=800&q=80',
      rating: 4.9,
      reviewCount: 342,
      isBestSeller: true,
      isPromo: true,
      spicyLevelAvailable: true,
      defaultSpicyLevel: 2,
      availablePortions: ['Reguler', 'Jumbo', 'Ayam Saja (Tanpa Nasi)'],
      portionExtraPrice: {
        'Reguler': 0,
        'Jumbo': 5000,
        'Ayam Saja (Tanpa Nasi)': -3000,
      },
      availableAddOns: commonFoodAddOns,
      prepTimeMinutes: 12,
    ),
    MenuItem(
      id: 'm2',
      name: 'Nasi Goreng Spesial Kantin',
      description:
          'Nasi goreng dengan bumbu racikan tradisional, suwiran ayam, sosis, bakso, acar segar, dan kerupuk renyah.',
      price: 20000,
      category: 'Makanan Berat',
      imageUrl:
          'https://images.unsplash.com/photo-1603133872878-684f208fb84b?auto=format&fit=crop&w=800&q=80',
      rating: 4.8,
      reviewCount: 215,
      isBestSeller: true,
      spicyLevelAvailable: true,
      defaultSpicyLevel: 1,
      availablePortions: ['Reguler', 'Jumbo'],
      portionExtraPrice: {'Reguler': 0, 'Jumbo': 6000},
      availableAddOns: commonFoodAddOns,
      prepTimeMinutes: 15,
    ),
    MenuItem(
      id: 'm3',
      name: 'Soto Ayam Lamongan Kuah Koya',
      description:
          'Soto ayam kuah kuning gurih beraroma rempah dengan taburan koya gurih, suwiran ayam, bihun, kubis, dan seledri.',
      price: 17000,
      category: 'Makanan Berat',
      imageUrl:
          'https://images.unsplash.com/photo-1541832676-9b763b0239ab?auto=format&fit=crop&w=800&q=80',
      rating: 4.7,
      reviewCount: 180,
      availablePortions: ['Porsi Sedang', 'Porsi Jumbo'],
      portionExtraPrice: {'Porsi Sedang': 0, 'Porsi Jumbo': 4000},
      availableAddOns: commonFoodAddOns,
      prepTimeMinutes: 10,
    ),
    MenuItem(
      id: 'm4',
      name: 'Mie Dok-Dok Kuah Nyemek Telur',
      description:
          'Mie telur dimasak kuah kental gurih dengan telur orak-arik, sayuran sawi hijau, tomat, dan taburan bawang goreng.',
      price: 15000,
      category: 'Makanan Berat',
      imageUrl:
          'https://images.unsplash.com/photo-1612927601601-6638404737ce?auto=format&fit=crop&w=800&q=80',
      rating: 4.8,
      reviewCount: 164,
      spicyLevelAvailable: true,
      defaultSpicyLevel: 2,
      availablePortions: ['Reguler', 'Jumbo'],
      portionExtraPrice: {'Reguler': 0, 'Jumbo': 4000},
      availableAddOns: commonFoodAddOns,
      prepTimeMinutes: 12,
    ),
    MenuItem(
      id: 'm5',
      name: 'Ayam Bakar Madu Manis Gurih',
      description:
          'Ayam bakar empuk dibalur saus madu kecap rempah, dipanggang wangi dengan aroma arang menggugah selera.',
      price: 23000,
      category: 'Makanan Berat',
      imageUrl:
          'https://images.unsplash.com/photo-1598515214211-89d3c73ae83b?auto=format&fit=crop&w=800&q=80',
      rating: 4.9,
      reviewCount: 290,
      isBestSeller: true,
      availablePortions: ['Reguler', 'Jumbo'],
      portionExtraPrice: {'Reguler': 0, 'Jumbo': 6000},
      availableAddOns: commonFoodAddOns,
      prepTimeMinutes: 18,
    ),
    MenuItem(
      id: 'm6',
      name: 'Tempe Mendoan Purwokerto (Isi 3)',
      description:
          'Tempe kedelai berbalut adonan tepung daun bawang gurih setengah matang, disajikan dengan kecap rawit pedas manis.',
      price: 10000,
      category: 'Cemilan & Gorengan',
      imageUrl:
          'https://images.unsplash.com/photo-1541544741938-0af808871cc0?auto=format&fit=crop&w=800&q=80',
      rating: 4.9,
      reviewCount: 312,
      isBestSeller: true,
      availablePortions: ['Porsi Biasa (3 pcs)', 'Porsi Ramean (6 pcs)'],
      portionExtraPrice: {
        'Porsi Biasa (3 pcs)': 0,
        'Porsi Ramean (6 pcs)': 8000,
      },
      availableAddOns: [
        AddOnItem(
          id: 'add_kecap_rawit',
          name: 'Ekstra Sambal Kecap Rawit',
          price: 2000,
        ),
      ],
      prepTimeMinutes: 8,
    ),
    MenuItem(
      id: 'm7',
      name: 'Bakwan Sayur Krispi (Isi 4)',
      description:
          'Bakwan sayur renyah garing dengan wortel, kubis, dan tauge segar. Cocok dinikmati saat hangat dengan cabai rawit hijau.',
      price: 8000,
      category: 'Cemilan & Gorengan',
      imageUrl:
          'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=800&q=80',
      rating: 4.6,
      reviewCount: 140,
      availablePortions: ['Porsi Satuan', 'Porsi Jumbo (Isi 8)'],
      portionExtraPrice: {'Porsi Satuan': 0, 'Porsi Jumbo (Isi 8)': 7000},
      prepTimeMinutes: 8,
    ),
    MenuItem(
      id: 'm8',
      name: 'Pisang Goreng Keju Coklat Lumer',
      description:
          'Pisang raja manis digoreng tepung krispi keemasan, ditaburi limpahan keju cheddar parut dan susu cokelat manis kental.',
      price: 13000,
      category: 'Cemilan & Gorengan',
      imageUrl:
          'https://images.unsplash.com/photo-1587314168485-3236d6710814?auto=format&fit=crop&w=800&q=80',
      rating: 4.8,
      reviewCount: 185,
      isPromo: true,
      originalPrice: 15000,
      availablePortions: ['Reguler', 'Double Cheese & Choco'],
      portionExtraPrice: {'Reguler': 0, 'Double Cheese & Choco': 4000},
      prepTimeMinutes: 10,
    ),
    MenuItem(
      id: 'm9',
      name: 'Es Teh Manis Jumbo Segar',
      description:
          'Teh tubruk melati khas wangi pekat diseduh segar, disajikan dengan es batu melimpah dalam gelas jumbo penawar dahaga.',
      price: 5000,
      category: 'Minuman Segar',
      imageUrl:
          'https://images.unsplash.com/photo-1556679343-c7306c1976bc?auto=format&fit=crop&w=800&q=80',
      rating: 4.9,
      reviewCount: 520,
      isBestSeller: true,
      availablePortions: ['Gelas Reguler', 'Gelas Jumbo 1 Liter'],
      portionExtraPrice: {'Gelas Reguler': 0, 'Gelas Jumbo 1 Liter': 2000},
      availableAddOns: drinkAddOns,
      prepTimeMinutes: 4,
    ),
    MenuItem(
      id: 'm10',
      name: 'Es Jeruk Peras Segar Asli',
      description:
          'Jeruk peras manis alami segar tanpa perisa buatan, dipadu es batu kristal sejuk menyegarkan.',
      price: 8000,
      category: 'Minuman Segar',
      imageUrl:
          'https://images.unsplash.com/photo-1613478223719-2ab802602423?auto=format&fit=crop&w=800&q=80',
      rating: 4.7,
      reviewCount: 175,
      availablePortions: ['Reguler', 'Jumbo'],
      portionExtraPrice: {'Reguler': 0, 'Jumbo': 3000},
      availableAddOns: drinkAddOns,
      prepTimeMinutes: 5,
    ),
    MenuItem(
      id: 'm11',
      name: 'Jus Alpukat Kocok Coklat Milo',
      description:
          'Alpukat mentega legit dikocok creamy dengan susu kental manis dan taburan bubuk Milo melimpah.',
      price: 15000,
      category: 'Minuman Segar',
      imageUrl:
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80',
      rating: 4.8,
      reviewCount: 198,
      isBestSeller: true,
      availablePortions: ['Reguler', 'Extra Cup Creamy'],
      portionExtraPrice: {'Reguler': 0, 'Extra Cup Creamy': 4000},
      prepTimeMinutes: 6,
    ),
    MenuItem(
      id: 'm12',
      name: 'Wedang Jahe Susu Hangat',
      description:
          'Rebusan jahe emprit geprek alami dipadu susu kental manis, menghangatkan tubuh dan melegakan tenggorokan.',
      price: 10000,
      category: 'Minuman Hangat',
      imageUrl:
          'https://images.unsplash.com/photo-1544787219-7f47ccb76574?auto=format&fit=crop&w=800&q=80',
      rating: 4.8,
      reviewCount: 92,
      availablePortions: ['Cangkir Sedang', 'Mug Besar'],
      portionExtraPrice: {'Cangkir Sedang': 0, 'Mug Besar': 3000},
      prepTimeMinutes: 5,
    ),
    MenuItem(
      id: 'm13',
      name: 'Paket Hemat Geprek + Es Teh Jumbo',
      description:
          'Pilihan paling favorit mahasiswa! Nasi Ayam Geprek Sambal Bawang + Es Teh Manis Jumbo hemat berkantong.',
      price: 21000,
      originalPrice: 25000,
      category: 'Paket Hemat',
      imageUrl:
          'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?auto=format&fit=crop&w=800&q=80',
      rating: 5.0,
      reviewCount: 420,
      isBestSeller: true,
      isPromo: true,
      spicyLevelAvailable: true,
      defaultSpicyLevel: 2,
      availablePortions: ['Paket Reguler', 'Paket Jumbo Ekstra Ayam'],
      portionExtraPrice: {'Paket Reguler': 0, 'Paket Jumbo Ekstra Ayam': 6000},
      availableAddOns: commonFoodAddOns,
      prepTimeMinutes: 14,
    ),
    MenuItem(
      id: 'm14',
      name: 'Paket Nasi Goreng + Mendoan + Es Jeruk',
      description:
          'Lengkap dan kenyang! Nasi Goreng Spesial, 2 pcs Mendoan hangat, dan 1 gelas Es Jeruk Peras Segar.',
      price: 28000,
      originalPrice: 35000,
      category: 'Paket Hemat',
      imageUrl:
          'https://images.unsplash.com/photo-1603133872878-684f208fb84b?auto=format&fit=crop&w=800&q=80',
      rating: 4.9,
      reviewCount: 230,
      isPromo: true,
      spicyLevelAvailable: true,
      defaultSpicyLevel: 1,
      availablePortions: ['Paket Kenyang', 'Paket Super Kenyang'],
      portionExtraPrice: {'Paket Kenyang': 0, 'Paket Super Kenyang': 5000},
      availableAddOns: commonFoodAddOns,
      prepTimeMinutes: 16,
    ),
  ];
}
