import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Cart.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, String> product;
  final String selectedLanguage;

  const ProductDetailScreen({
    super.key,
    required this.product,
    this.selectedLanguage = 'English',
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Map<String, String> get product => widget.product;
  String get selectedLanguage => widget.selectedLanguage;


  // ── Translations ───────────────────────────────────────────
  // ignore: prefer_const_declarations
  final Map<String, Map<String, String>> _translations = {
    'English': {
      'back': 'Back to products',
      'addToCart': 'Add to Cart',
      'soldBy': 'Sold by',
      'viewProfile': 'View seller profile',
      'contactSeller': 'Contact Seller',
      'callSeller': 'Call Seller',
      'whatsapp': 'WhatsApp',
      'pakistan': 'Pakistan',
    },
    'Urdu': {
      'back': 'مصنوعات پر واپس',
      'addToCart': 'ٹوکری میں ڈالیں',
      'soldBy': 'فروخت کنندہ',
      'viewProfile': 'بیچنے والے کا پروفائل دیکھیں',
      'contactSeller': 'بیچنے والے سے رابطہ کریں',
      'callSeller': 'کال کریں',
      'whatsapp': 'واٹس ایپ',
      'pakistan': 'پاکستان',
    },
    'Punjabi': {
      'back': 'ਉਤਪਾਦਾਂ ਤੇ ਵਾਪਸ',
      'addToCart': 'ਕਾਰਟ ਵਿੱਚ ਪਾਓ',
      'soldBy': 'ਵੇਚਣ ਵਾਲਾ',
      'viewProfile': 'ਵੇਚਣ ਵਾਲੇ ਦਾ ਪ੍ਰੋਫਾਈਲ ਵੇਖੋ',
      'contactSeller': 'ਵੇਚਣ ਵਾਲੇ ਨਾਲ ਸੰਪਰਕ ਕਰੋ',
      'callSeller': 'ਕਾਲ ਕਰੋ',
      'whatsapp': 'ਵਟਸਐਪ',
      'pakistan': 'ਪਾਕਿਸਤਾਨ',
    },
    'Sindhi': {
      'back': 'شين ڏانهن واپس',
      'addToCart': 'ٽوڪري ۾ وجھو',
      'soldBy': 'وڪرو ڪندڙ',
      'viewProfile': 'وڪرو ڪندڙ جو پروفائل ڏسو',
      'contactSeller': 'وڪرو ڪندڙ سان رابطو ڪريو',
      'callSeller': 'ڪال ڪريو',
      'whatsapp': 'واٽس ايپ',
      'pakistan': 'پاڪستان',
    },
  };

  String t(String key) =>
      _translations[selectedLanguage]?[key] ??
      _translations['English']![key]!;

  bool get isRtl =>
      selectedLanguage == 'Urdu' ||
      selectedLanguage == 'Sindhi' ||
      selectedLanguage == 'Punjabi';

  // ── Launcher helpers ───────────────────────────────────────
  Future<void> _launchPhone(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchWhatsApp(String number) async {
    final uri = Uri.parse('https://wa.me/$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBackButton(context),
                _buildProductImage(),
                _buildProductInfo(),
                _buildDivider(),
                _buildSellerInfo(context),
                _buildDivider(),
                _buildContactSection(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Back Button ───────────────────────────────────────────
  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isRtl ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
              size: 16,
              color: Colors.black87,
            ),
            const SizedBox(width: 4),
            Text(
              t('back'),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Product Image ─────────────────────────────────────────
  Widget _buildProductImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 1.1,
          child: Image.network(
            product['image'] ?? '',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey.shade200,
              child: const Icon(Icons.image_not_supported,
                  size: 60, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  // ── Product Info ──────────────────────────────────────────
  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category
          Text(
            product['category'] ?? '',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          // Product Name
          Text(
            product['name'] ?? '',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          // Price
          Text(
            product['price'] ?? '',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7A9B76),
            ),
          ),
          const SizedBox(height: 10),
          // Description
          Text(
            product['description'] ??
                'Beautifully handcrafted by skilled artisans using traditional techniques passed down through generations.',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          // Add to Cart Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                CartManager().addProduct(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product["name"]} added to cart!'),
                    backgroundColor: const Color(0xFF7A9B76),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    action: SnackBarAction(
                      label: 'View Cart',
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CartScreen(
                              selectedLanguage: selectedLanguage,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined, size: 18),
              label: Text(
                t('addToCart'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7A9B76),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── Seller Info ───────────────────────────────────────────
  Widget _buildSellerInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline,
                color: Colors.grey, size: 26),
          ),
          const SizedBox(width: 12),
          // Name & location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t('soldBy'),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  product['seller'] ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  t('pakistan'),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Contact Section ───────────────────────────────────────
  Widget _buildContactSection() {
    final phone = product['phone'] ?? '+923001234567';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t('contactSeller'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          // Call Seller
          _buildContactButton(
            icon: Icons.phone_outlined,
            label: t('callSeller'),
            onTap: () => _launchPhone(phone),
          ),
          const SizedBox(height: 10),
          // WhatsApp
          _buildContactButton(
            icon: Icons.chat_bubble_outline,
            label: t('whatsapp'),
            onTap: () => _launchWhatsApp(phone),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F5EF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF7A9B76)),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Divider ───────────────────────────────────────────────
  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade200,
      thickness: 1,
      height: 1,
    );
  }
}