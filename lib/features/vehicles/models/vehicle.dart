import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  final String id;
  final String name;
  final String plate;
  final String type;
  final DateTime createdAt;

  const Vehicle({
    required this.id,
    required this.name,
    required this.plate,
    required this.type,
    required this.createdAt,
  });

  factory Vehicle.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Vehicle(
      id: doc.id,
      name: data['name'] ?? '',
      plate: data['plate'] ?? '',
      type: data['type'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'plate': plate,
    'type': type,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}
