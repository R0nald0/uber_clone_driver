import 'package:mobx/mobx.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

part 'register_controller.g.dart';

class RegisterController = RegisterControllerBase with _$RegisterController;

abstract class RegisterControllerBase with Store {
  
  final IAuthService _authService;

  @readonly
  String? _errorMessange;

  @readonly
  bool? _isSuccessLogin;

  RegisterControllerBase(
      {
      required IAuthService authService}): _authService = authService;

  @action
Future<void> login(String email,String password)async{
     _errorMessange = null;
     _isSuccessLogin = false;
   try {
       final uid =await _authService.login(email,password);
       _isSuccessLogin = uid;
   } on UserException catch (e) {
      _errorMessange = e.message;
   }
}      

  Future<void> register(String name, String email, String password) async {
    try {
      _errorMessange = null;
      _isSuccessLogin = false;
      final isSuccessLogin = await _authService.register(
          name, email, password, UberCloneConstants.TIPO_USUARIO_MOTORISTA);

      _isSuccessLogin = isSuccessLogin;
    } on UserException catch (e) {
      _errorMessange = e.message;
    }
  }
}
