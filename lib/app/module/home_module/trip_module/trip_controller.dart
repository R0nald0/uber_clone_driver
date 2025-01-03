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
  final IUserRepository _userRepository;
  final MapsCameraService _mapsCameraService;
  final ITripSerivce _tripService;
  final IAppUberLog _log;
  final Completer<GoogleMapController> controler = Completer();


  TripControllerBase(
      {required ILocationService locattionService,
      required IRequistionService requisitionService,
      required IUserRepository userRepository,
      required MapsCameraService mapsCameraService,
      required ITripSerivce tripService,
      required IAppUberLog log})
      : _requisitionService = requisitionService,
        _locationServiceImpl = locattionService,
        _userRepository = userRepository,
        _mapsCameraService = mapsCameraService,
        _tripService = tripService,
        _log = log;

  late final String _txBotaoPadrao ="";
  late final Color _corPadrao =const Color( 0xffa9a9a9);      

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
  Future<void> initActivetedTrip(Requisicao? request) async {
    try {
      if (request == null) {
        _errorMessage = "erro ao buscar dados da requisição";
        _requisicaoActive = Requisicao.empty();
        return;
      }
      
     // final isSucess = await  _requisitionService.saveRequisitionOnPreference(request);
     // final isSucess = await  _requisitionService.createRequisition(request);
     /*  if (!isSucess) {
         _errorMessage = "Falha ao buscar dados da viagem ,tente novamente";
         _requisicaoActive = Requisicao.empty();
         return;
      } */

      if (_isServiceEnable == false ||
          _locationPermission == LocationPermission.denied ||
          _locationPermission == LocationPermission.deniedForever) {
        await getPermissionLocation();
      }

      _requisicaoActive = request;
      await showLocationsOnMap();
      await driverOnTheWayToThePassenger();
    } on RequisicaoException catch (e) {
      _errorMessage = e.message;
      _requisicaoActive = Requisicao.empty();
      return;
    }
  }

   @action
  Future<void> driverOnTheWayToThePassenger() async{
      //buscar localização do motorista e do passagerio em tempo real 
      // Marcar posições no mapa 
      // botao exibe nome Iniciar  viagem com passageiro
      // exibir localizção do motoristae do destino da viagem
  }

  @action
  Future<void> showLocationsOnMap() async {
    _errorMessage = null;
    try {
      if (_requisicaoActive == null) {
        throw RequisicaoException(
            message: 'erro ao buscar dados da requisição');
      }
      final addressOrigem = Address(
          bairro: "",
          cep: "",
          cidade: "",
          latitude: _requisicaoActive!.passageiro.latitude,
          longitude: _requisicaoActive!.passageiro.longitude,
          nomeDestino: "",
          numero: "",
          rua: "");

      final destino = _requisicaoActive!.destino;
      await _traceRouter(addressOrigem, destino);

      final markerOne = await _addMarkersOnMap(
          addressOrigem,
          '${UberDriveConstants.PATH_IMAGE}passageiro.png',
          'position1',
          'passageiro');

      final markerTwo = await _addMarkersOnMap(
          destino,
          '${UberDriveConstants.PATH_IMAGE}destination2.png',
          'position2',
          'destination');
     
      _markers.addAll([markerOne, markerTwo]);

      _mapsCameraService.moverCameraBound(
          addressOrigem, destino, 120, controler);
    } on AddresException catch (e, s) {
      throw RequisicaoException(message: e.message, stackTrace: s);
    }
  }

  Future<Marker> _addMarkersOnMap(Address fistAddress, String pathImage,
      String idMarcador, String tiuloLocal) async {
    final pathImageIconOne =
        await _locationServiceImpl.markerPositionIconCostomizer(pathImage, 200,null);
    return _locationServiceImpl.createLocationMarker(
        fistAddress.latitude,
        fistAddress.longitude,
        pathImageIconOne,
        idMarcador,
        tiuloLocal,
        BitmapDescriptor.hueBlue);
  }

  Future<void> _traceRouter(Address firstAddres, Address secondAdress) async {
    try {
      const apiKey =
         "";
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
}

/* 
 final dataToUpdate =  {
        'motorista': request.motorista!.toMap(),
        'status': request.status,
      } ; */