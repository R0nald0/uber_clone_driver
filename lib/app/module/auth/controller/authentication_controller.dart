import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

part 'authentication_controller.g.dart';

class AuthenticationController = AuthenticationControllerBase  with _$AuthenticationController;

abstract class AuthenticationControllerBase with Store {
   final IAuthService _authService;

  AuthenticationControllerBase( 
      {required IAuthService authService})
      : _authService = authService;

  @readonly
  String? _errorMessage;

  @readonly
  Usuario? _dataStringUser;

  @action
  Future<void> verifyStateUserLogged() async {
  
    try {
      final user = await _authService.verifyStateUserLogged();
      if (user != null) {
       _dataStringUser =user;
      } else {
        logout();
      }
    } on AuthException catch (e, s) {
      if (kDebugMode) {
        print(s);
      }
      _errorMessage = "erro ao logar";
    } on UserException{
      
      _errorMessage = "Erro ao buscar dados do usuario";
    }
  }

  Future<void> logout() async {
     _dataStringUser = Usuario.emptyUser(); 
     _authService.logout();
  }
}