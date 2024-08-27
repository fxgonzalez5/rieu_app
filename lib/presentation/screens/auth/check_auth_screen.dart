import 'package:flutter/material.dart';

class CheckAuthScreen extends StatelessWidget {
  static const String name = 'check_auth_screen';

  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
   );
  }
}