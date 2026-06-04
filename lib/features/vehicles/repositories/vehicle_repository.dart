import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/firestore_constants.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../models/vehicle.dart';

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  final uid = ref.watch(authNotifierProvider).currentUserId!;
  return VehicleRepository(uid);
});

class VehicleRepository {
  final String uid;
  VehicleRepository(this.uid);

  CollectionReference get _col => FirebaseFirestore.instance
      .collection(FirestoreConstants.users)
      .doc(uid)
      .collection(FirestoreConstants.vehicles);

  Stream<List<Vehicle>> watchAll() => _col
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map(Vehicle.fromFirestore).toList());

  Future<void> add(Vehicle v) => _col.add(v.toFirestore());
  Future<void> delete(String id) => _col.doc(id).delete();
}
