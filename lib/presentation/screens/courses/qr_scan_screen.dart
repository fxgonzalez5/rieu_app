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
    final texts = Theme.of(context).textTheme;

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

    return PopScope(
      onPopInvoked: (_) => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CustomQrScanner(qrType, nextRoute),
              SizedBox(height: responsive.hp(5)),
              SizedBox(
                width: responsive.wp(50),
                child: Text(
                  'Escanea el código QR para registrar ${(qrType == 'coffe') ? 'el' : 'la'} ${translateTypeIntoSpanish(qrType)}',
                  style: texts.titleSmall!.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
       ),
         ),
    );
  }
}

class _CustomQrScanner extends StatefulWidget {
  final String qrType;
  final String? nextRoute;

  const _CustomQrScanner(this.qrType, this.nextRoute);

  @override
  State<_CustomQrScanner> createState() => _CustomQrScannerState();
}

class _CustomQrScannerState extends State<_CustomQrScanner> with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;
    final courseProvider = context.read<CourseProvider>();
    final user = context.read<UserProvider>().user;
    final courseId = widget.nextRoute?.split('/').last;
    final course = courseProvider.coursesMap[courseId ?? 'no-id'];

    return SizedBox.square(
      dimension: responsive.wp(75),
      child: Stack(
        children: [
          QRView(
            key: courseProvider.qrKey,
            onQRViewCreated: (controller) => courseProvider.onQRViewCreated(controller, widget.qrType).listen((success) {
              animationController.stop();
              if (success) {
                if (user.isAdmin) {
                  showAlert(context, '¡Enhorabuena!', 'Se ha registrado el recibimiento del café correctamente.',
                    onContinue: () {
                      controller.resumeCamera();
                      animationController.repeat(reverse: true);
                    }
                  );
                  return;
                } 
                context.go('/process-completed', extra: {
                  'title': 'Asistencia Registrada',
                  'subtitle': course != null ? '${course.name}\n${TextFormats.date(DateTime.now())} ${TextFormats.time(DateTime.now())}' : null,
                  'nextRoute': widget.nextRoute
                });
              } else {
                showSnackBarWhitAction(context, message: 'El código QR no es válido', onPressed: () {
                  controller.resumeCamera();
                  animationController.repeat(reverse: true);
                });
              }
            }).onError((e) {
              animationController.stop();
              showSnackBarWhitAction(context, message: e.toString().replaceAll('Exception: ', ''), onPressed: () {
                controller.resumeCamera();
                animationController.repeat(reverse: true);
              });
            }),
            overlay: QrScannerOverlayShape(
              overlayColor: Colors.white,
              borderColor: colors.secondary,
              borderWidth: responsive.ip(1.5),
              borderLength: responsive.wp(15),
              cutOutSize: double.infinity,
            ),
          ),
          
          Animate(
            controller: animationController,
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