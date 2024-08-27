import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rieu/infrastructure/services/services.dart';
import 'package:rieu/presentation/providers/providers.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
      ),
      body: Center(
        child: FilledButton(
          onPressed: () => context.read<AuthProvider>().logoutUser(authServices: [GoogleSingInService()]), 
          child: const Text('Cerrar sesión')
        ),
      ),
   );
  }
}