import 'package:cloud_firestore/cloud_firestore.dart';

class AdminLogService {
  AdminLogService(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> logAction({
    required String adminId,
    required String action,
    required String target,
    Map<String, dynamic>? before,
    Map<String, dynamic>? after,
  }) async {
    await _firestore.collection('admin_logs').add({
      'adminId': adminId,
      'action': action,
      'target': target,
      'before': before,
      'after': after,
      'status': 'completed',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'createdBy': adminId,
    });
  }
}
