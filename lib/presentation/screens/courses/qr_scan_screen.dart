import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rieu/config/helpers/helpers.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/presentation/providers/providers.dart';
import 'package:rieu/presentation/widgets/widgets.dart';

class QrScanScreen extends StatelessWidget {
  static const String name = 'qr_scan_screen';

  final String qrType;
  final String? nextRoute;

  const QrScanScreen({super.key, required this.qrType, this.nextRoute});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    String translateTypeIntoSpanish(String type) {
      switch (type) {
        case 'input':
          return 'entrada';
        case 'output':
          return 'salida';
        case 'coffe':
          return 'café';
        default:
          return '';
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _CustomQrScanner(qrType, nextRoute),
            SizedBox(height: responsive.hp(5),),
            SizedBox(
              width: responsive.wp(50),
              child: Text(
                'Escanea el código QR para registrar tu ${translateTypeIntoSpanish(qrType)}',
                style: TextStyle(
                  fontSize: responsive.ip(1.6),
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
     ),
   );
  }
}

class _CustomQrScanner extends StatelessWidget {
  final String qrType;
  final String? nextRoute;

  const _CustomQrScanner(this.qrType, this.nextRoute);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;
    final courseId = nextRoute?.split('/').last ?? 'no-id';
    final qrProvider = context.read<QrProvider>();
    final course = context.read<CourseProvider>().coursesMap[courseId];

    return SizedBox(
      width: responsive.wp(75),
      height: responsive.wp(75),
      child: Stack(
        children: [
          QRView(
            key: qrProvider.qrKey,
            onQRViewCreated: (controller) => qrProvider.onQRViewCreated(controller, qrType).then((success) {
              if (success) {
                controller.stopCamera();
                context.go('/process-completed', extra: {
                  'title': 'Asistencia Registrada',
                  'subtitle': course != null ? '${course.name}\n${TextFormats.date(DateTime.now())} ${TextFormats.time(DateTime.now())}' : null,
                  'nextRoute': nextRoute
                });
              } else {
                // TODO: Mostrar un mensaje de error
                controller.resumeCamera();
              }
            }),
            overlay: QrScannerOverlayShape(
              overlayColor: Colors.white,
              borderColor: colors.secondary,
              borderWidth: responsive.ip(1.25),
              borderLength: responsive.ip(5),
              cutOutSize: double.infinity,
            ),
          ),
          
          Animate(
            onPlay: (controller) => controller.repeat(reverse: true),
            effects: [
              MoveEffect(
                begin: Offset(0, responsive.hp(15)),
                end: Offset(0, -responsive.hp(15)),
                duration: const Duration(seconds: 3),
              ),
            ],
            child: RoundedLine(
              width: responsive.wp(65),
              height: responsive.ip(0.5),
              color: colors.primary.withOpacity(0.75),
            ),
          )
        ],
      ),
    );
  }
}