import 'package:flutter/material.dart';
import 'package:rieu/config/theme/responsive.dart';


class UserInformation extends StatelessWidget {
  const UserInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;

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
            child: Image.network('https://t4.ftcdn.net/jpg/03/49/49/79/360_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.webp', fit: BoxFit.cover),
          )
        ),
        SizedBox(
          width: responsive.ip(1),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alejandra Moreno',
              style: TextStyle(
                fontSize: responsive.ip(1.6),
                fontWeight: FontWeight.w500,
                color: Colors.white
              ),
            ),
            Text(
              'Usuario',
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