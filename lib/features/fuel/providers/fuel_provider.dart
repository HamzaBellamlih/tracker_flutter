import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/fuel_entry.dart';
import '../repositories/fuel_repository.dart';

final fuelEntriesProvider = StreamProvider<List<FuelEntry>>((ref) {
  return ref.watch(fuelRepositoryProvider).watchAll();
});

final fuelNotifierProvider = Provider<FuelNotifier>((ref) {
  return FuelNotifier(ref.watch(fuelRepositoryProvider));
});

class FuelNotifier {
  final FuelRepository _repo;
  FuelNotifier(this._repo);

  Future<void> addEntry({
    required String vehicleId,
    required String vehicleName,
    required double liters,
    required double pricePerLiter,
    required double odometer,
    required DateTime date,
  }) {
    final entry = FuelEntry(
      id: '',
      vehicleId: vehicleId,
      vehicleName: vehicleName,
      liters: liters,
      pricePerLiter: pricePerLiter,
      totalCost: liters * pricePerLiter,
      odometer: odometer,
      date: date,
    );
    return _repo.add(entry);
  }

  Future<void> delete(String id) => _repo.delete(id);
}
