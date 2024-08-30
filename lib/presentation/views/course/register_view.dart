import 'package:flutter/material.dart';
import 'package:rieu/config/theme/responsive.dart';

class RegisterView extends StatelessWidget {
  final bool isAdmin;

  const RegisterView({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: responsive.hp(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Instrucciones:', style: texts.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
          if (isAdmin)
            buildListTile(context, 
              title: 'Registro de asistencia',
              subtitle: 'Genera el código QR para que los estudiantes puedan registrar su asistencia.'
            )
          else 
            ...[
              buildListTile(context, 
                title: '1. Registro de entrada',
                subtitle: 'Escanea el código QR proporcionado por el instructor o la institución al ingresar para registrar tu asistencia.'
              ),
              buildListTile(context, 
                title: '2. Registro de salida',
                subtitle: 'Escanea el código QR proporcionado por el instructor o la institución al salir para registrar tu asistencia.'
              ),
              buildListTile(context, 
                title: '3. Registro de comida',
                subtitle: 'Escanea el código QR designado para el registro de comida en el tiempo establecido.'
              )
            ]
          
          
        ],
      ),
    );
  }

  ListTile buildListTile(BuildContext context, {required String title, required String subtitle}) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      iconColor: colors.primary,
      title: Text(title, style: texts.bodyLarge!.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: IconButton(
        icon: Icon(isAdmin
          ? Icons.qr_code_rounded
          : Icons.qr_code_scanner_rounded, 
          size: responsive.ip(3),
        ),
        onPressed: () {}, //TODO: Desactivar el botón cuando el estudiante realice el registro correctamente
      ),
    );
  }
}