import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/vehicles/screens/vehicle_list_screen.dart';
import '../../features/vehicles/screens/vehicle_add_screen.dart';
import '../../features/fuel/screens/fuel_list_screen.dart';
import '../../features/fuel/screens/fuel_add_screen.dart';
import '../../features/maintenance/screens/maintenance_list_screen.dart';
import '../../features/maintenance/screens/maintenance_add_screen.dart';
import '../../core/widgets/main_shell.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final loggedIn = authState.value != null;
      final loggingIn = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register ||
          state.matchedLocation == AppRoutes.splash;

      if (!loggedIn && !loggingIn) return AppRoutes.login;
      if (loggedIn && loggingIn && state.matchedLocation != AppRoutes.splash) {
        return AppRoutes.dashboard;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (_, __) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.vehicles,
            builder: (_, __) => const VehicleListScreen(),
          ),
          GoRoute(
            path: AppRoutes.vehicleAdd,
            builder: (_, __) => const VehicleAddScreen(),
          ),
          GoRoute(
            path: AppRoutes.fuel,
            builder: (_, __) => const FuelListScreen(),
          ),
          GoRoute(
            path: AppRoutes.fuelAdd,
            builder: (_, __) => const FuelAddScreen(),
          ),
          GoRoute(
            path: AppRoutes.maintenance,
            builder: (_, __) => const MaintenanceListScreen(),
          ),
          GoRoute(
            path: AppRoutes.maintenanceAdd,
            builder: (_, __) => const MaintenanceAddScreen(),
          ),
        ],
      ),
    ],
  );
});
