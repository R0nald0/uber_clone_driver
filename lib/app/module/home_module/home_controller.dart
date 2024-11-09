import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

part 'home_controller.g.dart';

class HomeController = HomeControllerBase with _$HomeController;

abstract class HomeControllerBase with Store {
  final LocationServiceImpl _locationServiceImpl;
  final RequisitionRepository _requisitionRepository;
  final IUserRepository _userRepository;
  final MapsCameraService _mapsCameraService;
  final Completer<GoogleMapController> controler = Completer();

  HomeControllerBase(
      {required LocationServiceImpl locattionService,
      required RequisitionRepository requisitionRepository,
      required IUserRepository userRepository,
      required MapsCameraService mapsCameraService})
      : _requisitionRepository = requisitionRepository,
        _locationServiceImpl = locattionService,
        _userRepository = userRepository,
        _mapsCameraService = mapsCameraService;

  @readonly
  var _requisicoes = <Requisicao>[];

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
       _errorMessage ="erro ao recuperar dados do usuario";
       return;
    }

   final actualPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
   final user = _usuario!.copyWith(latitude: actualPosition.latitude ,longitude: actualPosition.longitude);
      
      final pathImageIcon = await _locationServiceImpl.markerPositionIconCostomizer("destination1", 0.0);
      final myMarkerLocal = _locationServiceImpl.createLocationMarker(user.latitude,user.longitude, null, "my_local", 'meu local', 10);
      
      _markers.add(myMarkerLocal);
      
    _cameraPosition = CameraPosition(
        target: LatLng(user.latitude, user.longitude),
        zoom: 16,
      );
     
     _usuario = user;
     
     _mapsCameraService.moveCamera(_cameraPosition!, controler);
    
  /*  final address = await _locationServiceImpl.setNameMyLocal(
        actualPosition.latitude, actualPosition.longitude);
    await setNameMyLocal(address); */
  }

  @action
  Future<void> setNameMyLocal(Address addres) async {

    _cameraPosition = CameraPosition(
      target: LatLng(addres.latitude, addres.longitude),
      zoom: 16,
    );

    if (_usuario != null) {
      final pathImageIcon = await _locationServiceImpl.markerPositionIconCostomizer("destination1", 0.0);
      final myMarkerLocal =
         _locationServiceImpl.createLocationMarker(addres.latitude,addres.longitude, pathImageIcon, "my_local", 'meu local', 10);
      _markers.add(myMarkerLocal);
    //  showAllPositionsAndTraceRouter();
    }
  }

@action
  Future<void> getUserData(idUser) async {
    _errorMessage = null;
    try {
      final user = await _userRepository.getDataUserOn(idUser);
      if (user == null) {
         _errorMessage ="erro ao recuperar dados do usuario";
      }
      _usuario = user;
      await getPermissionLocation();
    } on UserException catch (e) {
      _errorMessage = e.message;
    }
  }

@action
  Future<void> findTrips() async {
    _errorMessage = null;
    try {
      final requisicoes = await _requisitionRepository.findActvitesTrips();
      if (requisicoes.isNotEmpty) {
        _requisicoes = requisicoes;
      }
    } on RequisicaoException catch (e, s) {
      _errorMessage = e.message;
      if (kDebugMode) {
        print(e);
        print(s);
      }
    }
  }
}
