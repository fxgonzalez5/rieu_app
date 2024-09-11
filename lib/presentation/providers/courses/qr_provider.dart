import 'package:flutter/widgets.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrProvider extends ChangeNotifier {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Future<bool> onQRViewCreated(QRViewController controller, String qrType) {
    return controller.scannedDataStream.map((scanData) {
      final result = scanData.code;

      if (result != null && result.trim().isNotEmpty) {
        print(result);
        return true;
      }
      return false;
    }).firstWhere((isValid) => isValid, orElse: () => false);
  }
}