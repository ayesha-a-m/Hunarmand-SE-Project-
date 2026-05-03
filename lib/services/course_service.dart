import 'package:cloud_firestore/cloud_firestore.dart';

class CourseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static CollectionReference get _courses => _db.collection('courses');

  // ─── Post a course ────────────────────────────────────────────────────────────
  static Future<String> addCourse({
    required String sellerUid,
    required String sellerName,
    required String title,
    required String description,
    required String skill,
    required String city,
    required double fee,
    String level = 'Beginner',
    String? contactPhone,
  }) async {
    final doc = _courses.doc();
    await doc.set({
      'id': doc.id,
      'sellerUid': sellerUid,
      'sellerName': sellerName,
      'title': title,
      'description': description,
      'skill': skill,
      'city': city,
      'level': level,
      'contactPhone': contactPhone ?? '',
      'fee': fee,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  // ─── Get all courses ──────────────────────────────────────────────────────────
  static Stream<QuerySnapshot> getAllCourses({String? skill}) {
    Query query = _courses.orderBy('createdAt', descending: true);
    if (skill != null && skill != 'All') {
      query = query.where('skill', isEqualTo: skill);
    }
    return query.snapshots();
  }

  // ─── Get courses posted by a seller ──────────────────────────────────────────
  static Stream<QuerySnapshot> getSellerCourses(String sellerUid) {
    return _courses
        .where('sellerUid', isEqualTo: sellerUid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ─── Delete a course ─────────────────────────────────────────────────────────
  static Future<void> deleteCourse(String courseId) async {
    await _courses.doc(courseId).delete();
  }
}