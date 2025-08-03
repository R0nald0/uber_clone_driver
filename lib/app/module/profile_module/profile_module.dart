import 'package:flutter_getit/flutter_getit.dart';
import 'package:uber_clone_driver/app/helper/uber_drive_constants.dart';
import 'package:uber_clone_driver/app/module/profile_module/profile_controller.dart';
import 'package:uber_clone_driver/app/module/profile_module/profile_page.dart';

class ProfileModule extends FlutterGetItModuleRouter {
  ProfileModule()
      : super(name: UberDriveConstants.PROFILE_MODULE_ROUTER_NAME, pages: [
          FlutterGetItPageRouter(
            bindings: [
              Bind.singleton((i) => ProfileController(
                  userSerivce: i(),
                  authService: i(),
                  requestService: i(),
                  paymentService: i()))
            ],
            name: '/profile',
            builder: (context) => ProfilePage(
              profileController: context.get<ProfileController>(),
            ),
          )
        ]);
}
