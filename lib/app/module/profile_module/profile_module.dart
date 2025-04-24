
import 'package:flutter_getit/flutter_getit.dart';
import 'package:uber_clone_driver/app/helper/uber_drive_constants.dart';
import 'package:uber_clone_driver/app/module/profile_module/profile_page.dart';

class ProfileModule extends FlutterGetItModuleRouter{
  ProfileModule():super(
    name: UberDriveConstants.PROFILE_MODULE_ROUTER_NAME,
    pages: [ 
       FlutterGetItPageRouter(
        name: '/profile',
       builder: (context) => const ProfilePage(),
       )
      
    ],
    bindings: []
    );
}