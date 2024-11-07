
import 'package:flutter_getit/flutter_getit.dart';
import 'package:uber_clone_driver/app/helper/uber_drive_constants.dart';
import 'package:uber_clone_driver/app/module/auth/controller/authentication_controller.dart';
import 'package:uber_clone_driver/app/module/register_module/login/login_page.dart';
import 'package:uber_clone_driver/app/module/register_module/register/register_page.dart';
import 'package:uber_clone_driver/app/module/register_module/register_controller.dart';

class RegisterModule  extends FlutterGetItModule{
  @override

  String get moduleRouteName =>UberDriveConstants.REGISTER_MODULE_ROUTER_NAME;

  @override
  
  List<FlutterGetItPageRouter> get pages => [
      FlutterGetItModuleRouter(
        name: '/register', 
        bindings: [
        Bind.lazySingleton((i) =>
            AuthenticationController(authService: i())),
        Bind.lazySingleton(
            (i) => RegisterController(authService: i()))
      ], pages: [
        FlutterGetItPageRouter(
          name: '/login',
          builder: (context) => LoginPage(
            registerController: context.get(),
          ),
        ),
        FlutterGetItPageRouter(
          name: '/RegisterPage',
          builder: (context) => RegisterPage(
            registerController: context.get(),
          ),
        ),
      ])
  ] ;
  
}