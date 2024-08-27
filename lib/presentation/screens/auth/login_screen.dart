import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rieu/config/helpers/helpers.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/infrastructure/services/services.dart';
import 'package:rieu/presentation/providers/providers.dart';
import 'package:rieu/presentation/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  static const String name = 'login_screen';
  
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return  Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.state.errorMessage.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showSnackBar(context, authProvider.state.errorMessage);
            });
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: AuthBackground(
                child: Column(
                    children: [
                      SizedBox(height: responsive.hp(35)),
                      const _TextSection(),
                      SizedBox(height: responsive.hp(3)),
                      const _LoginMethods(),
                      ChangeNotifierProvider(
                        create: (_) => LoginFormProvider(loginUserCallback: authProvider.loginUser),
                        child: const _FormContainer()
                      ),
                    ],
                  ),
              ),
            ),
          );
        },
      ),
   );
  }
}

class _FormContainer extends StatelessWidget {
  const _FormContainer();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final loginFormProvider = context.watch<LoginFormProvider>();

    return Padding(
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
          SizedBox(height: responsive.hp(1.5)),
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
          SizedBox(height: responsive.hp(1.5)),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              child: const Text('Olvidaste tu contraseña?'),
              onPressed: () {
                // TODO: Navegar a la pantalla para restablecer la contraseña
              },
            ),
          ),
          SizedBox(height: responsive.hp(1.5)),
          SizedBox(
            width: double.infinity,
            height: responsive.hp(6),
            child: FilledButton(
              onPressed: loginFormProvider.isPosting
                ? null
                : () {
                  FocusScope.of(context).unfocus();
                  loginFormProvider.onFormSubmit();
                },
              child: const Text('Iniciar Sesión')
            ),
          ),
          SizedBox(height: responsive.hp(1.5)),
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
    );
  }
}


class _LoginMethods extends StatelessWidget {
  const _LoginMethods();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final authProvider = context.read<AuthProvider>();

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
          onTap: () => authProvider.signInUser(GoogleSingInService()),
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