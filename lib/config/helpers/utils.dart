import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(String link) async {
  final Uri url = Uri.parse(link);

  if (!await launchUrl(url)) {
    throw 'No se ha podido abrir el siguiente enlace: $url';
  }
}
