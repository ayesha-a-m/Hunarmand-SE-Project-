import 'product_detail.dart';
import 'cart.dart';
import 'package:flutter/material.dart';

// ── Translations Map ─────────────────────────────────────────────────────────
const Map<String, Map<String, String>> _translations = {
  'English': {
    'appName': 'Artisan Marketplace',
    'subtitle': 'Discover handmade treasures',
    'search': 'Search products...',
    'addToCart': 'Add to Cart',
    'browseProducts': 'Browse Products',
    'courses': 'Courses',
    'switchToSeller': 'Switch to Seller',
    'all': 'All',
    'textiles': 'Textiles',
    'jewelry': 'Jewelry',
    'pottery': 'Pottery',
    'baskets': 'Baskets',
    'art': 'Art',
  },
  'Urdu': {
    'appName': 'دستکار بازار',
    'subtitle': 'ہاتھ سے بنی اشیاء دریافت کریں',
    'search': 'مصنوعات تلاش کریں...',
    'addToCart': 'ٹوکری میں ڈالیں',
    'browseProducts': 'مصنوعات دیکھیں',
    'courses': 'کورسز',
    'switchToSeller': 'بیچنے والے پر جائیں',
    'all': 'سب',
    'textiles': 'کپڑے',
    'jewelry': 'زیورات',
    'pottery': 'مٹی کے برتن',
    'baskets': 'ٹوکریاں',
    'art': 'فن',
  },
  'Punjabi': {
    'appName': 'دستکار بازار',
    'subtitle': 'ਹੱਥਾਂ ਨਾਲ ਬਣੀਆਂ ਚੀਜ਼ਾਂ ਲੱਭੋ',
    'search': 'ਉਤਪਾਦ ਖੋਜੋ...',
    'addToCart': 'ਕਾਰਟ ਵਿੱਚ ਪਾਓ',
    'browseProducts': 'ਉਤਪਾਦ ਵੇਖੋ',
    'courses': 'ਕੋਰਸ',
    'switchToSeller': 'ਵੇਚਣ ਵਾਲੇ ਕੋਲ ਜਾਓ',
    'all': 'ਸਭ',
    'textiles': 'ਕੱਪੜੇ',
    'jewelry': 'ਗਹਿਣੇ',
    'pottery': 'ਮਿੱਟੀ ਦੇ ਭਾਂਡੇ',
    'baskets': 'ਟੋਕਰੀਆਂ',
    'art': 'ਕਲਾ',
  },
  'Sindhi': {
    'appName': 'هنرمند بازار',
    'subtitle': 'هٿ سان ٺهيل شيون ڳوليو',
    'search': 'شيون ڳوليو...',
    'addToCart': 'ٽوڪري ۾ وجھو',
    'browseProducts': 'شيون ڏسو',
    'courses': 'ڪورس',
    'switchToSeller': 'وڪرو ڪندڙ ڏانهن وڃو',
    'all': 'سڀ',
    'textiles': 'ڪپڙو',
    'jewelry': 'زيور',
    'pottery': 'مٽيءَ جا ڀانڊا',
    'baskets': 'ٽوڪريون',
    'art': 'فن',
  },
};

// RTL languages
const _rtlLanguages = {'Urdu', 'Sindhi', 'Punjabi'};

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _selectedNavIndex = 0;
  String _selectedCategory = 'all';
  String _selectedLanguage = 'English';
  bool _showLanguageDropdown = false;

  final List<String> _categoryKeys = [
    'all',
    'textiles',
    'jewelry',
    'pottery',
    'baskets',
    'art',
  ];

  final List<Map<String, String>> _products = [
    {
      'categoryKey': 'textiles',
      'name': 'Embroidered Shawl',
      'price': 'Rs. 3,500',
      'seller': 'Fatima Ahmed',
      'image': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
    },
    {
      'categoryKey': 'jewelry',
      'name': 'Silver Turquoise Set',
      'price': 'Rs. 5,000',
      'seller': 'Zainab Hussain',
      'image': 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400',
    },
    {
      'categoryKey': 'pottery',
      'name': 'Clay Water Pot',
      'price': 'Rs. 1,500',
      'seller': 'Nadia Malik',
      'image': 'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=400',
    },
    {
      'categoryKey': 'textiles',
      'name': 'Embroidered Cushion',
      'price': 'Rs. 800',
      'seller': 'Fatima Ahmed',
      'image': 'https://images.unsplash.com/photo-1597843786411-a7fa8ad44a95?w=400',
    },
    {
      'categoryKey': 'baskets',
      'name': 'Woven Basket',
      'price': 'Rs. 1,200',
      'seller': 'Amna Bibi',
      'image': 'https://images.unsplash.com/photo-1595981267035-7b04ca84a82d?w=400',
    },
    {
      'categoryKey': 'jewelry',
      'name': 'Brass Bangles',
      'price': 'Rs. 600',
      'seller': 'Rukhsana Khan',
      'image': 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?w=400',
    },
  ];

  // ── Helpers ───────────────────────────────────────────────
  String t(String key) =>
      _translations[_selectedLanguage]?[key] ??
      _translations['English']![key]!;

  bool get isRtl => _rtlLanguages.contains(_selectedLanguage);

  List<Map<String, String>> get _filteredProducts {
    if (_selectedCategory == 'all') return _products;
    return _products
        .where((p) => p['categoryKey'] == _selectedCategory)
        .toList();
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFEDEDED),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(),
                  _buildSearchBar(),
                  _buildCategoryChips(),
                  Expanded(child: _buildProductGrid()),
                ],
              ),
              if (_showLanguageDropdown)
                GestureDetector(
                  onTap: () =>
                      setState(() => _showLanguageDropdown = false),
                  child: Container(color: Colors.transparent),
                ),
              if (_showLanguageDropdown)
                Positioned(
                  top: 56,
                  right: isRtl ? null : 46,
                  left: isRtl ? 46 : null,
                  child: _buildLanguageDropdown(),
                ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF7A9B76),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white54, width: 1.5),
            ),
            child: const Icon(Icons.spa, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t('appName'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  t('subtitle'),
                  style:
                      const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          // Translate icon — highlighted when non-English
          GestureDetector(
            onTap: () => setState(
                () => _showLanguageDropdown = !_showLanguageDropdown),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _selectedLanguage != 'English'
                    ? Colors.white.withOpacity(0.25)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.translate,
                  color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 4),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined,
                    color: Colors.white, size: 22),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartScreen(
                        selectedLanguage: _selectedLanguage,
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Language Dropdown ─────────────────────────────────────
  Widget _buildLanguageDropdown() {
    final languages = [
      {'key': 'English', 'native': 'English'},
      {'key': 'Urdu', 'native': 'اردو'},
      {'key': 'Punjabi', 'native': 'ਪੰਜਾਬੀ'},
      {'key': 'Sindhi', 'native': 'سنڌي'},
    ];

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: Container(
          width: 200,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((lang) {
              final isSelected = _selectedLanguage == lang['key'];
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedLanguage = lang['key']!;
                    _showLanguageDropdown = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  color: isSelected
                      ? const Color(0xFF7A9B76).withOpacity(0.1)
                      : Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lang['key']!,
                        style: TextStyle(
                          fontSize: 15,
                          color: isSelected
                              ? const Color(0xFF7A9B76)
                              : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                      Text(
                        lang['native']!,
                        style: TextStyle(
                          fontSize: 15,
                          color: isSelected
                              ? const Color(0xFF7A9B76)
                              : Colors.black54,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ── Search Bar ────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: TextField(
        textDirection:
            isRtl ? TextDirection.rtl : TextDirection.ltr,
        decoration: InputDecoration(
          hintText: t('search'),
          hintStyle:
              const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon:
              const Icon(Icons.search, color: Colors.grey, size: 20),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ── Category Chips ────────────────────────────────────────
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: _categoryKeys.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final key = _categoryKeys[index];
          final isSelected = key == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF7A9B76)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                t(key),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: 13,
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Product Grid ──────────────────────────────────────────
  Widget _buildProductGrid() {
    final products = _filteredProducts;
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.63,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) =>
          _buildProductCard(products[index]),
    );
  }

  Widget _buildProductCard(Map<String, String> product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(
              product: {
                ...product,
                'category': t(product['categoryKey']!),
              },
              selectedLanguage: _selectedLanguage,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
        crossAxisAlignment: isRtl
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(14)),
            child: AspectRatio(
              aspectRatio: 1.1,
              child: Image.network(
                product['image']!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported,
                      color: Colors.grey),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
            child: Column(
              crossAxisAlignment: isRtl
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  t(product['categoryKey']!),
                  style: const TextStyle(
                      fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  product['name']!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  product['price']!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  product['seller']!,
                  style: const TextStyle(
                      fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
            child: SizedBox(
              width: double.infinity,
              height: 28,
              child: OutlinedButton.icon(
                onPressed: () {
                  CartManager().addProduct({
                    ...product,
                    'category': t(product['categoryKey']!),
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(
  content: const Text("Added to cart"),
  backgroundColor: const Color(0xFF7A9B76),
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  duration: const Duration(seconds: 2),
)
                  );
                },
                icon: const Icon(Icons.shopping_cart_outlined,
                    size: 14),
                label: Text(t('addToCart'),
                    style: const TextStyle(fontSize: 11)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF7A9B76),
                  side: const BorderSide(color: Color(0xFF7A9B76)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  // ── Bottom Nav ────────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.shopping_bag_outlined, 'key': 'browseProducts'},
      {'icon': Icons.school_outlined, 'key': 'courses'},
      {'icon': Icons.swap_horiz_outlined, 'key': 'switchToSeller'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(items.length, (index) {
            final isSelected = _selectedNavIndex == index;
            return Expanded(
              child: GestureDetector(
                onTap: () =>
                    setState(() => _selectedNavIndex = index),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[index]['icon'] as IconData,
                        size: 22,
                        color: isSelected
                            ? const Color(0xFF7A9B76)
                            : Colors.grey,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t(items[index]['key'] as String),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected
                              ? const Color(0xFF7A9B76)
                              : Colors.grey,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}