import 'package:flutter/material.dart';
import 'package:rieu/config/theme/responsive.dart';

class CheckAuthScreen extends StatelessWidget {
  static const String name = 'check_auth_screen';

  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      body: Center(
        child: Image(
          image: const AssetImage('assets/loaders/spin_loading.gif'),
          width: responsive.wp(15),
        ),
      ),
   );
  }
}