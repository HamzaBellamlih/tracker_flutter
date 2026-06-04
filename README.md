# Tracker Fleet — Flutter SAAS

Application mobile de suivi gasoil et maintenance par véhicule.

## Stack
- Flutter 3.x
- GoRouter — navigation
- Riverpod — gestion d'état
- Firebase Auth — authentification email/password
- Cloud Firestore — base de données isolée par client
- fl_chart — graphiques dashboard
- Dio — client HTTP (prêt pour API externe)

## Structure Firestore
```
users/{uid}/
  vehicles/{vehicleId}
  fuel_entries/{entryId}
  maintenance/{entryId}
```

## Setup Firebase
1. Créer un projet Firebase
2. Activer Authentication (Email/Password)
3. Activer Cloud Firestore
4. Télécharger `google-services.json` → placer dans `android/app/`
5. Télécharger `GoogleService-Info.plist` → placer dans `ios/Runner/`

## Démarrer
```bash
flutter pub get
flutter run
```

## Features
- ✅ Auth Firebase (login / register / logout)
- ✅ Gestion des véhicules (ajout / suppression)
- ✅ Enregistrement des pleins (litres, prix, km)
- ✅ Opérations de maintenance (catégorie, coût, date)
- ✅ Dashboard KPI (véhicules, litres, coûts)
- ✅ Répartition dépenses 70% gasoil / 30% maintenance (PieChart)
- ✅ Graphe dépenses mensuelles (BarChart)
- ✅ Filtrage maintenance par date
- ✅ Données isolées par client (uid Firestore)
