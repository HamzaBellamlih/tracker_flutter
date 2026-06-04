import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/firestore_constants.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../models/fuel_entry.dart';

final fuelRepositoryProvider = Provider<FuelRepository>((ref) {
  final uid = ref.watch(authNotifierProvider).currentUserId!;
  return FuelRepository(uid);
});

class FuelRepository {
  final String uid;
  FuelRepository(this.uid);

  CollectionReference get _col => FirebaseFirestore.instance
      .collection(FirestoreConstants.users)
      .doc(uid)
      .collection(FirestoreConstants.fuelEntries);

  Stream<List<FuelEntry>> watchAll() => _col
      .orderBy('date', descending: true)
      .snapshots()
      .map((s) => s.docs.map(FuelEntry.fromFirestore).toList());

  Stream<List<FuelEntry>> watchByVehicle(String vehicleId) => _col
      .where('vehicleId', isEqualTo: vehicleId)
      .orderBy('date', descending: true)
      .snapshots()
      .map((s) => s.docs.map(FuelEntry.fromFirestore).toList());

  Future<void> add(FuelEntry e) => _col.add(e.toFirestore());
  Future<void> delete(String id) => _col.doc(id).delete();
}
