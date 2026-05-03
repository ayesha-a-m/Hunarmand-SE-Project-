import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── Generate a unique chat room ID from two UIDs ─────────────────────────────
  /// Always produces the same ID regardless of who initiates the chat.
  static String _chatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  // ─── Send a message ───────────────────────────────────────────────────────────
  static Future<void> sendMessage({
    required String senderUid,
    required String receiverUid,
    required String senderName,
    required String message,
  }) async {
    final chatId = _chatId(senderUid, receiverUid);
    final chatRef = _db.collection('chats').doc(chatId);

    // Upsert the chat room metadata
    await chatRef.set({
      'participants': [senderUid, receiverUid],
      'lastMessage': message,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastSenderUid': senderUid,
    }, SetOptions(merge: true));

    // Add the message to the subcollection
    await chatRef.collection('messages').add({
      'senderUid': senderUid,
      'senderName': senderName,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });
  }

  // ─── Stream messages in a chat ────────────────────────────────────────────────
  static Stream<QuerySnapshot> getMessages(String uid1, String uid2) {
    final chatId = _chatId(uid1, uid2);
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // ─── Stream all chats for a user ──────────────────────────────────────────────
  static Stream<QuerySnapshot> getUserChats(String uid) {
    return _db
        .collection('chats')
        .where('participants', arrayContains: uid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // ─── Mark messages as read ────────────────────────────────────────────────────
  static Future<void> markAsRead(String senderUid, String receiverUid) async {
    final chatId = _chatId(senderUid, receiverUid);
    final unread = await _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('senderUid', isEqualTo: senderUid)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _db.batch();
    for (final doc in unread.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }
}