import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:uber_clone_core/uber_clone_core.dart';
import 'package:uber_clone_driver/app/helper/uber_drive_constants.dart';

part 'trip_controller.g.dart';

class TripController = TripControllerBase with _$TripController;

abstract class TripControllerBase with Store {
  final ILocationService _locationServiceImpl;
  final IRequistionService _requisitionService;
  final IUserService _userService;
  final MapsCameraService _mapsCameraService;
  final ITripSerivce _tripService;
  final IAppUberLog _log;

  final Completer<GoogleMapController> controler = Completer();

  TripControllerBase({
    required ILocationService locattionService,
    required IRequistionService requisitionService,
    required IUserService userService,
    required MapsCameraService mapsCameraService,
    required ITripSerivce tripService,
    required IAppUberLog log,
  })  : _requisitionService = requisitionService,
        _locationServiceImpl = locattionService,
        _userService = userService,
        _mapsCameraService = mapsCameraService,
        _tripService = tripService,
        _log = log;

  StreamSubscription<Requisicao>? requestSubsCription;
  StreamSubscription<UserPosition>? userPositionSubscription;
  StreamSubscription<UberMessanger>? notificatioSubscription;

  @readonly
  double? _opacity = 1;

  @readonly
  LocationPermission? _locationPermission;

  @readonly
  bool _isServiceEnable = false;

  @readonly
  Requisicao? _requisicaoActive;

  @readonly
  var _polynesRouter = <Polyline>{};

  @readonly
  var _markers = <Marker>{};

  @readonly
  String? _errorMessage;

  @readonly
  CameraPosition? _cameraPosition;

  @readonly
  String? _textButtonExibithion = "";

  @readonly
  Function _onActionRequest = () {};

  @readonly
  RequestState? _requestState = RequestState.nao_chamado;

  @action
  Future<void> getPermissionLocation() async {
    _locationPermission = null;

    final isServiceEnable = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnable) {
      _isServiceEnable = isServiceEnable;
      return;
    }

    _isServiceEnable = isServiceEnable;

    final permission = await Geolocator.checkPermission();

    switch (permission) {
      case LocationPermission.denied:
        final permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          _locationPermission = permission;
          return;
        }
        break;

      case LocationPermission.deniedForever:
        _locationPermission = LocationPermission.deniedForever;
        return;

      case LocationPermission.whileInUse:
      case LocationPermission.always:
      case LocationPermission.unableToDetermine:
        break;
    }
    //await getUserLocation();
  }

  @action
  Future<void> initActivetedRequest(Requisicao? request) async {
    try {
      if (request == null) {
        _errorMessage = "erro ao buscar dados da requisição";
        _requisicaoActive = Requisicao.empty();
        return;
      }

      if (_isServiceEnable == false ||
          _locationPermission == LocationPermission.denied ||
          _locationPermission == LocationPermission.deniedForever) {
        await getPermissionLocation();
      }

      requestSubsCription =
          _requisitionService.findAndObserverById(request).listen((data) async {
        _requisicaoActive = data;

        await _updatePositions();
        await verifyStatusRequest();
        if (_requisicaoActive?.status != data.status) {
          await _requisitionService.updataDataRequisition(data);
        }
      },
      onError: (_){
         
         _requisicaoActive = Requisicao.empty();
         _requisitionService.deleteAcvitedRequest(request);
      }
      );
    } on RequestException catch (e) {
      _errorMessage = e.message;
      _requisicaoActive = Requisicao.empty();
      return;
    }
  }

  Future<void> _updatePositions() async {
    try {
      userPositionSubscription =
          _locationServiceImpl.getUserRealTimeLocation().listen((data) async {
        final UserPosition(:latitude, :longitude) = data;

        final updatedUsuario = _requisicaoActive!.motorista!
            .copyWith(latitude: latitude, longitude: longitude);

        final requestUpdated =
            _requisicaoActive!.copyWith(motorista: updatedUsuario);

        _requisicaoActive = requestUpdated;
        await _requisitionService.updateDataTripOn(requestUpdated);
      });
    } on RequestException catch (e) {
      _errorMessage = e.message;
      _requisicaoActive = Requisicao.empty();
      return;
    }
  }

  @action
  Future<void> verifyStatusRequest() async {
    if (_requisicaoActive == null) {
      _errorMessage = "erro ao buscar dados da requisição";
      _requisicaoActive = Requisicao.empty();
      return;
    }

    switch (_requisicaoActive?.status) {
      case RequestState.a_caminho:
        {
          await _driverOnTheWayToThePassenger(_requisicaoActive!);
          _onActionRequest = () {
            final updateStatus =
                _requisicaoActive!.copyWith(status: RequestState.em_viagem);
            _requisicaoActive = updateStatus;
          };
          break;
        }
      case RequestState.em_viagem:
        {
          inTravelToDestiny(_requisicaoActive!);
          _onActionRequest = () {
            final updateStatus =
                _requisicaoActive!.copyWith(status: RequestState.finalizado);
            _requisicaoActive = updateStatus;
          };
          break;
        }
      case RequestState.finalizado:
        {
          finishRequest(_requisicaoActive!);
          _onActionRequest = () {
            confirmedPayment();
          };
          break;
        }
      case RequestState.cancelado:
        {
          _textButtonExibithion = 'Corrida Cancelada';
          _onActionRequest = () {};
        }
      default:
    }
  }

  Future<void> finishRequest(Requisicao request) async {
    _textButtonExibithion = '';
    _requestState = RequestState.finalizado;
    final updateRequest =
        _requisicaoActive!.copyWith(status: RequestState.finalizado);
    _requisicaoActive = updateRequest;

    final Usuario(latitude: motoristaLatitude, longitude: motoristaLongitude) =
        request.motorista!;
    final Address(latitude: destinoLatitude, longitude: destinoLogitude) =
        request.destino;

    final addressOrigem = Address.emptyAddres()
        .copyWith(latitude: motoristaLatitude, longitude: motoristaLongitude);
    final addressDestino = Address.emptyAddres()
        .copyWith(latitude: destinoLatitude, longitude: destinoLogitude);

    await _showLocationsOnMap(addressOrigem, addressDestino,
        '${UberDriveConstants.PATH_IMAGE}destination2.png');

    await _requisitionService.updataDataRequisition(_requisicaoActive!);
    await _traceRouter(addressOrigem, addressDestino);
    _showButton();

    /// mostrar valores recebidos
    /// exibir botao para sair da  tela
  }

  @action
  Future<void> _showLocationsOnMap(
    Address addressOrigem,
    Address addressDestino,
    String destinationNameImge,
  ) async {
    _errorMessage = null;
    _markers = {};
    try {
      final markerOne = await _addMarkersOnMap(addressOrigem,
          '${UberDriveConstants.PATH_IMAGE}carro.png', 'position1', 'meu');

      final markerTwo = await _addMarkersOnMap(
          addressDestino, destinationNameImge, 'position2', 'passageiro');

      _markers.add(markerOne);
      _markers.add(markerTwo);

      _mapsCameraService.moverCameraBound(
          addressOrigem, addressDestino, 120, controler);
    } on AddresException catch (e, s) {
      throw RequestException(message: e.message, stackTrace: s);
    }
  }

  @action
  Future<Marker> _addMarkersOnMap(Address fistAddress, String pathImage,
      String idMarcador, String tituloLocal) async {
    final pathImageIconOne = await _locationServiceImpl
        .markerPositionIconCostomizer(pathImage, 200, null);
    return _locationServiceImpl.createLocationMarker(
        fistAddress.latitude,
        fistAddress.longitude,
        pathImageIconOne,
        idMarcador,
        tituloLocal,
        BitmapDescriptor.hueBlue);
  }

  Future<void> _traceRouter(Address firstAddres, Address secondAdress) async {
    try {
      const apiKey = UberDriveConstants.MAPS_KEY;
      _polynesRouter = <Polyline>{};
      if (_requisicaoActive != null) {
        final polylinesData = await _tripService.getRoute(
            firstAddres, secondAdress, Colors.black, 5, apiKey);
        final linesCordenates = Set<Polyline>.of(polylinesData.router.values);
        _polynesRouter = linesCordenates;
      }
    } on NotInitializedError catch (e, s) {
      _log.erro('erro ao buscar api key', e, s);
      throw AddresException(
          message: 'Algo deu errado ao buscar dados da viagem', stackTrace: s);
    } on AddresException catch (e, s) {
      _log.erro('erro ao buscar api key', e, s);
      throw AddresException(
          message: 'erro ao buscar dados da viagem', stackTrace: s);
    } on Exception catch (e, s) {
      _log.erro('erro desconhecido', e, s);
      throw AddresException(message: 'erro desconhecido', stackTrace: s);
    }
  }

  @action
  Future<void> inTravelToDestiny(Requisicao request) async {
    _requestState = RequestState.a_caminho;
    _textButtonExibithion = 'Finalizar';

    final Usuario(latitude: motoristaLatitude, longitude: motoristaLongitude) =
        request.motorista!;
    final Address(latitude: destinoLatitude, longitude: destinoLogitude) =
        request.destino;

    final addressOrigem = Address.emptyAddres()
        .copyWith(latitude: motoristaLatitude, longitude: motoristaLongitude);
    final addressDestino = Address.emptyAddres()
        .copyWith(latitude: destinoLatitude, longitude: destinoLogitude);

    await _showLocationsOnMap(addressOrigem, addressDestino,
        '${UberDriveConstants.PATH_IMAGE}destination2.png');
    await _requisitionService.updataDataRequisition(_requisicaoActive!);
    await _traceRouter(addressOrigem, addressDestino);
  }

  Future<void> _driverOnTheWayToThePassenger(Requisicao request) async {
    _textButtonExibithion = 'Iniciar Viagem';
    _requestState = RequestState.a_caminho;

    final Usuario(:latitude, :longitude) = request.passageiro;
    final Usuario(latitude: motoristaLatitude, longitude: motoristaLongitude) =
        request.motorista!;

    final addressOrigem = Address.emptyAddres()
        .copyWith(latitude: motoristaLatitude, longitude: motoristaLongitude);
    final addressDestino = Address.emptyAddres()
        .copyWith(latitude: latitude, longitude: longitude);

    await _showLocationsOnMap(addressOrigem, addressDestino,
        '${UberDriveConstants.PATH_IMAGE}passageiro.png');
    await _traceRouter(addressOrigem, addressDestino);
    await _requisitionService.updataDataRequisition(request);
  }

  void _showButton() {
    if (_requisicaoActive == null ||
        _requisicaoActive!.status == RequestState.nao_chamado) {
      return;
    }
    if (_requisicaoActive!.status == RequestState.finalizado) {
      _opacity = 0.5;
    }
  }

  Future<void> confirmedPayment() async {
    _errorMessage = null;
    try {
      _requestState = RequestState.pagamento_confirmado;
      final request = _requisicaoActive?.copyWith(
          status: RequestState.pagamento_confirmado);

      if (request == null) {
        _errorMessage = "Erro ao atualizar request";
      }
      final upadtedRequest =
          await _requisitionService.updataDataRequisition(request!);
      final isSuccess =
          await _requisitionService.deleteAcvitedRequest(upadtedRequest);
      if (!isSuccess) {
         throw RequestException(message: "Erroa limpar viagem ativar");
      }
       
        _requisicaoActive = null;
    } on RequestException catch (e) {
      _errorMessage = e.message;
    } on UserException catch (e) {
      _errorMessage = e.message;
    }
  }

  Future<void> getMessgeBackGround() async {}
  void dispose() {
    notificatioSubscription?.cancel();
    userPositionSubscription?.cancel();
    requestSubsCription?.cancel();
  }
}
