import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/maintenance_provider.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/utils/currency_utils.dart';

class MaintenanceListScreen extends ConsumerStatefulWidget {
  const MaintenanceListScreen({super.key});
  @override
  ConsumerState<MaintenanceListScreen> createState() => _MaintenanceListScreenState();
}

class _MaintenanceListScreenState extends ConsumerState<MaintenanceListScreen> {
  DateTimeRange? _range;

  Future<void> _pickRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _range = picked);
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(maintenanceEntriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance'),
        actions: [
          IconButton(
            icon: Icon(_range != null ? Icons.filter_alt : Icons.filter_alt_outlined),
            tooltip: 'Filtrer par date',
            onPressed: _pickRange,
          ),
          if (_range != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => setState(() => _range = null),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.maintenanceAdd),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
      body: entries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (list) {
          final filtered = _range == null
              ? list
              : list.where((e) =>
                  e.date.isAfter(_range!.start.subtract(const Duration(days: 1))) &&
                  e.date.isBefore(_range!.end.add(const Duration(days: 1)))).toList();

          if (filtered.isEmpty) return const Center(child: Text('Aucune opération'));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final e = filtered[i];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.build)),
                  title: Text(e.vehicleName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${e.category} · ${DateFormat('dd/MM/yyyy').format(e.date)}\n${e.description}'),
                  isThreeLine: true,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(CurrencyUtils.format(e.cost),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18),
                        onPressed: () => ref.read(maintenanceNotifierProvider).delete(e.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
