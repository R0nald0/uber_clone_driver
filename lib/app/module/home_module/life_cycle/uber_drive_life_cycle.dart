import 'package:flutter/material.dart';

typedef OnActionInResumed = void Function();
class UberDriveLifeCycle with WidgetsBindingObserver {
  final OnActionInResumed? onResumed;  
   
  UberDriveLifeCycle({ required this.onResumed });
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
   // final database = SqlConnection();

    switch (state) {
      
      case AppLifecycleState.resumed:
         print("ENTROU NO RESUMED");
        OnActionInResumed;
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        //database.closeConnection();
        
        break;
    }

    super.didChangeAppLifecycleState(state);
  }
}