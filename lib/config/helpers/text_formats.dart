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
}