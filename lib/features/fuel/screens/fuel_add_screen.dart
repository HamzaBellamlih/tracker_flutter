import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../vehicles/providers/vehicle_provider.dart';
import '../../vehicles/models/vehicle.dart';
import '../providers/fuel_provider.dart';
import '../../../app/routes/app_routes.dart';

class FuelAddScreen extends ConsumerStatefulWidget {
  const FuelAddScreen({super.key});
  @override
  ConsumerState<FuelAddScreen> createState() => _FuelAddScreenState();
}

class _FuelAddScreenState extends ConsumerState<FuelAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _litersCtrl = TextEditingController();
  final _priceCtrl  = TextEditingController();
  final _odoCtrl    = TextEditingController();
  Vehicle? _selectedVehicle;
  DateTime _date = DateTime.now();
  bool _loading = false;

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
    await ref.read(fuelNotifierProvider).addEntry(
      vehicleId: _selectedVehicle!.id,
      vehicleName: _selectedVehicle!.name,
      liters: double.parse(_litersCtrl.text),
      pricePerLiter: double.parse(_priceCtrl.text),
      odometer: double.parse(_odoCtrl.text),
      date: _date,
    );
    if (mounted) context.go(AppRoutes.fuel);
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = ref.watch(vehiclesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau Plein')),
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
              TextFormField(
                controller: _litersCtrl,
                decoration: const InputDecoration(labelText: 'Litres', prefixIcon: Icon(Icons.opacity), suffixText: 'L'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(labelText: 'Prix / Litre', prefixIcon: Icon(Icons.attach_money), suffixText: 'MAD'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _odoCtrl,
                decoration: const InputDecoration(labelText: 'Kilométrage', prefixIcon: Icon(Icons.speed), suffixText: 'km'),
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
