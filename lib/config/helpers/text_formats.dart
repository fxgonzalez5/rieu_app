import 'package:intl/intl.dart';

class TextFormats {
  static String getInitials(String name) {
    List<String> words = name.trim().split(" ");
    
    // Si solo hay una palabra, toma las dos primeras letras (o una si solo hay una letra)
    if (words.length == 1) {
      return words.first[0].toUpperCase() + (words.first.length > 1 ? words.first[1].toUpperCase() : "");
    }
    
    // Devuelve las iniciales de la primera y la última palabra en mayúsculas
    return (words.first[0] + words.last[0]).toUpperCase();
  }

  static List<String> splitTextIntoLines(String text) {
    final List<String> lines = text.split('\n');
    final List<String> trimmedLines = [];

    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i].trim();
      if (line.isNotEmpty) {
        trimmedLines.add(line);
      }
    }

    return trimmedLines;
  }

  static String extractNameAndLastName(String fullName) {
    // Eliminar el título si lo hay
    final fullNameNoTitle = fullName.substring(fullName.indexOf('.') + 1).trim();
    
    // Dividir el nombre en palabras
    List<String> nameParts = fullNameNoTitle.split(' ');
    
    // Si solo hay una palabra, devolverla como está
    if (nameParts.length == 1) return nameParts.first;
    
    // Si hay dos palabras, devolverlas como están
    if (nameParts.length == 2) return '${nameParts.first} ${nameParts.last}';

    // Si hay más de dos palabras, eliminar los conectores de nombres y devolver la primera más última palabra
    List<String> nameConnectors = ['de', 'del', 'la', 'el', 'las', 'los'];
    if (nameConnectors.contains(nameParts[1].toLowerCase())) {
      if (nameParts.length == 3) return '${nameParts.first} ${nameParts[1]} ${nameParts.last}';
      if (nameConnectors.contains(nameParts[2].toLowerCase()) || nameParts.length == 4) return '${nameParts.first} ${nameParts[1]} ${nameParts[2]} ${nameParts[3]}';
      return '${nameParts.first} ${nameParts[3]}';
    }

    if (nameParts.length > 4) return '${nameParts.first} ${nameParts[nameParts.length - 2]}';
    
    return '${nameParts.first} ${nameParts[2]}';
  }

  static String date(DateTime dateTime) {
    final formatter = DateFormat('dd/MM/yyyy');

    return formatter.format(dateTime);
  }

  static String time(DateTime dateTime) {
    final formatter = DateFormat('HH:mm a');

    return formatter.format(dateTime);
  }
}