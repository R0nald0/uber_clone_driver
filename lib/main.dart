import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:uber_clone_core/uber_clone_core.dart';
import 'package:uber_clone_driver/app/helper/uber_drive_constants.dart';
import 'package:uber_clone_driver/app/module/home_module/home_module.dart';
import 'package:uber_clone_driver/app/module/register_module/register_module.dart';
import 'package:uber_clone_driver/app/module/splash_screen_module/splash_screen_module.dart';
import 'package:uber_clone_driver/app/module/trip_module/trip_module.dart';

void main() async {
  await AppConfigInitialization().loadConfig();
   
 // final token = await FirebaseNotfication().getTokenDevice();
  //log("TOKEN $token");
 
  const pubKey = String.fromEnvironment("PUBLISHED_KEY");
  //log("CHAVE PUBLICA $pubKey");
  Stripe.publishableKey = pubKey ;
  
  
  runApp(UberCloneCoreConfig(
    title: "Uber Driver",
    initialRoute: UberDriveConstants.SPLASH_SCREEN_PAGE_NAME,
    modules: [
      SplashScreenModule(),
      HomeModule(),
      RegisterModule(),
      TripModule()
    ],
  ));
}
