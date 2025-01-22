  
class UberDriveConstants {
  UberDriveConstants._();
  
  static const SPLASH_SCREEN_MODULE_ROUTER_NAME ='/SplashScreen';
  static const HOME_MODULE_ROUTER_NAME ='/Home';
  static const REGISTER_MODULE_ROUTER_NAME ='/Register';
  static const TRIP_MODULE_ROUTER_NAME ='/Trip';

  // ignore: constant_identifier_names
  static const SPLASH_SCREEN_PAGE_NAME ='${UberDriveConstants.SPLASH_SCREEN_MODULE_ROUTER_NAME}/Initializer/splash';
  // ignore: constant_identifier_names
  static const LOGIN_PAGE_NAME ='${UberDriveConstants.REGISTER_MODULE_ROUTER_NAME}/register/login';
  // ignore: constant_identifier_names
  static const REGISTER_PAGE_NAME ='${UberDriveConstants.REGISTER_MODULE_ROUTER_NAME}/register/RegisterPage';
  // ignore: constant_identifier_names
  static const HOME_PAGE_NAME ='${UberDriveConstants.HOME_MODULE_ROUTER_NAME}/Init/homepage';
  // ignore: constant_identifier_names
  static const TRIP_PAGE_NAME ='${UberDriveConstants.HOME_MODULE_ROUTER_NAME}/Init${UberDriveConstants.TRIP_MODULE_ROUTER_NAME}/corrida';
  
  static const PROFILE_PAGE_NAME ='${UberDriveConstants.HOME_MODULE_ROUTER_NAME}/Init${UberDriveConstants.TRIP_MODULE_ROUTER_NAME}/profile';
 
   static const MAPS_KEY = String.fromEnvironment('GOOGLE_KEY',defaultValue: 'No ontent');
 
  static const PATH_IMAGE ='assets/images/';
   
     
   
}