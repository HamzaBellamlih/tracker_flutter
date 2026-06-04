import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/firestore_constants.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../models/maintenance.dart';

final maintenanceRepositoryProvider = Provider<MaintenanceRepository>((ref) {
  final uid = ref.watch(authNotifierProvider).currentUserId!;
  return MaintenanceRepository(uid);
});

class MaintenanceRepository {
  final String uid;
  MaintenanceRepository(this.uid);

  CollectionReference get _col => FirebaseFirestore.instance
      .collection(FirestoreConstants.users)
      .doc(uid)
      .collection(FirestoreConstants.maintenance);

  Stream<List<MaintenanceEntry>> watchAll() => _col
      .orderBy('date', descending: true)
      .snapshots()
      .map((s) => s.docs.map(MaintenanceEntry.fromFirestore).toList());

  Stream<List<MaintenanceEntry>> watchByDateRange(DateTime from, DateTime to) => _col
      .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
      .where('date', isLessThanOrEqualTo: Timestamp.fromDate(to))
      .orderBy('date', descending: true)
      .snapshots()
      .map((s) => s.docs.map(MaintenanceEntry.fromFirestore).toList());

  Future<void> add(MaintenanceEntry e) => _col.add(e.toFirestore());
  Future<void> delete(String id) => _col.doc(id).delete();
}
