import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../fuel/providers/fuel_provider.dart';
import '../../maintenance/providers/maintenance_provider.dart';
import '../../vehicles/providers/vehicle_provider.dart';

class MonthStats {
  final String monthKey;
  final double fuelCost;
  final double maintenanceCost;

  const MonthStats({
    required this.monthKey,
    required this.fuelCost,
    required this.maintenanceCost,
  });

  double get total => fuelCost + maintenanceCost;
  double get fuelPercent => total == 0 ? 70 : (fuelCost / total) * 100;
  double get maintenancePercent => total == 0 ? 30 : (maintenanceCost / total) * 100;
}

class DashboardStats {
  final int vehicleCount;
  final double totalFuelCost;
  final double totalMaintenanceCost;
  final double totalLiters;
  final List<MonthStats> monthlyStats;

  const DashboardStats({
    required this.vehicleCount,
    required this.totalFuelCost,
    required this.totalMaintenanceCost,
    required this.totalLiters,
    required this.monthlyStats,
  });

  double get total => totalFuelCost + totalMaintenanceCost;
}

final dashboardStatsProvider = Provider<AsyncValue<DashboardStats>>((ref) {
  final vehicles   = ref.watch(vehiclesProvider);
  final fuel       = ref.watch(fuelEntriesProvider);
  final maintenance = ref.watch(maintenanceEntriesProvider);

  if (vehicles.isLoading || fuel.isLoading || maintenance.isLoading) {
    return const AsyncValue.loading();
  }

  final vList = vehicles.value ?? [];
  final fList = fuel.value ?? [];
  final mList = maintenance.value ?? [];

  // Build monthly map
  final Map<String, MonthStats> monthly = {};

  for (final f in fList) {
    final key = '${f.date.year}-${f.date.month.toString().padLeft(2, '0')}';
    final prev = monthly[key] ?? MonthStats(monthKey: key, fuelCost: 0, maintenanceCost: 0);
    monthly[key] = MonthStats(
      monthKey: key,
      fuelCost: prev.fuelCost + f.totalCost,
      maintenanceCost: prev.maintenanceCost,
    );
  }

  for (final m in mList) {
    final key = '${m.date.year}-${m.date.month.toString().padLeft(2, '0')}';
    final prev = monthly[key] ?? MonthStats(monthKey: key, fuelCost: 0, maintenanceCost: 0);
    monthly[key] = MonthStats(
      monthKey: key,
      fuelCost: prev.fuelCost,
      maintenanceCost: prev.maintenanceCost + m.cost,
    );
  }

  final sortedMonths = monthly.values.toList()
    ..sort((a, b) => a.monthKey.compareTo(b.monthKey));

  return AsyncValue.data(DashboardStats(
    vehicleCount: vList.length,
    totalFuelCost: fList.fold(0, (s, e) => s + e.totalCost),
    totalMaintenanceCost: mList.fold(0, (s, e) => s + e.cost),
    totalLiters: fList.fold(0, (s, e) => s + e.liters),
    monthlyStats: sortedMonths.take(6).toList(),
  ));
});
