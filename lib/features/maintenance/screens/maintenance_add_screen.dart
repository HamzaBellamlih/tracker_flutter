import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../vehicles/providers/vehicle_provider.dart';
import '../../vehicles/models/vehicle.dart';
import '../providers/maintenance_provider.dart';
import '../../../app/routes/app_routes.dart';

class MaintenanceAddScreen extends ConsumerStatefulWidget {
  const MaintenanceAddScreen({super.key});
  @override
  ConsumerState<MaintenanceAddScreen> createState() => _MaintenanceAddScreenState();
}

class _MaintenanceAddScreenState extends ConsumerState<MaintenanceAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _costCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  Vehicle? _selectedVehicle;
  String _category = 'Vidange';
  DateTime _date = DateTime.now();
  bool _loading = false;

  final _categories = ['Vidange', 'Pneus', 'Freins', 'Courroie', 'Filtre', 'Révision', 'Autre'];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedVehicle == null) return;
    setState(() => _loading = true);
    await ref.read(maintenanceNotifierProvider).addEntry(
      vehicleId: _selectedVehicle!.id,
      vehicleName: _selectedVehicle!.name,
      category: _category,
      description: _descCtrl.text.trim(),
      cost: double.parse(_costCtrl.text),
      date: _date,
    );
    if (mounted) context.go(AppRoutes.maintenance);
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = ref.watch(vehiclesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle Opération')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              vehicles.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('Erreur: $e'),
                data: (list) => DropdownButtonFormField<Vehicle>(
                  decoration: const InputDecoration(labelText: 'Véhicule', prefixIcon: Icon(Icons.directions_car_outlined)),
                  items: list.map((v) => DropdownMenuItem(value: v, child: Text('${v.name} (${v.plate})'))).toList(),
                  onChanged: (v) => setState(() => _selectedVehicle = v),
                  validator: (_) => _selectedVehicle == null ? 'Sélectionner un véhicule' : null,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Catégorie', prefixIcon: Icon(Icons.category_outlined)),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Description', prefixIcon: Icon(Icons.notes)),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _costCtrl,
                decoration: const InputDecoration(labelText: 'Coût', prefixIcon: Icon(Icons.attach_money), suffixText: 'MAD'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: Text('Date : ${_date.day}/${_date.month}/${_date.year}'),
                onTap: _pickDate,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading ? const CircularProgressIndicator() : const Text('Enregistrer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
