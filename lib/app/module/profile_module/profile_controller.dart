import 'package:mobx/mobx.dart';
import 'package:uber_clone_core/uber_clone_core.dart';
part 'profile_controller.g.dart';

class ProfileController = ProfileControllerBase with _$ProfileController;

abstract class ProfileControllerBase with Store {
  final IUserService _userService;
  final IAuthService _authService;
  final IRequistionService _requistionService;

  ProfileControllerBase(
      {required IUserService userSerivce,
      required IAuthService authService,
      required IRequistionService requestService})
      : _userService = userSerivce,
        _authService = authService,
        _requistionService = requestService;

  @readonly
  Usuario? _usuario;

  @readonly
  String? _errorMessage;

  @readonly
  List<Requisicao>? _requests;

  Future<void> findData() async {
    try {
      final id = await _authService.verifyStateUserLogged();
      if (id == null) {
        _usuario = null;
        _errorMessage = "usuario não encontrado,faça o login novamente";
        return;
      }
      _usuario = await _userService.getDataUserOn(id);
      final request = await _requistionService.findAllFromUser(id);
      _requests = request;
    } on RequestException catch (e) {
      _errorMessage = null;
      _errorMessage = e.message;
    }
  }
}
