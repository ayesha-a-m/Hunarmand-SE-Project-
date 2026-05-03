import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/product_service.dart';
import '../../services/order_service.dart';
import '../../services/course_service.dart';
import '../Customer/customer_homescreen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Seller Dashboard Screen — Firebase Wired
// ─────────────────────────────────────────────────────────────────────────────

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedLanguage = 'English';
  bool _showLanguageDropdown = false;

  // Current logged in seller
  final String _sellerUid = FirebaseAuth.instance.currentUser!.uid;
  String _sellerName = '';

  // ── Translations ─────────────────────────────────────────
  static const Map<String, Map<String, String>> _tr = {
    'English': {
      'dashboard': 'Seller Dashboard',
      'subtitle': 'Manage your business and products',
      'switchToCustomer': 'Switch to Customer',
      'totalProducts': 'Total Products',
      'pendingOrders': 'Pending Orders',
      'totalRevenue': 'Total Revenue',
      'manageProducts': 'Manage Products',
      'manageCourses': 'Manage Courses',
      'manageOrders': 'Manage Orders',
      'yourProducts': 'Your Products',
      'addProduct': '+ Add Product',
      'yourCourses': 'Your Courses',
      'addCourse': '+ Add Course',
      'edit': 'Edit',
      'delete': 'Delete',
      'noProducts': 'No products yet',
      'noCourses': 'No courses yet',
      'noOrders': 'No orders yet',
    },
    'Urdu': {
      'dashboard': 'بیچنے والے کا ڈیش بورڈ',
      'subtitle': 'اپنا کاروبار اور مصنوعات منظم کریں',
      'switchToCustomer': 'خریدار پر جائیں',
      'totalProducts': 'کل مصنوعات',
      'pendingOrders': 'زیر التواء آرڈر',
      'totalRevenue': 'کل آمدنی',
      'manageProducts': 'مصنوعات',
      'manageCourses': 'کورسز',
      'manageOrders': 'آرڈرز',
      'yourProducts': 'آپ کی مصنوعات',
      'addProduct': '+ مصنوع شامل کریں',
      'yourCourses': 'آپ کے کورسز',
      'addCourse': '+ کورس شامل کریں',
      'edit': 'ترمیم',
      'delete': 'حذف کریں',
      'noProducts': 'ابھی کوئی مصنوعات نہیں',
      'noCourses': 'ابھی کوئی کورس نہیں',
      'noOrders': 'ابھی کوئی آرڈر نہیں',
    },
    'Punjabi': {
      'dashboard': 'ਵੇਚਣ ਵਾਲੇ ਦਾ ਡੈਸ਼ਬੋਰਡ',
      'subtitle': 'ਆਪਣਾ ਕਾਰੋਬਾਰ ਸੰਭਾਲੋ',
      'switchToCustomer': 'ਖਰੀਦਦਾਰ ਕੋਲ ਜਾਓ',
      'totalProducts': 'ਕੁੱਲ ਉਤਪਾਦ',
      'pendingOrders': 'ਲੰਬਿਤ ਆਰਡਰ',
      'totalRevenue': 'ਕੁੱਲ ਆਮਦਨ',
      'manageProducts': 'ਉਤਪਾਦ',
      'manageCourses': 'ਕੋਰਸ',
      'manageOrders': 'ਆਰਡਰ',
      'yourProducts': 'ਤੁਹਾਡੇ ਉਤਪਾਦ',
      'addProduct': '+ ਉਤਪਾਦ ਜੋੜੋ',
      'yourCourses': 'ਤੁਹਾਡੇ ਕੋਰਸ',
      'addCourse': '+ ਕੋਰਸ ਜੋੜੋ',
      'edit': 'ਸੋਧੋ',
      'delete': 'ਮਿਟਾਓ',
      'noProducts': 'ਅਜੇ ਕੋਈ ਉਤਪਾਦ ਨਹੀਂ',
      'noCourses': 'ਅਜੇ ਕੋਈ ਕੋਰਸ ਨਹੀਂ',
      'noOrders': 'ਅਜੇ ਕੋਈ ਆਰਡਰ ਨਹੀਂ',
    },
    'Sindhi': {
      'dashboard': 'وڪرو ڪندڙ ڊيش بورڊ',
      'subtitle': 'پنهنجو ڪاروبار سنڀاليو',
      'switchToCustomer': 'خريدار ڏانهن وڃو',
      'totalProducts': 'ڪل شيون',
      'pendingOrders': 'زير التوا آرڊر',
      'totalRevenue': 'ڪل آمدني',
      'manageProducts': 'شيون',
      'manageCourses': 'ڪورس',
      'manageOrders': 'آرڊر',
      'yourProducts': 'توهان جون شيون',
      'addProduct': '+ شئي شامل ڪريو',
      'yourCourses': 'توهان جا ڪورس',
      'addCourse': '+ ڪورس شامل ڪريو',
      'edit': 'سنواريو',
      'delete': 'ختم ڪريو',
      'noProducts': 'اڃا ڪا شئي ناهي',
      'noCourses': 'اڃا ڪو ڪورس ناهي',
      'noOrders': 'اڃا ڪو آرڊر ناهي',
    },
  };

  String t(String key) =>
      _tr[_selectedLanguage]?[key] ?? _tr['English']![key]!;

  bool get isRtl =>
      _selectedLanguage == 'Urdu' ||
          _selectedLanguage == 'Sindhi' ||
          _selectedLanguage == 'Punjabi';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSellerName();
  }

  // Load seller name from Firestore
  Future<void> _loadSellerName() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_sellerUid)
        .get();
    if (doc.exists && mounted) {
      setState(() => _sellerName = doc.data()?['name'] ?? '');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Build ────────────────────────────────────────────────
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
                  _buildHeader(context),
                  _buildStatsRow(),
                  _buildTabs(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildManageProducts(),
                        _buildManageCourses(),
                        _buildManageOrders(),
                      ],
                    ),
                  ),
                ],
              ),
              if (_showLanguageDropdown)
                GestureDetector(
                  onTap: () => setState(() => _showLanguageDropdown = false),
                  child: Container(color: Colors.transparent),
                ),
              if (_showLanguageDropdown)
                Positioned(
                  top: 56,
                  right: isRtl ? null : 90,
                  left: isRtl ? 90 : null,
                  child: _buildLanguageDropdown(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Language Dropdown ────────────────────────────────────
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((lang) {
              final isSelected = _selectedLanguage == lang['key'];
              return InkWell(
                onTap: () => setState(() {
                  _selectedLanguage = lang['key']!;
                  _showLanguageDropdown = false;
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  color: isSelected
                      ? const Color(0xFF7A9B76).withOpacity(0.1)
                      : Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(lang['key']!,
                          style: TextStyle(
                              fontSize: 15,
                              color: isSelected
                                  ? const Color(0xFF7A9B76)
                                  : Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal)),
                      Text(lang['native']!,
                          style: TextStyle(
                              fontSize: 15,
                              color: isSelected
                                  ? const Color(0xFF7A9B76)
                                  : Colors.black54,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal)),
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

  // ── Header ───────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFF7A9B76),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                Text(t('dashboard'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Text(
                  _sellerName.isNotEmpty
                      ? _sellerName
                      : t('subtitle'),
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () =>
                setState(() => _showLanguageDropdown = !_showLanguageDropdown),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _selectedLanguage != 'English'
                    ? Colors.white.withOpacity(0.25)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.translate, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 8),
          // Sign out button
          GestureDetector(
            onTap: () async {
              final uid = FirebaseAuth.instance.currentUser!.uid;
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .update({'role': 'customer'});
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const CustomerHomeScreen(),
                ),
                    (_) => false,
              );
            },
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                t('switchToCustomer'),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7A9B76),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats — Live from Firestore ──────────────────────────
  Widget _buildStatsRow() {
    return StreamBuilder<QuerySnapshot>(
      stream: ProductService.getSellerProducts(_sellerUid),
      builder: (context, productSnap) {
        final productCount = productSnap.data?.docs.length ?? 0;

        return StreamBuilder<QuerySnapshot>(
          stream: OrderService.getSellerOrders(_sellerUid),
          builder: (context, orderSnap) {
            final orders = orderSnap.data?.docs ?? [];
            final pendingCount = orders
                .where((o) =>
            (o.data() as Map<String, dynamic>)['status'] == 'pending')
                .length;
            final totalRevenue = orders
                .where((o) => ['confirmed', 'completed'].contains(
                (o.data() as Map<String, dynamic>)['status']))
                .fold<double>(
                0,
                    (sum, o) =>
                sum +
                    ((o.data() as Map<String, dynamic>)['productPrice']
                    as num)
                        .toDouble());

            return Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _statTile(t('totalProducts'), '$productCount',
                      Icons.inventory_2_outlined),
                  const SizedBox(height: 8),
                  _statTile(t('pendingOrders'), '$pendingCount',
                      Icons.shopping_cart_outlined),
                  const SizedBox(height: 8),
                  _statTile(t('totalRevenue'),
                      'Rs. ${totalRevenue.toStringAsFixed(0)}',
                      Icons.attach_money),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _statTile(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ],
          ),
          Icon(icon, size: 28, color: Colors.grey.shade300),
        ],
      ),
    );
  }

  // ── Tabs ─────────────────────────────────────────────────
  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF7A9B76),
        unselectedLabelColor: Colors.grey,
        indicatorColor: const Color(0xFF7A9B76),
        indicatorWeight: 2,
        labelStyle:
        const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 13),
        tabs: [
          Tab(text: t('manageProducts')),
          Tab(text: t('manageCourses')),
          Tab(text: t('manageOrders')),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // TAB 1 — Manage Products (Live Firestore)
  // ─────────────────────────────────────────────────────────
  Widget _buildManageProducts() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t('yourProducts'),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () => _openAddProductSheet(),
                icon: const Icon(Icons.add, size: 16),
                label: Text('Add Product',
                    style: const TextStyle(fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A9B76),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: ProductService.getSellerProducts(_sellerUid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return _emptyState(t('noProducts'), Icons.inventory_2_outlined);
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, i) {
                  final doc = snapshot.data!.docs[i];
                  final data = doc.data() as Map<String, dynamic>;
                  return _buildProductCard(data, doc.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Map<String, dynamic> p, String docId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(14)),
            child: AspectRatio(
              aspectRatio: 2.2,
              child: (p['imageUrl'] as String).isNotEmpty
                  ? Image.network(p['imageUrl'], fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imagePlaceholder())
                  : _imagePlaceholder(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p['title'] ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(p['description'] ?? '',
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black54),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Text('Rs. ${p['price']}',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7A9B76))),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            _openAddProductSheet(existing: p, docId: docId),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black87,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(t('edit')),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _confirmDelete(
                          title: p['title'] ?? '',
                          onConfirm: () =>
                              ProductService.deleteProduct(docId),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(t('delete')),
                      ),
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

  // ─────────────────────────────────────────────────────────
  // TAB 2 — Manage Courses (Live Firestore)
  // ─────────────────────────────────────────────────────────
  Widget _buildManageCourses() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t('yourCourses'),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () => _openAddCourseSheet(),
                icon: const Icon(Icons.add, size: 16),
                label: Text('Add Course',
                    style: const TextStyle(fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A9B76),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: CourseService.getSellerCourses(_sellerUid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return _emptyState(t('noCourses'), Icons.school_outlined);
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, i) {
                  final doc = snapshot.data!.docs[i];
                  final data = doc.data() as Map<String, dynamic>;
                  return _buildCourseCard(data, doc.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> c, String docId) {
    final level = c['level'] ?? 'Beginner';
    Color levelColor;
    Color levelText;
    switch (level) {
      case 'Intermediate':
        levelColor = const Color(0xFFFFF3CD);
        levelText = const Color(0xFF856404);
        break;
      case 'Advanced':
        levelColor = const Color(0xFFF8D7DA);
        levelText = const Color(0xFF842029);
        break;
      default:
        levelColor = const Color(0xFFD4EDDA);
        levelText = const Color(0xFF3D8B5E);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: levelColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(level,
                    style: TextStyle(
                        fontSize: 11,
                        color: levelText,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 8),
              Text(c['skill'] ?? '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const Spacer(),
              const Text('Course Fee',
                  style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(c['title'] ?? '',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
              ),
              Text('Rs. ${c['fee'] ?? 0}',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7A9B76))),
            ],
          ),
          const SizedBox(height: 6),
          Text(c['description'] ?? '',
              style: const TextStyle(
                  fontSize: 12, color: Colors.black54, height: 1.4),
              maxLines: 4,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      _openAddCourseSheet(existing: c, docId: docId),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(t('edit')),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _confirmDelete(
                    title: c['title'] ?? '',
                    onConfirm: () => CourseService.deleteCourse(docId),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(t('delete')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // TAB 3 — Manage Orders (Live Firestore)
  // ─────────────────────────────────────────────────────────
  Widget _buildManageOrders() {
    return StreamBuilder<QuerySnapshot>(
      stream: OrderService.getSellerOrders(_sellerUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _emptyState(t('noOrders'), Icons.receipt_long_outlined);
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (_, i) {
            final doc = snapshot.data!.docs[i];
            final data = doc.data() as Map<String, dynamic>;
            return _buildOrderCard(data, doc.id);
          },
        );
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> o, String docId) {
    final status = o['status'] ?? 'pending';
    final statusColor = status == 'pending'
        ? const Color(0xFFFFF3CD)
        : status == 'completed'
        ? const Color(0xFFD4EDDA)
        : const Color(0xFFF8D7DA);
    final statusText = status == 'pending'
        ? const Color(0xFF856404)
        : status == 'completed'
        ? const Color(0xFF3D8B5E)
        : const Color(0xFF842029);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(o['productTitle'] ?? '',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(status,
                    style: TextStyle(
                        fontSize: 11,
                        color: statusText,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('Customer: ${o['customerName'] ?? ''}',
              style: const TextStyle(fontSize: 13, color: Colors.black54)),
          Text('Phone: ${o['customerPhone'] ?? ''}',
              style: const TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rs. ${o['productPrice'] ?? 0}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7A9B76))),
              Row(
                children: ['pending', 'completed', 'cancelled']
                    .map((s) => GestureDetector(
                  onTap: () =>
                      OrderService.updateOrderStatus(docId, s),
                  child: Container(
                    margin: const EdgeInsets.only(left: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: status == s
                          ? const Color(0xFF7A9B76)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(s,
                        style: TextStyle(
                            fontSize: 10,
                            color: status == s
                                ? Colors.white
                                : Colors.grey)),
                  ),
                ))
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Add / Edit Product Bottom Sheet
  // ─────────────────────────────────────────────────────────
  void _openAddProductSheet(
      {Map<String, dynamic>? existing, String? docId}) {
    final nameCtrl =
    TextEditingController(text: existing?['title'] ?? '');
    final catCtrl =
    TextEditingController(text: existing?['category'] ?? '');
    final priceCtrl =
    TextEditingController(text: existing?['price']?.toString() ?? '');
    final descCtrl =
    TextEditingController(text: existing?['description'] ?? '');
    final imageCtrl =
    TextEditingController(text: existing?['imageUrl'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Text(existing == null ? 'Add New Product' : 'Edit Product',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              _formLabel('Image URL (optional)'),
              _formField(imageCtrl, hint: 'https://...'),
              const SizedBox(height: 14),

              _formLabel('Product Name *'),
              _formField(nameCtrl, hint: 'e.g., Embroidered Shawl'),
              const SizedBox(height: 14),

              _formLabel('Category *'),
              _formField(catCtrl, hint: 'e.g., Textiles'),
              const SizedBox(height: 14),

              _formLabel('Price (Rs.) *'),
              _formField(priceCtrl,
                  hint: 'e.g., 3500',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 14),

              _formLabel('Description *'),
              _formField(descCtrl,
                  hint: 'Describe your product...', maxLines: 3),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (nameCtrl.text.isEmpty || priceCtrl.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all required fields'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                    }

                    if (existing != null && docId != null) {
                      // Update existing product
                      await ProductService.updateProduct(
                        docId,
                        title: nameCtrl.text,
                        category: catCtrl.text,
                        price: double.tryParse(priceCtrl.text) ?? 0,
                        description: descCtrl.text,
                        imageUrl: imageCtrl.text,
                      );
                    } else {
                      // Add new product
                      await ProductService.addProduct(
                        sellerUid: _sellerUid,
                        sellerName: _sellerName,
                        title: nameCtrl.text,
                        category: catCtrl.text,
                        price: double.tryParse(priceCtrl.text) ?? 0,
                        description: descCtrl.text,
                        imageUrl: imageCtrl.text,
                      );
                    }

                    if (!mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(existing == null
                            ? 'Product added!'
                            : 'Product updated!'),
                        backgroundColor: const Color(0xFF7A9B76),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A9B76),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    existing == null ? 'Add Product' : 'Save Changes',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Add / Edit Course Bottom Sheet
  // ─────────────────────────────────────────────────────────
  void _openAddCourseSheet(
      {Map<String, dynamic>? existing, String? docId}) {
    final titleCtrl =
    TextEditingController(text: existing?['title'] ?? '');
    final skillCtrl =
    TextEditingController(text: existing?['skill'] ?? '');
    final descCtrl =
    TextEditingController(text: existing?['description'] ?? '');
    final feeCtrl =
    TextEditingController(text: existing?['fee']?.toString() ?? '');
    final cityCtrl =
    TextEditingController(text: existing?['city'] ?? '');
    String selectedLevel = existing?['level'] ?? 'Beginner';

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
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 20),
                Text(existing == null ? 'Add New Course' : 'Edit Course',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                _formLabel('Course Title *'),
                _formField(titleCtrl,
                    hint: 'e.g., Traditional Embroidery Workshop'),
                const SizedBox(height: 14),

                _formLabel('Skill / Category *'),
                _formField(skillCtrl, hint: 'e.g., Embroidery'),
                const SizedBox(height: 14),

                _formLabel('City *'),
                _formField(cityCtrl, hint: 'e.g., Lahore'),
                const SizedBox(height: 14),

                _formLabel('Skill Level *'),
                Row(
                  children: ['Beginner', 'Intermediate', 'Advanced']
                      .map((lvl) => GestureDetector(
                    onTap: () =>
                        setModalState(() => selectedLevel = lvl),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selectedLevel == lvl
                            ? const Color(0xFF7A9B76)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(lvl,
                          style: TextStyle(
                              fontSize: 12,
                              color: selectedLevel == lvl
                                  ? Colors.white
                                  : Colors.black54,
                              fontWeight: selectedLevel == lvl
                                  ? FontWeight.w600
                                  : FontWeight.normal)),
                    ),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 14),

                _formLabel('Description *'),
                _formField(descCtrl,
                    hint: 'Describe your course...', maxLines: 3),
                const SizedBox(height: 14),

                _formLabel('Course Fee (Rs.) *'),
                _formField(feeCtrl,
                    hint: '5000',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (titleCtrl.text.isEmpty || feeCtrl.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                            Text('Please fill all required fields'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }

                      if (existing != null && docId != null) {
                        // Update
                        await FirebaseFirestore.instance
                            .collection('courses')
                            .doc(docId)
                            .update({
                          'title': titleCtrl.text,
                          'skill': skillCtrl.text,
                          'level': selectedLevel,
                          'description': descCtrl.text,
                          'fee': double.tryParse(feeCtrl.text) ?? 0,
                          'city': cityCtrl.text,
                        });
                      } else {
                        // Add new course
                        await CourseService.addCourse(
                          sellerUid: _sellerUid,
                          sellerName: _sellerName,
                          title: titleCtrl.text,
                          skill: skillCtrl.text,
                          level: selectedLevel,
                          description: descCtrl.text,
                          fee: double.tryParse(feeCtrl.text) ?? 0,
                          city: cityCtrl.text,
                        );
                      }

                      if (!mounted) return;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(existing == null
                              ? 'Course added!'
                              : 'Course updated!'),
                          backgroundColor: const Color(0xFF7A9B76),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7A9B76),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(
                      existing == null ? 'Add Course' : 'Save Changes',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────
  void _confirmDelete(
      {required String title, required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Delete'),
        content: Text('Delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  Widget _formLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text,
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87)),
  );

  Widget _formField(
      TextEditingController ctrl, {
        String hint = '',
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
      }) =>
      TextField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.all(14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF7A9B76)),
          ),
        ),
      );

  Widget _imagePlaceholder() => Container(
    color: Colors.grey.shade200,
    child: const Icon(Icons.image_not_supported,
        color: Colors.grey, size: 36),
  );

  Widget _emptyState(String msg, IconData icon) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 64, color: Colors.grey.shade300),
        const SizedBox(height: 16),
        Text(msg,
            style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    ),
  );
}