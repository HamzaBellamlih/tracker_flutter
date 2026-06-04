import 'package:cloud_firestore/cloud_firestore.dart';

class FuelEntry {
  final String id;
  final String vehicleId;
  final String vehicleName;
  final double liters;
  final double pricePerLiter;
  final double totalCost;
  final double odometer;
  final DateTime date;

  const FuelEntry({
    required this.id,
    required this.vehicleId,
    required this.vehicleName,
    required this.liters,
    required this.pricePerLiter,
    required this.totalCost,
    required this.odometer,
    required this.date,
  });

  factory FuelEntry.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return FuelEntry(
      id: doc.id,
      vehicleId: d['vehicleId'] ?? '',
      vehicleName: d['vehicleName'] ?? '',
      liters: (d['liters'] ?? 0).toDouble(),
      pricePerLiter: (d['pricePerLiter'] ?? 0).toDouble(),
      totalCost: (d['totalCost'] ?? 0).toDouble(),
      odometer: (d['odometer'] ?? 0).toDouble(),
      date: (d['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'vehicleId': vehicleId,
    'vehicleName': vehicleName,
    'liters': liters,
    'pricePerLiter': pricePerLiter,
    'totalCost': totalCost,
    'odometer': odometer,
    'date': Timestamp.fromDate(date),
  };
}
