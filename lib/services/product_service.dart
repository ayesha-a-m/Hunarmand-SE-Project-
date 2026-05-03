import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProductService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // ─── Collections ─────────────────────────────────────────────────────────────
  static CollectionReference get _products => _db.collection('products');

  // ─── Upload product image to Firebase Storage ─────────────────────────────────
  static Future<String> uploadImage(File imageFile, String productId) async {
    final ref = _storage.ref().child('product_images/$productId.jpg');
    final task = await ref.putFile(imageFile);
    return await task.ref.getDownloadURL();
  }

  // ─── Add a new product ────────────────────────────────────────────────────────
  /// Returns the new product's document ID on success.
  static Future<String> addProduct({
    required String sellerUid,
    required String sellerName,
    required String title,
    required String description,
    required double price,
    required String category,
    String? imageUrl,
    String? city,
  }) async {
    final doc = _products.doc(); // auto-generated ID
    await doc.set({
      'id': doc.id,
      'sellerUid': sellerUid,
      'sellerName': sellerName,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl ?? '',
      'city': city ?? '',
      'isAvailable': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  // ─── Update a product ─────────────────────────────────────────────────────────
  static Future<void> updateProduct(
      String productId, {
        String? title,
        String? description,
        double? price,
        String? category,
        String? imageUrl,
        bool? isAvailable,
      }) async {
    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (title != null) updates['title'] = title;
    if (description != null) updates['description'] = description;
    if (price != null) updates['price'] = price;
    if (category != null) updates['category'] = category;
    if (imageUrl != null) updates['imageUrl'] = imageUrl;
    if (isAvailable != null) updates['isAvailable'] = isAvailable;

    await _products.doc(productId).update(updates);
  }

  // ─── Delete a product ─────────────────────────────────────────────────────────
  static Future<void> deleteProduct(String productId) async {
    await _products.doc(productId).delete();
    // Also remove image from storage if it exists
    try {
      await _storage.ref('product_images/$productId.jpg').delete();
    } catch (_) {
      // Image may not exist — ignore
    }
  }

  // ─── Get all products (for customers - browse) ────────────────────────────────
  static Stream<QuerySnapshot> getAllProducts({String? category}) {
    Query query = _products
        .where('isAvailable', isEqualTo: true)
        .orderBy('createdAt', descending: true);

    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }
    return query.snapshots();
  }

  // ─── Get products by seller ───────────────────────────────────────────────────
  static Stream<QuerySnapshot> getSellerProducts(String sellerUid) {
    return _products
        .where('sellerUid', isEqualTo: sellerUid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ─── Search products by keyword ───────────────────────────────────────────────
  /// Simple prefix search on title (Firestore doesn't support full-text search natively).
  static Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    final lower = query.toLowerCase();
    final snapshot = await _products
        .where('isAvailable', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((d) => d.data() as Map<String, dynamic>)
        .where((p) =>
    (p['title'] as String).toLowerCase().contains(lower) ||
        (p['category'] as String).toLowerCase().contains(lower))
        .toList();
  }

  // ─── Get single product ───────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> getProduct(String productId) async {
    final doc = await _products.doc(productId).get();
    return doc.exists ? doc.data() as Map<String, dynamic> : null;
  }
}

// ─── Product categories (shared constant) ─────────────────────────────────────
const List<String> kProductCategories = [
  'All',
  'Embroidery',
  'Stitching',
  'Pottery',
  'Accessories',
  'Jewellery',
  'Home Decor',
  'Clothing',
  'Other',
];