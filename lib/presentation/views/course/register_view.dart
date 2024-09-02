import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/presentation/providers/providers.dart';

class RegisterView extends StatelessWidget {

  const RegisterView({super.key});

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
            buildListTile(context, 
              title: 'Registro de asistencia',
              subtitle: 'Genera el código QR para que los estudiantes puedan registrar su asistencia.',
              onPressed: () {}, // TODO: Navegar a la pantalla que genera el QR
            )
          else 
            ...[
              buildListTile(context, 
                title: '1. Registro de entrada',
                subtitle: 'Escanea el código QR proporcionado por el instructor o la institución al ingresar para registrar tu asistencia.',
                onPressed: () {}, //TODO: Desactivar el botón cuando el estudiante realice el registro correctamente
              ),
              buildListTile(context, 
                title: '2. Registro de salida',
                subtitle: 'Escanea el código QR proporcionado por el instructor o la institución al salir para registrar tu asistencia.',
                onPressed: () {}, //TODO: Desactivar el botón cuando el estudiante realice el registro correctamente
              ),
              buildListTile(context, 
                title: '3. Registro de comida',
                subtitle: 'Escanea el código QR designado para el registro de comida en el tiempo establecido.',
                onPressed: () {}, //TODO: Desactivar el botón cuando el estudiante realice el registro correctamente
              )
            ]
        ],
      ),
    );
  }

  ListTile buildListTile(BuildContext context, {required String title, required String subtitle, VoidCallback? onPressed}) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    final user = context.read<UserProvider>().user;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      iconColor: colors.primary,
      title: Text(title, style: texts.bodyLarge!.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: IconButton(
        icon: Icon(user.isAdmin
          ? Icons.qr_code_rounded
          : Icons.qr_code_scanner_rounded, 
          size: responsive.ip(3),
        ),
        onPressed: onPressed,
      ),
    );
  }
}