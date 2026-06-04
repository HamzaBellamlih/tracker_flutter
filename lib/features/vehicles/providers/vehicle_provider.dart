import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/vehicle.dart';
import '../repositories/vehicle_repository.dart';

final vehiclesProvider = StreamProvider<List<Vehicle>>((ref) {
  return ref.watch(vehicleRepositoryProvider).watchAll();
});

final vehicleNotifierProvider = Provider<VehicleNotifier>((ref) {
  return VehicleNotifier(ref.watch(vehicleRepositoryProvider));
});

class VehicleNotifier {
  final VehicleRepository _repo;
  VehicleNotifier(this._repo);

  Future<void> addVehicle({required String name, required String plate, required String type}) {
    final v = Vehicle(
      id: const Uuid().v4(),
      name: name,
      plate: plate,
      type: type,
      createdAt: DateTime.now(),
    );
    return _repo.add(v);
  }

  Future<void> delete(String id) => _repo.delete(id);
}
