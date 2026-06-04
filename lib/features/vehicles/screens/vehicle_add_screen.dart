import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/vehicle_provider.dart';
import '../../../app/routes/app_routes.dart';

class VehicleAddScreen extends ConsumerStatefulWidget {
  const VehicleAddScreen({super.key});
  @override
  ConsumerState<VehicleAddScreen> createState() => _VehicleAddScreenState();
}

class _VehicleAddScreenState extends ConsumerState<VehicleAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  final _plateCtrl = TextEditingController();
  String _type = 'Voiture';
  bool _loading = false;

  final _types = ['Voiture', 'Camion', 'Moto', 'Camionnette', 'Autre'];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await ref.read(vehicleNotifierProvider).addVehicle(
      name: _nameCtrl.text.trim(),
      plate: _plateCtrl.text.trim().toUpperCase(),
      type: _type,
    );
    if (mounted) context.go(AppRoutes.vehicles);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau Véhicule')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nom / Modèle', prefixIcon: Icon(Icons.directions_car_outlined)),
                validator: (v) => v!.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _plateCtrl,
                decoration: const InputDecoration(labelText: 'Immatriculation', prefixIcon: Icon(Icons.credit_card)),
                validator: (v) => v!.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Type', prefixIcon: Icon(Icons.category_outlined)),
                items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _type = v!),
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
