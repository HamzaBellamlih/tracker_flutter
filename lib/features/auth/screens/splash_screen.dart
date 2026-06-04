import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../app/routes/app_routes.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (_, next) {
      next.whenData((user) {
        if (user != null) {
          context.go(AppRoutes.dashboard);
        } else {
          context.go(AppRoutes.login);
        }
      });
    });

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_gas_station, size: 72, color: Color(0xFF1565C0)),
            SizedBox(height: 24),
            Text('Tracker Fleet', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 32),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
