import 'package:flutter/material.dart';

// ── Order Model ───────────────────────────────────────────────────────────────
class CustomerOrder {
  final String id;
  final String productName;
  final String productImage;
  final String seller;
  final String price;
  final String date;
  final int quantity;
  String status; // 'Pending', 'Completed', 'Cancelled'

  CustomerOrder({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.seller,
    required this.price,
    required this.date,
    required this.quantity,
    required this.status,
  });
}

// ── Global Order Manager ──────────────────────────────────────────────────────
class OrderManager {
  static final OrderManager _instance = OrderManager._internal();
  factory OrderManager() => _instance;
  OrderManager._internal();

  final List<CustomerOrder> orders = [
    CustomerOrder(
      id: 'ORD-001',
      productName: 'Embroidered Shawl',
      productImage:
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
      seller: 'Fatima Ahmed',
      price: 'Rs. 3,500',
      date: '15 Apr 2025',
      quantity: 1,
      status: 'Completed',
    ),
    CustomerOrder(
      id: 'ORD-002',
      productName: 'Silver Turquoise Set',
      productImage:
          'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400',
      seller: 'Zainab Hussain',
      price: 'Rs. 5,000',
      date: '17 Apr 2025',
      quantity: 1,
      status: 'Pending',
    ),
    CustomerOrder(
      id: 'ORD-003',
      productName: 'Clay Water Pot',
      productImage:
          'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=400',
      seller: 'Nadia Malik',
      price: 'Rs. 1,500',
      date: '10 Apr 2025',
      quantity: 2,
      status: 'Cancelled',
    ),
    CustomerOrder(
      id: 'ORD-004',
      productName: 'Embroidered Cushion',
      productImage:
          'https://images.unsplash.com/photo-1597843786411-a7fa8ad44a95?w=400',
      seller: 'Fatima Ahmed',
      price: 'Rs. 800',
      date: '18 Apr 2025',
      quantity: 1,
      status: 'Pending',
    ),
  ];
}

// ── Order History Screen ──────────────────────────────────────────────────────
class OrderHistoryScreen extends StatefulWidget {
  final String selectedLanguage;

  const OrderHistoryScreen({
    super.key,
    this.selectedLanguage = 'English',
  });

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final OrderManager _orderManager = OrderManager();

  static const Map<String, Map<String, String>> _translations = {
    'English': {
      'title': 'My Orders',
      'subtitle': 'Track your order history',
      'all': 'All',
      'pending': 'Pending',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
      'noOrders': 'No orders here',
      'orderId': 'Order ID',
      'qty': 'Qty',
      'cancelOrder': 'Cancel Order',
      'reorder': 'Reorder',
      'confirmCancel': 'Cancel Order?',
      'confirmCancelMsg': 'Are you sure you want to cancel this order?',
      'yes': 'Yes, Cancel',
      'no': 'No',
      'orderCancelled': 'Order cancelled',
    },
    'Urdu': {
      'title': 'میرے آرڈر',
      'subtitle': 'اپنے آرڈر کی تاریخ دیکھیں',
      'all': 'سب',
      'pending': 'زیر التواء',
      'completed': 'مکمل',
      'cancelled': 'منسوخ',
      'noOrders': 'یہاں کوئی آرڈر نہیں',
      'orderId': 'آرڈر نمبر',
      'qty': 'تعداد',
      'cancelOrder': 'آرڈر منسوخ کریں',
      'reorder': 'دوبارہ آرڈر کریں',
      'confirmCancel': 'آرڈر منسوخ کریں؟',
      'confirmCancelMsg': 'کیا آپ واقعی یہ آرڈر منسوخ کرنا چاہتے ہیں؟',
      'yes': 'ہاں، منسوخ کریں',
      'no': 'نہیں',
      'orderCancelled': 'آرڈر منسوخ ہو گیا',
    },
    'Punjabi': {
      'title': 'ਮੇਰੇ ਆਰਡਰ',
      'subtitle': 'ਆਪਣੇ ਆਰਡਰ ਦਾ ਇਤਿਹਾਸ ਵੇਖੋ',
      'all': 'ਸਭ',
      'pending': 'ਲੰਬਿਤ',
      'completed': 'ਮੁਕੰਮਲ',
      'cancelled': 'ਰੱਦ',
      'noOrders': 'ਇੱਥੇ ਕੋਈ ਆਰਡਰ ਨਹੀਂ',
      'orderId': 'ਆਰਡਰ ਨੰਬਰ',
      'qty': 'ਮਾਤਰਾ',
      'cancelOrder': 'ਆਰਡਰ ਰੱਦ ਕਰੋ',
      'reorder': 'ਦੁਬਾਰਾ ਆਰਡਰ ਕਰੋ',
      'confirmCancel': 'ਆਰਡਰ ਰੱਦ ਕਰੋ?',
      'confirmCancelMsg': 'ਕੀ ਤੁਸੀਂ ਸੱਚਮੁੱਚ ਇਹ ਆਰਡਰ ਰੱਦ ਕਰਨਾ ਚਾਹੁੰਦੇ ਹੋ?',
      'yes': 'ਹਾਂ, ਰੱਦ ਕਰੋ',
      'no': 'ਨਹੀਂ',
      'orderCancelled': 'ਆਰਡਰ ਰੱਦ ਕਰ ਦਿੱਤਾ',
    },
    'Sindhi': {
      'title': 'منهنجا آرڊر',
      'subtitle': 'پنهنجي آرڊر جي تاريخ ڏسو',
      'all': 'سڀ',
      'pending': 'زير التوا',
      'completed': 'مڪمل',
      'cancelled': 'منسوخ',
      'noOrders': 'هتي ڪو آرڊر ناهي',
      'orderId': 'آرڊر نمبر',
      'qty': 'تعداد',
      'cancelOrder': 'آرڊر منسوخ ڪريو',
      'reorder': 'ٻيهر آرڊر ڪريو',
      'confirmCancel': 'آرڊر منسوخ ڪريو؟',
      'confirmCancelMsg': 'ڇا توهان واقعي هي آرڊر منسوخ ڪرڻ چاهيو ٿا؟',
      'yes': 'ها، منسوخ ڪريو',
      'no': 'نه',
      'orderCancelled': 'آرڊر منسوخ ٿي ويو',
    },
  };

  String t(String key) =>
      _translations[widget.selectedLanguage]?[key] ??
      _translations['English']![key]!;

  bool get isRtl =>
      widget.selectedLanguage == 'Urdu' ||
      widget.selectedLanguage == 'Sindhi' ||
      widget.selectedLanguage == 'Punjabi';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<CustomerOrder> _filterOrders(String status) {
    if (status == 'All') return _orderManager.orders;
    return _orderManager.orders
        .where((o) => o.status == status)
        .toList();
  }

  void _cancelOrder(CustomerOrder order) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Text(t('confirmCancel')),
        content: Text(t('confirmCancelMsg')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t('no'),
                style: const TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              setState(() => order.status = 'Cancelled');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t('orderCancelled')),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: Text(t('yes'),
                style: const TextStyle(color: Colors.redAccent)),
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
              _buildHeader(context),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOrderList('All'),
                    _buildOrderList('Pending'),
                    _buildOrderList('Completed'),
                    _buildOrderList('Cancelled'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFF7A9B76),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('title'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                Text(t('subtitle'),
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
          // Order count badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_orderManager.orders.length} orders',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab Bar ────────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF7A9B76),
        unselectedLabelColor: Colors.grey,
        indicatorColor: const Color(0xFF7A9B76),
        indicatorWeight: 2,
        labelStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        tabs: [
          Tab(text: t('all')),
          _buildTabWithBadge(t('pending'), 'Pending'),
          Tab(text: t('completed')),
          Tab(text: t('cancelled')),
        ],
      ),
    );
  }

  Widget _buildTabWithBadge(String label, String status) {
    final count =
        _orderManager.orders.where((o) => o.status == status).length;
    if (count == 0) return Tab(text: label);
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: const Color(0xFF7A9B76),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ── Order List ─────────────────────────────────────────────
  Widget _buildOrderList(String status) {
    final orders = _filterOrders(status);
    if (orders.isEmpty) return _buildEmptyState();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (_, i) => _buildOrderCard(orders[i]),
    );
  }

  // ── Order Card ─────────────────────────────────────────────
  Widget _buildOrderCard(CustomerOrder order) {
    // Status colors
    final Map<String, List<Color>> statusColors = {
      'Pending': [
        const Color(0xFFFFF3CD),
        const Color(0xFF856404)
      ],
      'Completed': [
        const Color(0xFFD4EDDA),
        const Color(0xFF3D8B5E)
      ],
      'Cancelled': [
        const Color(0xFFF8D7DA),
        const Color(0xFF842029)
      ],
    };
    final colors = statusColors[order.status] ??
        [Colors.grey.shade100, Colors.grey];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Top row: image + info + status ───────────────
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: Image.network(
                      order.productImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported,
                            color: Colors.grey, size: 24),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name + status badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              order.productName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: colors[0],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              order.status,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: colors[1],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.seller,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            order.price,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF7A9B76),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${t('qty')}: ${order.quantity}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Divider ────────────────────────────────────────
          Divider(
              height: 1, color: Colors.grey.shade100),

          // ── Bottom row: order ID + date + actions ─────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${t('orderId')}: ${order.id}',
                      style: const TextStyle(
                          fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.date,
                      style: const TextStyle(
                          fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                // Action buttons
                Row(
                  children: [
                    if (order.status == 'Pending') ...[
                      _actionButton(
                        label: t('cancelOrder'),
                        color: Colors.redAccent,
                        borderColor: Colors.redAccent,
                        onTap: () => _cancelOrder(order),
                      ),
                    ],
                    if (order.status == 'Completed') ...[
                      _actionButton(
                        label: t('reorder'),
                        color: const Color(0xFF7A9B76),
                        borderColor: const Color(0xFF7A9B76),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('${order.productName} added to cart!'),
                              backgroundColor: const Color(0xFF7A9B76),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10)),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ── Empty State ────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            t('noOrders'),
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}