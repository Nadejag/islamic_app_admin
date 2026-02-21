import 'package:cloud_firestore/cloud_firestore.dart';

class UserAdminRepository {
  UserAdminRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Query<Map<String, dynamic>> usersQuery({
    String? search,
    String? status,
  }) {
    var query = _firestore.collection('users').orderBy('updatedAt', descending: true);
    if (status != null && status.isNotEmpty) {
      query = query.where('status', isEqualTo: status);
    }
    if (search != null && search.isNotEmpty) {
      query = query.where('keywords', arrayContains: search.toLowerCase());
    }
    return query;
  }

  Future<void> updateUserStatus({
    required String userId,
    required String status,
  }) async {
    await _firestore.collection('users').doc(userId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
