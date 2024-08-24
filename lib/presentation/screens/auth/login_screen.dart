import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/infrastructure/services/services.dart';
import 'package:rieu/presentation/providers/auth/login_form_provider.dart';
import 'package:rieu/presentation/widgets/widgets.dart';

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
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(loginUserCallback:(email, password) {}),
                      child: const _FormContainer()
                    ),
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
    final loginFormProvider = context.watch<LoginFormProvider>();

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: responsive.hp(2), horizontal: responsive.wp(7.5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomTextFormField(
              keyboardType: TextInputType.emailAddress,
              label: 'Correo',
              hint: 'usuario@utpl.edu.ec',
              errorMessage: loginFormProvider.isFormPosted 
                ? loginFormProvider.email.errorMessage
                : null,
              onChanged: loginFormProvider.onEmailChange,
            ),
            CustomTextFormField(
              keyboardType: TextInputType.visiblePassword,
              label: 'Contraseña',
              hint: '********',
              noVisibility: true,
              errorMessage: loginFormProvider.isFormPosted 
                ? loginFormProvider.password.errorMessage
                : null,
              onChanged: loginFormProvider.onPasswordChange,
              onFieldSubmitted: (_) => loginFormProvider.onFormSubmit(),
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
                onPressed: loginFormProvider.isPosting
                  ? null
                  : () async {
                    FocusScope.of(context).unfocus();
                    loginFormProvider.onFormSubmit();
                    final credential = await FirebaseAuthService.login(loginFormProvider.email.value, loginFormProvider.password.value);
                    if (credential != null) {
                      print(credential);
                    } // TODO: Navegar a la pantalla principal
                  },
                child: const Text('Iniciar Sesión')
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: responsive.hp(6),
              child: FilledButton(
                child: const Text('Registrarse'),
                onPressed: () => context.replace('/register')
              ),
            ),
          ],
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
          onTap: () {}, // TODO: Implementar inicio de sesión con Microsoft
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