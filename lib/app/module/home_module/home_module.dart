import 'package:flutter_getit/flutter_getit.dart';
import 'package:uber_clone_core/uber_clone_core.dart';
import 'package:uber_clone_driver/app/helper/uber_drive_constants.dart';
import 'package:uber_clone_driver/app/module/auth/controller/authentication_controller.dart';
import 'package:uber_clone_driver/app/module/home_module/home_controller.dart';
import 'package:uber_clone_driver/app/module/home_module/home_page.dart';
import 'package:uber_clone_driver/app/module/profile_module/profile_module.dart';

class HomeModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => UberDriveConstants.HOME_MODULE_ROUTER_NAME;

  @override
  List<FlutterGetItPageRouter> get pages => [
        FlutterGetItModuleRouter(
          name: '/Init',
          bindings: [
            Bind.lazySingleton((i) => AuthenticationController(authService: i())),
            Bind.lazySingleton((i) => MapsCameraService()),
            Bind.lazySingleton((i) => FirebaseNotfication()),
          ],
          pages: [
            FlutterGetItPageRouter(
              name: '/homepage',
              bindings: [
                Bind.lazySingleton(
                  (i) => HomeController(
                    authService: i(),
                    locattionService: i(),
                    requisitionRepository: i(),
                    userRepository: i(),
                    mapsCameraService: i(),
                    tripService: i(),
                    log: i()
                  ),
                )
              ],
              builder: (context) => HomePage(
                auth: context.get(),
                homeController: context.get(),
              ),
            ),

            
          ProfileModule()
          ],
        )
      ];
}
