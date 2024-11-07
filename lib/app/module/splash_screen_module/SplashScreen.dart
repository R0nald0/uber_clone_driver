import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:uber_clone_core/uber_clone_core.dart';
import 'package:uber_clone_driver/app/helper/uber_drive_constants.dart';
import 'package:uber_clone_driver/app/module/auth/controller/authentication_controller.dart';


class SplashScreen extends StatefulWidget {
  
  final  AuthenticationController _authController ;

  const SplashScreen({
    super.key, required AuthenticationController authController,
  }):_authController =authController;

  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with DialogLoader {
   final disposersReactions = <ReactionDisposer>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initReactions();
    });
  }

  void initReactions() async {
   
        reaction<String?>((_) => widget._authController.errorMessage, (erro) {
      if (erro != null) {
        callSnackBar(erro);
      }
    });

   reaction<Usuario?>((_) => widget._authController.dataStringUser, (user) {
      if (user == null || user.email.isEmpty)  {
         Navigator.of(context).pushNamedAndRemoveUntil(UberDriveConstants.LOGIN_PAGE_NAME,(route) => false,);
      } else {
         Navigator.of(context).pushNamedAndRemoveUntil(UberDriveConstants.HOME_PAGE_NAME,(route) => false,);
      }
    });

     await widget._authController.verifyStateUserLogged();

  }

  @override
  void dispose() {
    for (var reactions in disposersReactions) {
        reactions();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(60),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/fundo.png"),
                fit: BoxFit.cover),
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 100, bottom: 50),
                  child: Image.asset("assets/images/logo.png"),
                ),
                const LinearProgressIndicator(
                  color: Colors.blue,
                  minHeight: 2,
                ),
              ],
            ),
          )),
    );
  }
}
