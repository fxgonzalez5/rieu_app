import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rieu/infrastructure/services/google_sign_in_service.dart';
import 'package:rieu/presentation/widgets/widgets.dart';
import 'package:rieu/config/theme/responsive.dart';

class LoginScreen extends StatelessWidget {
  static const String name = 'login_screen';
  
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final responsive = Responsive(context);

    return  Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: AuthBackground(
            child: SizedBox(
              height: responsive.hp(100) - statusBarHeight,
              child: Column(
                  children: [
                    SizedBox(height: responsive.hp(35)),
                    const _TextSection(),
                    SizedBox(height: responsive.hp(3)),
                    const _LoginMethods(),
                    const _FormContainer(),
                  ],
                ),
            ),
          ),
        ),
      )
   );
  }
}

class _FormContainer extends StatelessWidget {
  const _FormContainer();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: responsive.hp(2), horizontal: responsive.wp(7.5)),
        child: Form(
            // TODO: crear la llave del formulario
            // key: ,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const CustomTextFormField(
                  label: 'Correo',
                  hint: 'usuario@utpl.edu.ec'
                ),
                const CustomTextFormField(
                  label: 'Contraseña',
                  hint: '********',
                  noVisibility: true,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: const Text('Olvidaste tu contraseña?'),
                    onPressed: () {
                      // TODO: Navegar a la pantalla para restablecer la contraseña
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: responsive.hp(6),
                  child: FilledButton(
                    child: const Text('Iniciar Sesión'),
                    onPressed: () async {
                      // TODO: Validar la autenticación y navegar a la pantalla principal
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: responsive.hp(6),
                  child: FilledButton(
                    child: const Text('Registrarse'),
                    onPressed: () => context.push('/register'),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}


class _LoginMethods extends StatelessWidget {
  const _LoginMethods();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildInkWell(
          responsive: responsive,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(responsive.ip(0.5)),
            child: Image.asset('assets/images/logo_utpl.png', width: responsive.ip(6)),
          ),
          onTap: () {},
        ),
        SizedBox(width: responsive.wp(10)),
        buildInkWell(
          responsive: responsive,
          child: Image.asset('assets/images/logo_google.png', width: responsive.ip(6)),
          onTap: () async {
            final credential = await GoogleSingInService.signInWithGoogle();
            if (credential != null) {} // TODO: Navegar a la pantalla principal
          },
        )
      ]
    );


  }

  InkWell buildInkWell({required Responsive responsive, required Widget child, GestureTapCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(responsive.ip(6)),
      splashColor: Colors.grey[300],
      splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
      onTap: onTap,
      child: child
    );
  }
}

class _TextSection extends StatelessWidget {
  const _TextSection();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          'Ascendere',
          style: texts.displayLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary
          ),
        ),
        SizedBox(height: responsive.hp(3)),
        Text(
          'Inicia sesión mediante',
          style: texts.bodyLarge!.copyWith(
            color: Colors.grey
          ),
        ),
      ],
    );
  }
}