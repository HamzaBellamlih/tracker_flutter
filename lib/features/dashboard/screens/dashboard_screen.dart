import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/dashboard_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../app/routes/app_routes.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authNotifierProvider).logout(),
          ),
        ],
      ),
      body: stats.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (s) => RefreshIndicator(
          onRefresh: () async {},
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // KPI Cards
              Row(children: [
                _KpiCard(icon: Icons.directions_car, label: 'Véhicules', value: '${s.vehicleCount}', color: colors.primary),
                const SizedBox(width: 12),
                _KpiCard(icon: Icons.opacity, label: 'Litres totaux', value: '${s.totalLiters.toStringAsFixed(0)} L', color: Colors.blue),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                _KpiCard(icon: Icons.local_gas_station, label: 'Gasoil total', value: CurrencyUtils.format(s.totalFuelCost), color: Colors.orange),
                const SizedBox(width: 12),
                _KpiCard(icon: Icons.build, label: 'Maintenance', value: CurrencyUtils.format(s.totalMaintenanceCost), color: Colors.red),
              ]),
              const SizedBox(height: 24),

              // Répartition dépenses
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Répartition des dépenses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 160,
                        child: Row(
                          children: [
                            Expanded(
                              child: PieChart(PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    value: s.totalFuelCost > 0 ? s.totalFuelCost : 70,
                                    color: Colors.orange,
                                    title: '${s.total > 0 ? (s.totalFuelCost / s.total * 100).toStringAsFixed(0) : 70}%',
                                    radius: 60,
                                    titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  PieChartSectionData(
                                    value: s.totalMaintenanceCost > 0 ? s.totalMaintenanceCost : 30,
                                    color: Colors.red,
                                    title: '${s.total > 0 ? (s.totalMaintenanceCost / s.total * 100).toStringAsFixed(0) : 30}%',
                                    radius: 60,
                                    titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Legend(color: Colors.orange, label: 'Gasoil (70%)'),
                                const SizedBox(height: 8),
                                _Legend(color: Colors.red, label: 'Maintenance (30%)'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Graphe mensuel
              if (s.monthlyStats.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Dépenses par mois', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barGroups: s.monthlyStats.asMap().entries.map((e) {
                                return BarChartGroupData(
                                  x: e.key,
                                  barRods: [
                                    BarChartRodData(
                                      toY: e.value.fuelCost,
                                      color: Colors.orange,
                                      width: 10,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    BarChartRodData(
                                      toY: e.value.maintenanceCost,
                                      color: Colors.red,
                                      width: 10,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                );
                              }).toList(),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (v, _) {
                                      final idx = v.toInt();
                                      if (idx < 0 || idx >= s.monthlyStats.length) return const SizedBox();
                                      final key = s.monthlyStats[idx].monthKey;
                                      return Text(key.substring(5), style: const TextStyle(fontSize: 10));
                                    },
                                  ),
                                ),
                                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              gridData: const FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Quick Actions
              const Text('Actions rapides', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: OutlinedButton.icon(
                  onPressed: () => context.go(AppRoutes.vehicleAdd),
                  icon: const Icon(Icons.add),
                  label: const Text('Véhicule'),
                )),
                const SizedBox(width: 12),
                Expanded(child: OutlinedButton.icon(
                  onPressed: () => context.go(AppRoutes.fuelAdd),
                  icon: const Icon(Icons.local_gas_station),
                  label: const Text('Plein'),
                )),
                const SizedBox(width: 12),
                Expanded(child: OutlinedButton.icon(
                  onPressed: () => context.go(AppRoutes.maintenanceAdd),
                  icon: const Icon(Icons.build),
                  label: const Text('Maintenance'),
                )),
              ]),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _KpiCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
