import 'package:flutter/material.dart';
import 'package:rieu/config/theme/responsive.dart';

class AppTheme {
  static const Color _primary =  Color(0xff00ACC1);
  static const Color _secondary =  Color(0xffFFBA30);
  
  final bool isDarkMode;

  AppTheme({
    this.isDarkMode = false
  });

  ThemeData getTheme(BuildContext context) => ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: MaterialColor(_primary.value, const {}),
      accentColor: _secondary,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
    ),

    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: Responsive(context).ip(3.6),
      ),
      headlineSmall: TextStyle(
        fontSize: Responsive(context).ip(2.6),
      ),
      titleLarge: TextStyle(
        fontSize: Responsive(context).ip(2),
        fontWeight: FontWeight.w600
      ),
      titleMedium: TextStyle(
        fontSize: Responsive(context).ip(1.8),
        fontWeight: FontWeight.normal
      ),
      titleSmall: TextStyle(
        fontSize: Responsive(context).ip(1.6),
        fontWeight: FontWeight.normal
      ),
      bodyLarge: TextStyle(
        fontSize: Responsive(context).ip(1.5),
      ),
      bodyMedium: TextStyle(
        fontSize: Responsive(context).ip(1.4),
      ),
    ),

    iconTheme: IconThemeData(
      size: Responsive(context).ip(2.5),
    ),

    tabBarTheme: TabBarTheme(
      indicatorColor: _secondary,
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: _secondary,
      dividerColor: Colors.grey.shade300
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      labelStyle: const TextStyle(color: _secondary),
      hintStyle: const TextStyle(color: Colors.grey),
      errorMaxLines: 5,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _secondary.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(Responsive(context).ip(1))
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(Responsive(context).ip(1))
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _secondary.withOpacity(0.5),),
        borderRadius: BorderRadius.circular(Responsive(context).ip(1))
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 1.5),
        borderRadius: BorderRadius.circular(Responsive(context).ip(1))
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        textStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: Responsive(context).ip(1.4)),
        ),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive(context).ip(1)))
        ),
        textStyle: WidgetStatePropertyAll(
          TextStyle(
            fontSize: Responsive(context).ip(1.4),
            fontWeight: FontWeight.w600
          ),
        ),
      ),
    ),
  );

}