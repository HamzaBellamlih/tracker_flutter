import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/fuel_provider.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/utils/currency_utils.dart';

class FuelListScreen extends ConsumerWidget {
  const FuelListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(fuelEntriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pleins de Gasoil')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.fuelAdd),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
      body: entries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (list) => list.isEmpty
            ? const Center(child: Text('Aucun plein enregistré'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final e = list[i];
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.local_gas_station)),
                      title: Text(e.vehicleName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        '${e.liters.toStringAsFixed(1)} L · ${DateFormat('dd/MM/yyyy').format(e.date)}',
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(CurrencyUtils.format(e.totalCost),
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18),
                            onPressed: () => ref.read(fuelNotifierProvider).delete(e.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
