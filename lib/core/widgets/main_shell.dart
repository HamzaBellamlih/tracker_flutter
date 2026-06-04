import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/routes/app_routes.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/vehicles')) return 1;
    if (location.startsWith('/fuel'))     return 2;
    if (location.startsWith('/maintenance')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _currentIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) {
          switch (i) {
            case 0: context.go(AppRoutes.dashboard); break;
            case 1: context.go(AppRoutes.vehicles);  break;
            case 2: context.go(AppRoutes.fuel);      break;
            case 3: context.go(AppRoutes.maintenance); break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.directions_car_outlined), selectedIcon: Icon(Icons.directions_car), label: 'Véhicules'),
          NavigationDestination(icon: Icon(Icons.local_gas_station_outlined), selectedIcon: Icon(Icons.local_gas_station), label: 'Gasoil'),
          NavigationDestination(icon: Icon(Icons.build_outlined), selectedIcon: Icon(Icons.build), label: 'Maintenance'),
        ],
      ),
    );
  }
}
