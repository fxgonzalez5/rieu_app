import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rieu/config/helpers/helpers.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/infrastructure/services/services.dart';
import 'package:rieu/presentation/providers/providers.dart';
import 'package:rieu/presentation/widgets/widgets.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;
    final user = context.watch<UserProvider>().user;

    return SafeArea(
      child: Stack(
        children: [
          if (user.photoUrl != null) 
            Image.network(
              user.photoUrl!,
              width: double.infinity,
              height: responsive.hp(45),
              fit: BoxFit.cover,
              loadingBuilder: (_, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  alignment: Alignment.center,
                  height: responsive.hp(45),
                  child: Image.asset('assets/loaders/ripple_loading.gif', height: responsive.hp(15)),
                );
              },
            )
          else
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: responsive.hp(45),
              color: Colors.grey.shade300,
              child: Text(TextFormats.getInitials(user.name), style: texts.displayLarge!.copyWith(color: Colors.grey)),
            ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: responsive.hp(50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(responsive.ip(2)),
                  topRight: Radius.circular(responsive.ip(2))
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 2,
                  )
                ]
              ),
              child: _BoxContent(user: user),
            ),
          )
        ],
      ),
    );
  }
}

class _BoxContent extends StatelessWidget {
  final UserEntity user;

  const _BoxContent({required this.user});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.ip(1), horizontal: responsive.ip(3)),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RoundedLine(
            width: responsive.wp(20),
            height: responsive.ip(0.25),
            color: Colors.grey[300]
          ),
          _Heading(user),
          const Divider(
            height: 10,
            thickness: 2,
            color: Colors.black12,
          ),
          _Information(user),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: responsive.hp(6),
            child: FilledButton(
              child: const Text('Cerrar Sesión'),
              onPressed: () => context.read<AuthProvider>().logoutUser(authServices: [
                GoogleSingInService()
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Information extends StatelessWidget {
  final UserEntity user;

  const _Information(this.user);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;

    return SizedBox(
      height: responsive.hp(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Historial', style: texts.titleSmall!.copyWith(fontWeight: FontWeight.bold)),
          RichText(
            text: TextSpan(
              text: 'Eventos inscritos: ',
              style: texts.bodyMedium!.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
              children: [
                TextSpan(
                  text: '${user.totalCourses}',
                  style: texts.bodyMedium!.copyWith(color: Colors.grey.shade600)
                )
              ]
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Tipo de eventos más activos: ',
              style: texts.bodyMedium!.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
              children: [
                TextSpan(
                  text: user.mostActiveCourse,
                  style: texts.bodyMedium!.copyWith(color: Colors.grey.shade600)
                )
              ]
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Eventos activos actualmente: ',
              style: texts.bodyMedium!.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
              children: [
                TextSpan(
                  text: '${user.totalActiveCourses}',
                  style: texts.bodyMedium!.copyWith(color: Colors.grey.shade600)
                )
              ]
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Eventos finalizados: ',
              style: texts.bodyMedium!.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
              children: [
                TextSpan(
                  text: '${user.totalCoursesCompleted}',
                  style: texts.bodyMedium!.copyWith(color: Colors.grey.shade600)
                )
              ]
            ),
          ),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  final UserEntity user;

  const _Heading(this.user);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.ip(2.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(user.name, style: texts.titleLarge),
          Text(
            user.email, 
            style: texts.bodyLarge!.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}