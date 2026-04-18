import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ── Cart Model ────────────────────────────────────────────────────────────────
class CartItem {
  final Map<String, String> product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

// ── Global Cart State (simple singleton) ─────────────────────────────────────
class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<CartItem> items = [];

  void addProduct(Map<String, String> product) {
    final existing = items.where(
      (i) => i.product['name'] == product['name'],
    );
    if (existing.isNotEmpty) {
      existing.first.quantity++;
    } else {
      items.add(CartItem(product: product));
    }
  }

  void removeItem(int index) => items.removeAt(index);

  void clearCart() => items.clear();

  void increment(int index) => items[index].quantity++;

  void decrement(int index) {
    if (items[index].quantity > 1) {
      items[index].quantity--;
    } else {
      items.removeAt(index);
    }
  }

  int get totalItems =>
      items.fold(0, (sum, i) => sum + i.quantity);

  int get totalPrice => items.fold(
        0,
        (sum, i) =>
            sum +
            (int.tryParse(
                    i.product['price']
                            ?.replaceAll(RegExp(r'[^0-9]'), '') ??
                        '0') ??
                0) *
                i.quantity,
      );
}

// ── Cart Screen ───────────────────────────────────────────────────────────────
class CartScreen extends StatefulWidget {
  final String selectedLanguage;

  const CartScreen({
    super.key,
    this.selectedLanguage = 'English',
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartManager _cart = CartManager();
  String _selectedPayment = '';

  static const Map<String, Map<String, String>> _translations = {
    'English': {
      'back': 'Back to products',
      'clearCart': 'Clear Cart',
      'shoppingCart': 'Shopping Cart',
      'items': 'items',
      'item': 'item',
      'orderSummary': 'Order Summary',
      'total': 'Total',
      'checkout': 'Checkout via WhatsApp',
      'whatsappNote':
          'You will be redirected to WhatsApp to complete your order',
      'emptyCart': 'Your cart is empty',
      'each': 'each',
    },
    'Urdu': {
      'back': 'مصنوعات پر واپس',
      'clearCart': 'ٹوکری صاف کریں',
      'shoppingCart': 'خریداری کی ٹوکری',
      'items': 'اشیاء',
      'item': 'شے',
      'orderSummary': 'آرڈر کا خلاصہ',
      'total': 'کل',
      'checkout': 'واٹس ایپ کے ذریعے چیک آؤٹ',
      'whatsappNote': 'آرڈر مکمل کرنے کے لیے واٹس ایپ پر بھیجا جائے گا',
      'emptyCart': 'آپ کی ٹوکری خالی ہے',
      'each': 'فی',
    },
    'Punjabi': {
      'back': 'ਉਤਪਾਦਾਂ ਤੇ ਵਾਪਸ',
      'clearCart': 'ਕਾਰਟ ਸਾਫ਼ ਕਰੋ',
      'shoppingCart': 'ਖਰੀਦਦਾਰੀ ਕਾਰਟ',
      'items': 'ਚੀਜ਼ਾਂ',
      'item': 'ਚੀਜ਼',
      'orderSummary': 'ਆਰਡਰ ਸੰਖੇਪ',
      'total': 'ਕੁੱਲ',
      'checkout': 'ਵਟਸਐਪ ਰਾਹੀਂ ਚੈੱਕਆਉਟ',
      'whatsappNote': 'ਆਰਡਰ ਪੂਰਾ ਕਰਨ ਲਈ ਵਟਸਐਪ ਤੇ ਭੇਜਿਆ ਜਾਵੇਗਾ',
      'emptyCart': 'ਤੁਹਾਡੀ ਕਾਰਟ ਖਾਲੀ ਹੈ',
      'each': 'ਪ੍ਰਤੀ',
    },
    'Sindhi': {
      'back': 'شين ڏانهن واپس',
      'clearCart': 'ٽوڪري صاف ڪريو',
      'shoppingCart': 'خريداري جي ٽوڪري',
      'items': 'شيون',
      'item': 'شئي',
      'orderSummary': 'آرڊر جو خلاصو',
      'total': 'ڪل',
      'checkout': 'واٽس ايپ ذريعي چيڪ آئوٽ',
      'whatsappNote': 'آرڊر مڪمل ڪرڻ لاءِ واٽس ايپ تي موڪليو ويندو',
      'emptyCart': 'توهان جي ٽوڪري خالي آهي',
      'each': 'في',
    },
  };

  String t(String key) =>
      _translations[widget.selectedLanguage]?[key] ??
      _translations['English']![key]!;

  bool get isRtl =>
      widget.selectedLanguage == 'Urdu' ||
      widget.selectedLanguage == 'Sindhi' ||
      widget.selectedLanguage == 'Punjabi';

  // ── WhatsApp Checkout ─────────────────────────────────────
  // ── Payment Sheet ─────────────────────────────────────────
  void _showCheckoutSheet() {
    if (_cart.items.isEmpty) return;
    setState(() => _selectedPayment = '');

    final methods = [
      {
        'id': 'cod',
        'icon': Icons.money_outlined,
        'color': const Color(0xFF7A9B76),
        'label': 'Cash on Delivery',
        'desc': 'Pay when your order arrives',
      },
      {
        'id': 'jazzcash',
        'icon': Icons.account_balance_wallet_outlined,
        'color': const Color(0xFFD9534F),
        'label': 'JazzCash',
        'desc': 'Pay via JazzCash mobile wallet',
      },
      {
        'id': 'easypaisa',
        'icon': Icons.account_balance_wallet_outlined,
        'color': const Color(0xFF5CB85C),
        'label': 'Easypaisa',
        'desc': 'Pay via Easypaisa mobile wallet',
      },
      {
        'id': 'whatsapp',
        'icon': Icons.chat_outlined,
        'color': const Color(0xFF25D366),
        'label': 'WhatsApp + COD',
        'desc': 'Confirm via WhatsApp, pay on delivery',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Payment Method',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Select how you want to pay',
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 20),

                // Total summary
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F5EF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      Text('Rs. ${_cart.totalPrice}',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7A9B76))),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Payment options
                ...methods.map((m) {
                  final id = m['id'] as String;
                  final color = m['color'] as Color;
                  final isSelected = _selectedPayment == id;
                  return GestureDetector(
                    onTap: () {
                      setModalState(() => _selectedPayment = id);
                      setState(() => _selectedPayment = id);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withValues(alpha: 0.07)
                            : Colors.white,
                        border: Border.all(
                          color: isSelected ? color : Colors.grey.shade200,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(m['icon'] as IconData,
                                color: color, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m['label'] as String,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? color
                                            : Colors.black87)),
                                const SizedBox(height: 2),
                                Text(m['desc'] as String,
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                          ),
                          // Radio dot
                          Container(
                            width: 20, height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? color
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      width: 10, height: 10,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: color),
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 8),

                // Place Order button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => _placeOrder(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7A9B76),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Place Order',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Place Order ───────────────────────────────────────────
  Future<void> _placeOrder(BuildContext sheetCtx) async {
    if (_selectedPayment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a payment method'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    Navigator.pop(sheetCtx);

    if (_selectedPayment == 'whatsapp') {
      final buffer = StringBuffer();
      buffer.writeln('Hello! I would like to place an order:');
      buffer.writeln('');
      for (final item in _cart.items) {
        buffer.writeln(
            '• ${item.product['name']} x${item.quantity} — ${item.product['price']}');
      }
      buffer.writeln('');
      buffer.writeln('Total: Rs. ${_cart.totalPrice}');
      buffer.writeln('Payment: Cash on Delivery (WhatsApp confirmation)');
      final message = Uri.encodeComponent(buffer.toString());
      final phone = _cart.items.first.product['phone'] ?? '+923001234567';
      final uri = Uri.parse('https://wa.me/$phone?text=$message');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }

    setState(() => _cart.clearCart());

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Order placed successfully!'),
          ],
        ),
        backgroundColor: const Color(0xFF7A9B76),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ── Clear Cart Confirmation ───────────────────────────────
  void _confirmClearCart() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Cart'),
        content:
            const Text('Are you sure you want to remove all items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              setState(() => _cart.clearCart());
              Navigator.pop(context);
            },
            child: const Text('Clear',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFEDEDED),
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              Expanded(
                child: _cart.items.isEmpty
                    ? _buildEmptyCart()
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCartTitle(),
                            const SizedBox(height: 12),
                            _buildCartItems(),
                            const SizedBox(height: 16),
                            _buildOrderSummary(),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Top Bar ───────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isRtl
                      ? Icons.arrow_forward_ios
                      : Icons.arrow_back_ios,
                  size: 16,
                  color: Colors.black87,
                ),
                const SizedBox(width: 4),
                Text(t('back'),
                    style: const TextStyle(
                        fontSize: 14, color: Colors.black87)),
              ],
            ),
          ),
          if (_cart.items.isNotEmpty)
            GestureDetector(
              onTap: _confirmClearCart,
              child: Text(
                t('clearCart'),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Cart Title ────────────────────────────────────────────
  Widget _buildCartTitle() {
    final count = _cart.totalItems;
    final label = count == 1 ? t('item') : t('items');
    return Text(
      '${t('shoppingCart')} ($count $label)',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // ── Cart Items ────────────────────────────────────────────
  Widget _buildCartItems() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _cart.items.length,
        separatorBuilder: (_, _) =>
            Divider(color: Colors.grey.shade100, height: 1),
        itemBuilder: (context, index) =>
            _buildCartItemRow(index),
      ),
    );
  }

  Widget _buildCartItemRow(int index) {
    final item = _cart.items[index];
    final product = item.product;
    final unitPrice = int.tryParse(
            product['price']?.replaceAll(RegExp(r'[^0-9]'), '') ??
                '0') ??
        0;
    final lineTotal = unitPrice * item.quantity;

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Image.network(
                product['image'] ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported,
                      size: 24, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    // Delete button
                    GestureDetector(
                      onTap: () {
                        setState(
                            () => _cart.removeItem(index));
                      },
                      child: const Icon(Icons.delete_outline,
                          color: Colors.redAccent, size: 20),
                    ),
                  ],
                ),
                Text(
                  product['category'] ?? '',
                  style: const TextStyle(
                      fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                // Quantity controls + price
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    // − qty +
                    Row(
                      children: [
                        _qtyButton(
                          icon: Icons.remove,
                          onTap: () => setState(
                              () => _cart.decrement(index)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12),
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _qtyButton(
                          icon: Icons.add,
                          onTap: () => setState(
                              () => _cart.increment(index)),
                        ),
                      ],
                    ),
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rs. $unitPrice ${t('each')}',
                          style: const TextStyle(
                              fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          'Rs. $lineTotal',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7A9B76),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }

  // ── Order Summary ─────────────────────────────────────────
  Widget _buildOrderSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t('orderSummary'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 14),
          // Line items
          ..._cart.items.map((item) {
            final unitPrice = int.tryParse(
                    item.product['price']
                            ?.replaceAll(RegExp(r'[^0-9]'), '') ??
                        '0') ??
                0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.product['name']} × ${item.quantity}',
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black54),
                    ),
                  ),
                  Text(
                    'Rs. ${unitPrice * item.quantity}',
                    style: const TextStyle(
                        fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            );
          }),
          const Divider(height: 24),
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t('total'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Rs. ${_cart.totalPrice}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A9B76),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Checkout button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _showCheckoutSheet,
              icon: const Icon(Icons.payment_outlined, size: 18),
              label: Text(
                t('checkout'),
                style: const TextStyle(
                  fontSize: 15,
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

        ],
      ),
    );
  }

  // ── Empty Cart ────────────────────────────────────────────
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            t('emptyCart'),
            style: const TextStyle(
                fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}