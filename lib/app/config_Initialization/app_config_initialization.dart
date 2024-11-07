import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


class AppConfigInitialization {
    Future<void> loadConfig()async {
    WidgetsFlutterBinding.ensureInitialized();
       await _configFirebase();
     //  await _loadEnvs();
    }
}

Future<void> _configFirebase() async{
   await Firebase.initializeApp();
}
/* Future<void> _loadEnvs() async {
  await dotenv.load(fileName: '.env');
} */