/* void main() async { 
  import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

await AppConfigInitialization().loadConfig();

  runApp(UberCloneCoreConfig(
    initialRoute: '/',
    title: "Uber Motorista",
    modulesRouter: [
      FlutterGetItModuleRouter(
        name: '/', 
        bindings: [
             Bind.lazySingleton<AuthenticationController>((i) => AuthenticationController(
                authRepository: i(), localStorage: i()))
        ],
        pages: [
        FlutterGetItPageRouter(
          name: '/',
          builder: (context) => SplashScreen(
            authController: context.get(),
          ),
        ),
      ]),
      FlutterGetItModuleRouter(
        name: '/homeModule', 
        pages: [
        FlutterGetItPageRouter(
          name: '/home/',
          bindings: [
            Bind.lazySingleton(
              (i) => HomeController(
                  locationRepository: i(), requisitionRepository: i()),
            ),
            Bind.lazySingleton(
              (i) => AuthenticationController(
                  authRepository: i(), localStorage: i()),
            )
          ],
          builder: (context) => HomePage(
            auth: context.get<AuthenticationController>(),
            homeController: context.get<HomeController>(),
          ),
        ),
      ]),
      FlutterGetItModuleRouter(
        name: '/tripModule', 
        pages: [
            FlutterGetItPageRouter(
        name: '/corrida',
        builder: (context) => const TripPage(),
      )
        ]
        )
    ],
  ));
}

*/

import 'package:flutter/material.dart';
import 'package:uber_clone_core/uber_clone_core.dart';
import 'package:uber_clone_driver/app/config_Initialization/app_config_initialization.dart';
import 'package:uber_clone_driver/app/helper/uber_drive_constants.dart';
import 'package:uber_clone_driver/app/module/home_module/home_module.dart';
import 'package:uber_clone_driver/app/module/register_module/register_module.dart';
import 'package:uber_clone_driver/app/module/splash_screen_module/splash_screen_module.dart';

void main() async {
  await AppConfigInitialization().loadConfig();

  runApp(UberCloneCoreConfig(
    title: "Uber Driver",
    initialRoute: UberDriveConstants.SPLASH_SCREEN_PAGE_NAME,
    modules: [
      SplashScreenModule(),
      HomeModule(),
      RegisterModule()
    ],
  ));
}
