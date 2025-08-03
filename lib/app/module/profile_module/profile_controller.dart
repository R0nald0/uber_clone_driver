
import 'package:mobx/mobx.dart';
import 'package:uber_clone_core/uber_clone_core.dart';
part 'profile_controller.g.dart';

class ProfileController = ProfileControllerBase with _$ProfileController;

abstract class ProfileControllerBase with Store {
  final IUserService _userService;
  final IAuthService _authService;
  final IRequistionService _requistionService;
  final IPaymentService _paymentService;


  ProfileControllerBase(
      {required IUserService userSerivce,
      required IAuthService authService,
      required IRequistionService requestService,
      required IPaymentService paymentService,
      })
      : _userService = userSerivce,
        _authService = authService,
        _requistionService = requestService,
        _paymentService = paymentService;

  @readonly
  Usuario? _usuario;
  
  @readonly
  bool _loading = false;

  @readonly
  String? _errorMessage;

  @readonly
  List<Requisicao>? _requests;
  

  @action
  Future<void> findData() async {
      _loading = true;
    try {
      //await Future.delayed(const Duration(seconds: 5));
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
    finally{
      _loading = false;
    }
  }
  
  @action
  Future<void> createIntentPayment(double amount) async{
      try {
          _loading = true;
         await _paymentService.creatIntentPayment(amount,PaymentType(id: 2, type: "pix")); 
        _loading =false;
      }on PaymentException catch (e) {
        _errorMessage = null;
        _errorMessage = e.message;
      }
      
    //  _paymentService.creatIntentPayment(amount);
  }
}
