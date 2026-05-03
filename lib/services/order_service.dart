import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static CollectionReference get _orders => _db.collection('orders');

  // ─── Place an order ───────────────────────────────────────────────────────────
  static Future<String> placeOrder({
    required String customerUid,
    required String customerName,
    required String customerPhone,
    required String sellerUid,
    required String productId,
    required String productTitle,
    required double productPrice,
    required String paymentMethod, // "cash_on_delivery" | "jazzcash" | "easypaisa"
    String? deliveryAddress,
    String? note,
  }) async {
    final doc = _orders.doc();
    await doc.set({
      'id': doc.id,
      'customerUid': customerUid,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'sellerUid': sellerUid,
      'productId': productId,
      'productTitle': productTitle,
      'productPrice': productPrice,
      'paymentMethod': paymentMethod,
      'deliveryAddress': deliveryAddress ?? '',
      'note': note ?? '',
      'status': 'pending', // pending | confirmed | completed | cancelled
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  // ─── Get orders for a customer ────────────────────────────────────────────────
  static Stream<QuerySnapshot> getCustomerOrders(String customerUid) {
    return _orders
        .where('customerUid', isEqualTo: customerUid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ─── Get orders for a seller ──────────────────────────────────────────────────
  static Stream<QuerySnapshot> getSellerOrders(String sellerUid) {
    return _orders
        .where('sellerUid', isEqualTo: sellerUid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ─── Update order status ──────────────────────────────────────────────────────
  static Future<void> updateOrderStatus(String orderId, String status) async {
    await _orders.doc(orderId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ─── Get seller earnings summary ──────────────────────────────────────────────
  /// Returns total orders count and total income for the seller.
  static Future<Map<String, dynamic>> getSellerEarnings(String sellerUid) async {
    final snapshot = await _orders
        .where('sellerUid', isEqualTo: sellerUid)
        .where('status', whereIn: ['confirmed', 'completed'])
        .get();

    double total = 0;
    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      total += (data['productPrice'] as num).toDouble();
    }

    return {
      'totalOrders': snapshot.docs.length,
      'totalIncome': total,
    };
  }
}

// ─── Order status constants ────────────────────────────────────────────────────
const String kOrderPending = 'pending';
const String kOrderConfirmed = 'confirmed';
const String kOrderCompleted = 'completed';
const String kOrderCancelled = 'cancelled';