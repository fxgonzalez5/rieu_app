import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/presentation/providers/providers.dart';


class QrGenerationScreen extends StatelessWidget {
  static const String name = 'qr_generation_screen';

  final String courseId;

  const QrGenerationScreen({
    super.key,
    required this.courseId
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;
    final user = context.read<UserProvider>().user;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _CustomQrImage(courseId, user),
            SizedBox(height: responsive.hp(5),),
            SizedBox(
              width: responsive.wp(70),
              child: Text( user.isAdmin
                ? 'Este código QR sirve para que los usuarios puedan registrar su asistencia de entrada y salida'
                : 'Este código QR sirve para que puedas registrar que has recibido tu café',
                style: texts.titleSmall!.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomQrImage extends StatelessWidget {
  final String courseId;
  final UserEntity user;

  const _CustomQrImage(this.courseId, this.user);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: colors.primary,
          width: responsive.ip(1),
          strokeAlign: BorderSide.strokeAlignOutside
        ),
      ),
      child: SizedBox.square(
        dimension: responsive.wp(75),
        child: QrImageView(
          data: '''{
"userId": "${user.id}",
"date": "${DateTime.now()}",
"courseId": "$courseId"
}''',
          version: QrVersions.auto,
        ),
      ),
    );
  }
}
