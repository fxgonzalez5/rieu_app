import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rieu/infrastructure/services/services.dart';
import 'package:rieu/presentation/providers/auth/register_form_provider.dart';
import 'package:rieu/presentation/widgets/widgets.dart';
import 'package:rieu/config/theme/responsive.dart';

class RegisterScreen extends StatelessWidget {
  static const String name = 'register_screen';
  
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: AuthBackground(
            child: Column(
                children: [
                  SizedBox(height: responsive.hp(35)),
                  const _TextSection(),
                  ChangeNotifierProvider(
                    create: (_) => RegisterFormProvider(registerUserCallback: (name, email, password, institution, city) {}),
                    child: const _FormContainer()
                  ),
                ],
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
    final registerFormProvider = context.watch<RegisterFormProvider>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.hp(3), horizontal: responsive.wp(7.5)),
      child: Column(
        children: [
          CustomTextFormField(
            label: 'Nombre y Apellido',
            hint: 'Ejm. Juan Pérez',
            errorMessage: registerFormProvider.isFormPosted 
              ? registerFormProvider.name.errorMessage
              : null,
            onChanged: registerFormProvider.onFullNameChange,
          ),
          SizedBox(height: responsive.hp(1.5)),
          CustomTextFormField(
            keyboardType: TextInputType.emailAddress,
            label: 'Correo',
            hint: 'Ejm. usuario@example.com',
            errorMessage: registerFormProvider.isFormPosted 
              ? registerFormProvider.email.errorMessage
              : null,
            onChanged: registerFormProvider.onEmailChange,
          ),
          SizedBox(height: responsive.hp(1.5)),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  label: 'Contraseña',
                  hint: '********',
                  noVisibility: true,
                  errorMessage: registerFormProvider.isFormPosted 
                    ? registerFormProvider.password.errorMessage
                    : null,
                  onChanged: registerFormProvider.onPasswordChange,
                ),
              ),
              SizedBox(width: responsive.wp(2)),
              Expanded(
                child: CustomTextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  label: 'Confirmar Contraseña',
                  hint: '********',
                  noVisibility: true,
                  errorMessage: registerFormProvider.isFormPosted 
                    ? registerFormProvider.confirmPassword.errorMessage
                    : null,
                  onChanged: registerFormProvider.onConfirmPasswordChange,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.hp(1.5)),
          CustomTextFormField(
            label: 'Institución Educativa',
            hint: 'Ejm. Universidad Técnica Particular de Loja',
            errorMessage: registerFormProvider.isFormPosted 
              ? registerFormProvider.institution.errorMessage
              : null,
            onChanged: registerFormProvider.onInstitutionChange,
          ),
          SizedBox(height: responsive.hp(1.5)),
          CustomTextFormField(
            label: 'Ciudad',
            hint: 'Ejm. Loja',
            errorMessage: registerFormProvider.isFormPosted 
              ? registerFormProvider.city.errorMessage
              : null,
            onChanged: registerFormProvider.onCityChange,
            onFieldSubmitted: (_) => registerFormProvider.onFormSubmit(),
          ),
          SizedBox(height: responsive.hp(1.5)),
          SizedBox(
            width: double.infinity,
            height: responsive.hp(6),
            child: FilledButton(
              onPressed: registerFormProvider.isPosting
                ? null
                : () async {
                  FocusScope.of(context).unfocus();
                  registerFormProvider.onFormSubmit();
                  FirebaseAuthService.register(registerFormProvider.email.value, registerFormProvider.password.value).then(
                    (credential) {
                      if (credential != null) context.go('/process-completed', extra: {'title': '¡Te has registrado con éxito!'});
                    }
                  );
                },
              child: const Text('Registrar'),
            ),
          ),
          SizedBox(height: responsive.hp(3)),
          TextButton(
            child: const Text('Atrás', style: TextStyle(color: Colors.black)),
            onPressed: () => context.replace('/login'),
          ),
        ],
      ),
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
        SizedBox(height: responsive.hp(1.5)),
        Text(
          'Regístrate',
          style: texts.bodyLarge!.copyWith(
            color: Colors.grey
          ),
        ),
      ],
    );
  }
}