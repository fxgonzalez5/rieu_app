import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rieu/presentation/widgets/widgets.dart';
import 'package:rieu/config/theme/responsive.dart';

class RegisterScreen extends StatelessWidget {
  static const String name = 'register_screen';
  
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return  Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: AuthBackground(
            child: Column(
                children: [
                  SizedBox(height: responsive.hp(35)),
                  const _TextSection(),
                  const _FormContainer(),
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

    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.hp(3), horizontal: responsive.wp(7.5)),
      child: Form(
          // TODO: crear la llave del formulario
          // key: ,
          child: Column(
            children: [
              const CustomTextFormField(
                label: 'Nombre y Apellido',
                hint: 'Ejm. Juan Pérez'
              ),
              SizedBox(height: responsive.hp(1.5)),
              const CustomTextFormField(
                label: 'Correo',
                hint: 'Ejm. usuario@example.com'
              ),
              SizedBox(height: responsive.hp(1.5)),
              Row(
                children: [
                  const Expanded(
                    child: CustomTextFormField(
                      label: 'Contraseña',
                      hint: '********',
                      noVisibility: true,
                    ),
                  ),
                  SizedBox(width: responsive.wp(2)),
                  const Expanded(
                    child: CustomTextFormField(
                      label: 'Confirmar Contraseña',
                      hint: '********',
                      noVisibility: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.hp(1.5)),
              const CustomTextFormField(
                label: 'Institución Educativa',
                hint: 'Ejm. Universidad Técnica Particular de Loja'
              ),
              SizedBox(height: responsive.hp(1.5)),
              const CustomTextFormField(
                label: 'Ciudad',
                hint: 'Ejm. Loja'
              ),
              SizedBox(height: responsive.hp(1.5)),
              SizedBox(
                width: double.infinity,
                height: responsive.hp(6),
                child: FilledButton(
                  child: const Text('Registrar'),
                  onPressed: () {
                    // TODO: Guardar los datos del formulario y navegar a la pantalla principal
                  },
                ),
              ),
              SizedBox(height: responsive.hp(3)),
              TextButton(
                child: const Text('Atrás', style: TextStyle(color: Colors.black)),
                onPressed: () => context.pop(),
              ),
            ],
          ),
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