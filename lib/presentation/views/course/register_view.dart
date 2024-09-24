import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/presentation/providers/providers.dart';

class RegisterView extends StatelessWidget {
  final String courseId;

  const RegisterView({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;
    final user = context.read<UserProvider>().user;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: responsive.hp(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Instrucciones:', style: texts.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
          if (user.isAdmin)
            ...[
              buildListTile(context, icon: Icons.qr_code_rounded,
                title: 'Registro de asistencia',
                subtitle: 'Genera el código QR para que los usuarios puedan registrar su asistencia.',
                onPressed: () => context.push('${GoRouterState.of(context).matchedLocation}/qr-generation', extra: courseId),
              ),
              buildListTile(context,
                title: 'Registro de comida',
                subtitle: 'Escanea el código QR del usuario para registrar que ha recibido su café.',
                onPressed: () => context.push('${GoRouterState.of(context).matchedLocation}/qr-scan/coffe'),
              ),
            ]
          else 
            ...[
              buildListTile(context, 
                title: '1. Registro de entrada',
                subtitle: 'Escanea el código QR proporcionado por el instructor o la institución al ingresar para registrar tu asistencia.',
                onPressed: () {
                  //TODO: Desactivar el botón cuando el estudiante realice el registro correctamente
                  context.push('${GoRouterState.of(context).matchedLocation}/qr-scan/input', extra: GoRouterState.of(context).matchedLocation);
                },
              ),
              buildListTile(context, 
                title: '2. Registro de salida',
                subtitle: 'Escanea el código QR proporcionado por el instructor o la institución al salir para registrar tu asistencia.',
                onPressed: () {
                  //TODO: Desactivar el botón cuando el estudiante realice el registro correctamente
                  context.push('${GoRouterState.of(context).matchedLocation}/qr-scan/output', extra: GoRouterState.of(context).matchedLocation);
                },
              ),
              buildListTile(context, icon: Icons.qr_code_rounded,
                title: '3. Registro de comida',
                subtitle: 'Genera el código QR para que puedas registrar que has recibido tu café.',
                onPressed: () => context.push('${GoRouterState.of(context).matchedLocation}/qr-generation', extra: courseId),
              )
            ]
        ],
      ),
    );
  }

  ListTile buildListTile(BuildContext context, {IconData icon = Icons.qr_code_scanner_rounded, required String title, required String subtitle, VoidCallback? onPressed}) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      iconColor: colors.primary,
      title: Text(title, style: texts.bodyLarge!.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: IconButton(
        icon: Icon(icon, 
          size: responsive.ip(3),
        ),
        onPressed: onPressed,
      ),
    );
  }
}