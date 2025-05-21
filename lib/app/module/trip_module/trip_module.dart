import 'package:flutter_getit/flutter_getit.dart';
import 'package:uber_clone_driver/app/helper/uber_drive_constants.dart';
import 'package:uber_clone_driver/app/module/trip_module/trip_controller.dart';

import 'trip_page.dart';

class TripModule extends FlutterGetItModule{
  @override

  String get moduleRouteName => UberDriveConstants.TRIP_MODULE_ROUTER_NAME;

  @override
  List<FlutterGetItPageRouter> get pages => [
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
  ];

}