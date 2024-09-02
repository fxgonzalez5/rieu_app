import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rieu/config/helpers/helpers.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/presentation/providers/providers.dart';


class UserInformation extends StatelessWidget {
  const UserInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    final user = context.read<UserProvider>().user;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(responsive.ip(0.3)),
          width: responsive.wp(16),
          height: responsive.wp(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colors.secondary, width: 3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: user.photoUrl != null
              ? Image.network(
                  user.photoUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Image.asset('assets/loaders/ripple_loading.gif');
                  },
                )
              : DecoratedBox(
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                  child: Center(child: Text(TextFormats.getInitials(user.name), style: texts.headlineMedium!.copyWith(color: Colors.grey))),
                )
          )
        ),
        SizedBox(
          width: responsive.ip(1),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: TextStyle(
                fontSize: responsive.ip(1.6),
                fontWeight: FontWeight.w500,
                color: Colors.white
              ),
            ),
            Text(
              user.getRole,
              style: TextStyle(
                fontSize: responsive.ip(1.3),
                fontWeight: FontWeight.w500,
                color: Colors.white70
              ),
            ),
          ],
        ),
      ],
    );
  }
}