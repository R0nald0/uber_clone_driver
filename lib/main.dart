
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
      RegisterModule(),
   
    ],
  ));
}
