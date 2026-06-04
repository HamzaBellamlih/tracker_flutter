import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/maintenance.dart';
import '../repositories/maintenance_repository.dart';

final maintenanceEntriesProvider = StreamProvider<List<MaintenanceEntry>>((ref) {
  return ref.watch(maintenanceRepositoryProvider).watchAll();
});

final maintenanceNotifierProvider = Provider<MaintenanceNotifier>((ref) {
  return MaintenanceNotifier(ref.watch(maintenanceRepositoryProvider));
});

class MaintenanceNotifier {
  final MaintenanceRepository _repo;
  MaintenanceNotifier(this._repo);

  Future<void> addEntry({
    required String vehicleId,
    required String vehicleName,
    required String category,
    required String description,
    required double cost,
    required DateTime date,
  }) {
    final entry = MaintenanceEntry(
      id: '',
      vehicleId: vehicleId,
      vehicleName: vehicleName,
      category: category,
      description: description,
      cost: cost,
      date: date,
    );
    return _repo.add(entry);
  }

  Future<void> delete(String id) => _repo.delete(id);
}
