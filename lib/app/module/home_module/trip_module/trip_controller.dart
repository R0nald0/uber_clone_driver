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

  TripControllerBase(
      {required ILocationService locattionService,
      required IRequistionService requisitionService,
      required IUserService userService,
      required MapsCameraService mapsCameraService,
      required ITripSerivce tripService,
      required IAppUberLog log})
      : _requisitionService = requisitionService,
        _locationServiceImpl = locattionService,
        _userService = userService,
        _mapsCameraService = mapsCameraService,
        _tripService = tripService,
        _log = log;

  late StreamSubscription<Requisicao> requestSubsCription;
  late StreamSubscription<UserPosition> userPositionSubscription;

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
      });
    } on RequestException catch (e) {
      _errorMessage = e.message;
      _requisicaoActive = Requisicao.empty();
      return;
    }
  }

  Future<void> _updatePositions() async {
    try {
      var userPosition = _locationServiceImpl.getUserRealTimeLocation();
      _textButtonExibithion = 'Cheguei no local do passageiro';

      userPositionSubscription = userPosition.listen((data) async {
        final latitude = data.latitude;
        final longitude = data.longitude;

        final updatedUsuario = _requisicaoActive!.motorista!
            .copyWith(latitude: latitude, longitude: longitude);
        _requisicaoActive =
            _requisicaoActive!.copyWith(motorista: updatedUsuario);

        await _requisitionService.updateDataTripOn(_requisicaoActive!);
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

    switch (_requisicaoActive!.status) {
      case Status.A_CAMINHO:
        {
          _textButtonExibithion = 'Cheguei no local do passageiro';
          _driverOnTheWayToThePassenger();
          _onActionRequest = () {
            final updateStatus =
                _requisicaoActive!.copyWith(status: Status.EM_VIAGEM);
            _requisicaoActive = updateStatus;
          };
          break;
        }
      case Status.EM_VIAGEM:
        {
          inTravel();
          _textButtonExibithion = 'Finalizar';

          _onActionRequest = finishRequest;
          break;
        }
      case Status.FINALIZADO:
        {
          _onActionRequest = () {
            confirmedPayment();
          };
          break;
        }
      case Status.CANCELADA:
        {
          _textButtonExibithion = 'Corrida Cancelada';
          _onActionRequest = () {};
        }

      default:
    }
  }

  Future<void> finishRequest() async {
    final updateRequest =
        _requisicaoActive!.copyWith(status: Status.FINALIZADO);
    _requisicaoActive = updateRequest;
    showButton();

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
    try {
      await _traceRouter(addressOrigem, addressDestino);

      final markerOne = await _addMarkersOnMap(addressOrigem,
          '${UberDriveConstants.PATH_IMAGE}carro.png', 'position1', 'meu');

      final markerTwo = await _addMarkersOnMap(
          addressDestino, destinationNameImge, 'position2', 'passageiro');

      _markers.addAll([markerOne, markerTwo]);

      _mapsCameraService.moverCameraBound(
          addressOrigem, addressDestino, 120, controler);
    } on AddresException catch (e, s) {
      throw RequestException(message: e.message, stackTrace: s);
    }
  }

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
  Future<void> inTravel() async {
    final addressOrigem = Address(
        bairro: "",
        cep: "",
        cidade: "",
        latitude: _requisicaoActive!.motorista!.latitude,
        longitude: _requisicaoActive!.motorista!.longitude,
        nomeDestino: "",
        numero: "",
        rua: "");

    final addressDestino = Address(
        bairro: "",
        cep: "",
        cidade: "",
        latitude: _requisicaoActive!.destino.latitude,
        longitude: _requisicaoActive!.destino.longitude,
        nomeDestino: "",
        numero: "",
        rua: "");

    await _showLocationsOnMap(addressOrigem, addressDestino,
        '${UberDriveConstants.PATH_IMAGE}destination2.png');
    await _requisitionService.updataDataRequisition(
        _requisicaoActive!, _requisicaoActive!.toMap());
  }

  Future<void> _driverOnTheWayToThePassenger() async {
    final addressOrigem = Address(
        bairro: "",
        cep: "",
        cidade: "",
        latitude: _requisicaoActive!.motorista!.latitude,
        longitude: _requisicaoActive!.motorista!.longitude,
        nomeDestino: "",
        numero: "",
        rua: "");

    final addressDestino = Address(
        bairro: "",
        cep: "",
        cidade: "",
        latitude: _requisicaoActive!.passageiro.latitude,
        longitude: _requisicaoActive!.passageiro.longitude,
        nomeDestino: "",
        numero: "",
        rua: "");

    await _showLocationsOnMap(addressOrigem, addressDestino,
        '${UberDriveConstants.PATH_IMAGE}passageiro.png');
  }

  void showButton() {
    if (_requisicaoActive == null || _requisicaoActive!.status.isEmpty) {
      return;
    }
    if (_requisicaoActive!.status == Status.FINALIZADO) {
      _opacity = 0.0;
    }
  }

  Future<void> confirmedPayment() async {
    _errorMessage = null;
    try {
      final updatedRequest =
          _requisicaoActive?.copyWith(status: Status.CONFIRMADA);
      _requisicaoActive = updatedRequest;
      await _requisitionService.updataDataRequisition(
          _requisicaoActive!, updatedRequest!.toMap());
      final isSuccess =
          await _requisitionService.deleteAcvitedRequest(updatedRequest);
      if (isSuccess) {
        _requisicaoActive = null;
      }
    } on RequestException catch (e) {
      _errorMessage = e.message;
    } on UserException catch (e) {
      _errorMessage = e.message;
    }
  }

  void dispose() {
    userPositionSubscription.cancel();
    requestSubsCription.cancel();
  }
}
