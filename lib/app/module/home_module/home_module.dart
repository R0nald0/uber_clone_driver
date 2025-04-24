import 'package:flutter_getit/flutter_getit.dart';
import 'package:uber_clone_core/uber_clone_core.dart';
import 'package:uber_clone_driver/app/helper/uber_drive_constants.dart';
import 'package:uber_clone_driver/app/module/auth/controller/authentication_controller.dart';
import 'package:uber_clone_driver/app/module/home_module/home_controller.dart';
import 'package:uber_clone_driver/app/module/home_module/home_page.dart';
import 'package:uber_clone_driver/app/module/home_module/trip_module/trip_controller.dart';
import 'package:uber_clone_driver/app/module/home_module/trip_module/trip_page.dart';
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
          ],
          pages: [
            FlutterGetItPageRouter(
              name: '/homepage',
              bindings: [
                Bind.lazySingleton(
                  (i) => HomeController(
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

            FlutterGetItModuleRouter(
                name: UberDriveConstants.TRIP_MODULE_ROUTER_NAME,
                bindings: []  ,
                pages: [
                  FlutterGetItPageRouter(
                    name:'/corrida'  ,
                    bindings: [
                      Bind.lazySingleton((i) => TripController(
                        locattionService: i(),
                          requisitionService: i(),
                          userService: i(),
                          mapsCameraService: i(),
                          tripService: i(),
                          log: i()
                      ))
                    ],
                    builder: (context) => TripPage(
                      tripController: context.get<TripController>(),
                     ),
                  ),
                ],
        ),
          ProfileModule()
          ],
        )
      ];
}
