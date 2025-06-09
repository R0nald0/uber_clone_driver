import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uber_clone_driver/app/helper/uber_drive_constants.dart';

class LoadingTripsWidget extends StatelessWidget {
  const LoadingTripsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LottieBuilder.asset(
            '${UberDriveConstants.PATH_IMAGE}find_people_lorrie.json',
            width: 120,
            height: 120,
            ),
        Text(
          "Nenhuma Corrida ativa no momento,aguarde...",
          textAlign: TextAlign.center,
          style: theme.textTheme.labelLarge
              ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
