import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:uber_clone_core/uber_clone_core.dart';
import 'package:uber_clone_driver/app/helper/uber_drive_constants.dart';

part 'home_controller.g.dart';

class HomeController = HomeControllerBase with _$HomeController;

abstract class HomeControllerBase with Store {
  final ILocationService _locationServiceImpl;
  final IRequistionService _requisitionService;
  final IUserService _userService;
  final MapsCameraService _mapsCameraService;
  final ITripSerivce _tripService;
  final IAppUberLog _log;
  final IAuthService _authSerivce;

  final Completer<GoogleMapController> controler = Completer();
  StreamSubscription<List<Requisicao>>? _requestSubscription;

  late Marker markerOne;
  late Marker markerTwo;

  HomeControllerBase({
    required ILocationService locattionService,
    required IRequistionService requisitionRepository,
    required IUserService userRepository,
    required MapsCameraService mapsCameraService,
    required ITripSerivce tripService,
    required IAppUberLog log,
    required IAuthService authService,
  })  : _requisitionService = requisitionRepository,
        _locationServiceImpl = locattionService,
        _userService = userRepository,
        _mapsCameraService = mapsCameraService,
        _tripService = tripService,
        _log = log,
        _authSerivce = authService;

  @readonly
  var _requisicoes = <Requisicao>[];

  @readonly
  Requisicao? _requisicaoActive;

  @readonly
  Requisicao? _requisicaoInfo;

  @readonly
  Usuario? _usuario;

  @readonly
  Address? _myAddres;

  @readonly
  var _markers = <Marker>{};

  @readonly
  String? _errorMessage;

  @readonly
  CameraPosition? _cameraPosition;

  @readonly
  LocationPermission? _locationPermission;

  @readonly
  bool _isServiceEnable = false;

  @readonly
  var _polynesRouter = <Polyline>{};

  @readonly
  bool _userOn = true;

  @action
  Future<void> findRequisitionActive() async {
    try {
      if (_usuario == null) {
        _errorMessage = " Erro ao buscar dados do usuairo";
        //deslogar e mandar para login page
        return;
      }

      if (_usuario!.idRequisicaoAtiva!.isEmpty) {
        findTrips();
        return;
      }

      _requisicaoActive = null;

      final activetedRequisition = await _requisitionService
          .verfyActivatedRequisition(_usuario!.idRequisicaoAtiva!);
      _requisicaoActive = activetedRequisition;
    } on UserNotFound catch (e) {
      _errorMessage = null;
      _errorMessage = UserNotFound.codeExcpetion.toString();
    }
  }

  @action
  Future<void> getCameraUserLocationPosition() async {
    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    _locationPermission = permission;

    final camPositon = await Geolocator.getLastKnownPosition();
    if (camPositon != null) {
      _cameraPosition = CameraPosition(
        target: LatLng(camPositon.latitude, camPositon.longitude),
        zoom: 16,
      );
    }
  }

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

    await getUserLocation();
  }

  @action
  Future<void> getUserLocation() async {
    _errorMessage = null;
    _cameraPosition = null;

    if (_usuario == null) {
      _errorMessage = "erro ao recuperar dados do usuario";
      return;
    }

    final actualPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final user = _usuario!.copyWith(
        latitude: actualPosition.latitude, longitude: actualPosition.longitude);
        const carIcon = "${UberDriveConstants.PATH_IMAGE}carMarker.png";

    final myMarkerLocal = await _createMarker(
        user.latitude,
        user.longitude,
         carIcon,
        "my_local",
        'meu local',
        const Size(30, 20));

    _markers.add(myMarkerLocal);

    _cameraPosition = CameraPosition(
      target: LatLng(user.latitude, user.longitude),
      zoom: 14,
    );

    _usuario = user;
    _mapsCameraService.moveCamera(_cameraPosition!, controler);
  }

  @action
  Future<void> setNameMyLocal(Address addres) async {
    _cameraPosition = CameraPosition(
      target: LatLng(addres.latitude, addres.longitude),
      zoom: 16,
    );

    if (_usuario != null) {
      final pathImageIcon = await _locationServiceImpl
          .markerPositionIconCostomizer("destination1", 0.0, null);
      final myMarkerLocal = _locationServiceImpl.createLocationMarker(
          addres.latitude,
          addres.longitude,
          pathImageIcon,
          "my_local",
          'meu local',
          10);
      _markers.add(myMarkerLocal);
    }
  }

  @action
  Future<void> getUserData(idUser) async {
    _errorMessage = null;
    try {
      final user = await _userService.getDataUserOn(idUser);
      if (user == null) {
        _errorMessage = "erro ao recuperar dados do usuario";
        _userOn = false;
      }
      _userOn = true;
      _usuario = user;
      await findRequisitionActive();
      await getPermissionLocation();
    } on UserException catch (e) {
      _errorMessage = e.message;
    }
  }

  @action
  Future<void> findTrips() async {
    _errorMessage = null;
    try {
      final requisicoesSt = _requisitionService.findAndObserverTrips();
      _requestSubscription = requisicoesSt.listen((requisicaoList) {
        if (requisicaoList.isEmpty) {
          _requisicoes = [];
          return;
        }
        _requisicoes.clear();
        _requisicoes = [...requisicaoList];
      }, onError: (err) {
        _errorMessage = err;
      });
    } on RequestException catch (e, s) {
      _errorMessage = e.message;
      if (kDebugMode) {
        print(e);
        print(s);
      }
    }
  }

  @action
  Future<void> viewTripInfo(Requisicao requisicao) async {
    try {
      _requisicaoInfo = null;
      _errorMessage = null;
      final idUsuario = requisicao.passageiro.idUsuario;
      if (idUsuario == null) {
        _errorMessage = 'Requisição não encontrada';
        return;
      }
      _requisicaoInfo = requisicao;
      await showLocationsOnMap();
    } on RequestException catch (e) {
      _errorMessage = e.message;
    }
  }

  @action
  Future<void> showLocationsOnMap() async {
    _errorMessage = null;

    try {
      if (_requisicaoInfo == null) {
        return;
      }

      final Usuario(latitude: passengerLatitude, longitude: passengerLogitude) =
          _requisicaoInfo!.passageiro;

      final addressOrigem = Address.emptyAddres()
          .copyWith(latitude: passengerLatitude, longitude: passengerLogitude);
      final destino = _requisicaoInfo!.destino;

      await _traceRouter(addressOrigem, destino);

      markerOne = await _createMarker(
          addressOrigem.latitude,
          addressOrigem.longitude,
          '${UberDriveConstants.PATH_IMAGE}passageiro.png',
          'position1',
          'passageiro',
          null);

      markerTwo = await _createMarker(
          destino.latitude,
          destino.longitude,
          '${UberDriveConstants.PATH_IMAGE}destination2.png',
          'position2',
          'destination',
          null);
      _markers.addAll([markerOne, markerTwo]);

      _mapsCameraService.moverCameraBound(
          addressOrigem, destino, 120, controler);
    } on AddresException catch (e, s) {
      throw RequestException(message: e.message, stackTrace: s);
    }
  }

  Future<Marker> _createMarker(
      double latitude,
      double longitude,
      String pathImage,
      String idMarcador,
      String tiuloLocal,
      Size? sizeIcon) async {
    final pathImageIconOne = await _locationServiceImpl
        .markerPositionIconCostomizer(pathImage, 200, sizeIcon);

    return _locationServiceImpl.createLocationMarker(latitude, longitude,
        pathImageIconOne, idMarcador, tiuloLocal, BitmapDescriptor.hueBlue);
  }

  Future<void> _traceRouter(Address firstAddres, Address secondAdress) async {
    try {
      const apiKey = UberDriveConstants.MAPS_KEY;
      _polynesRouter = <Polyline>{};

      if (_requisicaoInfo != null) {
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

  Future<void> rejectTrip() async {
    _polynesRouter = {};
    _markers.removeAll([markerOne, markerTwo]);
    _requisicaoInfo = null;

    await getPermissionLocation();
  }

  Future<void> acceptedTrip(Requisicao request) async {
    try {
      _requisicaoInfo = null;
      _requisicaoActive = null;

      if (_usuario == null ||
          _usuario!.idUsuario == null ||
          _usuario!.idUsuario!.isEmpty) {
        _errorMessage = 'Dados do motorista inválidos';
        throw RequestException(message: 'Dados do motorista inválidos');
      }

      final updatedUsuario =
          _usuario!.copyWith(idRequisicaoAtiva: () => request.id);

      final isSuccess = await _userService.updateUser(updatedUsuario);
      if (!isSuccess) {
        const message =
            'Erro ao sincornizar dados,viagem não pode ser iniciada,tente novamente';
        _errorMessage = message;
        throw RequestException(message: message);
      }

      final updateRequest = request.copyWith(
          motorista: updatedUsuario, status: RequestState.a_caminho);

      final requistionUpdated =
          await _requisitionService.updataDataRequisition(updateRequest);

      _requisicaoActive = requistionUpdated;
    } on RequestException catch (e) {
      _errorMessage = e.message;
    }
  }

  Future<void> logout() async {
    try {
      final isLogout = await _authSerivce.logout();
      if (isLogout) {
        _userOn = false;
        _usuario = null;
      }
    } on UserException catch (e) {
      _errorMessage = null;
      _errorMessage = e.message;
    }
  }

  Future<void> dispose() async {
    _requestSubscription?.cancel();
  }
}
