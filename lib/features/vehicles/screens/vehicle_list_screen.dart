import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/vehicle_provider.dart';
import '../../../app/routes/app_routes.dart';

class VehicleListScreen extends ConsumerWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicles = ref.watch(vehiclesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes Véhicules')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.vehicleAdd),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
      body: vehicles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (list) => list.isEmpty
            ? const Center(child: Text('Aucun véhicule'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final v = list[i];
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.directions_car)),
                      title: Text(v.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${v.plate} · ${v.type}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => ref.read(vehicleNotifierProvider).delete(v.id),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
