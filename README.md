# Ascendere App

# Acerca de
Ascendere es una aplicación diseñada para facilitar la interacción entre la universidad y los estudiantes o participantes externos interesados en cursos y eventos. A través de esta plataforma, los usuarios pueden explorar las ofertas disponibles, postularse a los cursos de su interés y registrar su asistencia de manera sencilla y eficiente.

# Desarrollo
### Configuración de Firebase
1. Instalar o actualizar la CLI ➡️ [Enlace](https://firebase.google.com/docs/cli?hl=es&authuser=1#install_the_firebase_cli) 🌐
2. Iniciar sesión con la cuenta donde se creo el proyecto ⬇️
```bash
firebase login
```
3. Probar que la CLI se instalo correctamente ⬇️
```bash
firebase projects:list
```
4. Activar de forma global el flutterfire (Ejecutar el comando en cualquier directorio) ⬇️
```bash
dart pub global activate flutterfire_cli
```
5. En la raíz del directorio de la aplicación de flutter configurar el proyecto de firebase ⬇️
```bash
flutterfire configure --project=ID-del-Proyecto
```
6. Inicializar firebase y agregar el archivo de configuración en el archivo `main.dart` ⬇️
```
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...

await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
```


# Producción
1. Cambiar el nombre de la aplicación ⬇️
```bash
dart run change_app_package_name:main ec.edu.utpl.ascendere
```
2. Cambiar el icono de la aplicación (modificar el archivo `flutter_launcher_icons.yaml`) ⬇️
```bash
flutter pub get
dart run flutter_launcher_icons
```
3. Modificar la pantalla de inicio de la aplicación (modificar el archivo `flutter_native_splash.yaml`) ⬇️
```bash
dart run flutter_native_splash:create --path=flutter_native_splash.yaml

# Si se desea eliminar los cambios relizados al modificar el archivo
dart run flutter_native_splash:remove
```