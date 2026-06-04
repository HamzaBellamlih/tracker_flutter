import 'package:cloud_firestore/cloud_firestore.dart';

class MaintenanceEntry {
  final String id;
  final String vehicleId;
  final String vehicleName;
  final String category;
  final String description;
  final double cost;
  final DateTime date;

  const MaintenanceEntry({
    required this.id,
    required this.vehicleId,
    required this.vehicleName,
    required this.category,
    required this.description,
    required this.cost,
    required this.date,
  });

  factory MaintenanceEntry.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return MaintenanceEntry(
      id: doc.id,
      vehicleId: d['vehicleId'] ?? '',
      vehicleName: d['vehicleName'] ?? '',
      category: d['category'] ?? '',
      description: d['description'] ?? '',
      cost: (d['cost'] ?? 0).toDouble(),
      date: (d['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'vehicleId': vehicleId,
    'vehicleName': vehicleName,
    'category': category,
    'description': description,
    'cost': cost,
    'date': Timestamp.fromDate(date),
  };
}
