
import 'package:flutter_getit/flutter_getit.dart';
import 'package:uber_clone_driver/app/helper/uber_drive_constants.dart';
import 'package:uber_clone_driver/app/module/auth/controller/authentication_controller.dart';
import 'package:uber_clone_driver/app/module/splash_screen_module/SplashScreen.dart';

class SplashScreenModule extends FlutterGetItModule {
  @override
  
  String get moduleRouteName => UberDriveConstants.SPLASH_SCREEN_MODULE_ROUTER_NAME;

  @override
  List<Bind<Object>> get bindings => [
      Bind.lazySingleton((i) => AuthenticationController( authService: i()))
  ];
  
  @override
  List<FlutterGetItPageRouter> get pages => [
       FlutterGetItModuleRouter(
        name: '/Initializer', 
        bindings: [], 
        pages: [
        FlutterGetItPageRouter(
          name: '/splash',
          builder: (context) => SplashScreen(authController: context.get()),
        ),
      ])
  ];


  
}