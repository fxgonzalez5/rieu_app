import 'dart:math' as math;
import 'package:flutter/widgets.dart'; 

class Responsive {

  // Propiedades privadas para almacenar ancho, alto y diagonal de la pantalla
  double _width = 0;  
  double _height = 0;
  double _inch = 0;

  // Constructor que recibe context para acceder a MediaQuery
  Responsive(BuildContext context) {

    // Obtiene el tamaño de la pantalla
    final size = MediaQuery.of(context).size;

    // Almacena ancho y alto
    _width = size.width;  
    _height = size.height;

    // Calcula la diagonal usando Pitágoras 
    _inch = math.sqrt(math.pow(_width, 2) + math.pow(_height, 2));

  }

  // Devuelve porcentaje del ancho
  double wp(double percent) {
    return _width * percent / 100;
  }
  
  // Devuelve porcentaje del alto
  double hp(double percent) {
    return _height * percent / 100;
  }

  // Devuelve porcentaje de la diagonal
  double ip(double percent) {
    return _inch * percent / 100;
  }

}