// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeController on HomeControllerBase, Store {
  late final _$_requisicoesAtom =
      Atom(name: 'HomeControllerBase._requisicoes', context: context);

  List<Requisicao> get requisicoes {
    _$_requisicoesAtom.reportRead();
    return super._requisicoes;
  }

  @override
  List<Requisicao> get _requisicoes => requisicoes;

  @override
  set _requisicoes(List<Requisicao> value) {
    _$_requisicoesAtom.reportWrite(value, super._requisicoes, () {
      super._requisicoes = value;
    });
  }

  late final _$_requisicaoActiveAtom =
      Atom(name: 'HomeControllerBase._requisicaoActive', context: context);

  Requisicao? get requisicaoActive {
    _$_requisicaoActiveAtom.reportRead();
    return super._requisicaoActive;
  }

  @override
  Requisicao? get _requisicaoActive => requisicaoActive;

  @override
  set _requisicaoActive(Requisicao? value) {
    _$_requisicaoActiveAtom.reportWrite(value, super._requisicaoActive, () {
      super._requisicaoActive = value;
    });
  }

  late final _$_requisicaoInfoAtom =
      Atom(name: 'HomeControllerBase._requisicaoInfo', context: context);

  Requisicao? get requisicaoInfo {
    _$_requisicaoInfoAtom.reportRead();
    return super._requisicaoInfo;
  }

  @override
  Requisicao? get _requisicaoInfo => requisicaoInfo;

  @override
  set _requisicaoInfo(Requisicao? value) {
    _$_requisicaoInfoAtom.reportWrite(value, super._requisicaoInfo, () {
      super._requisicaoInfo = value;
    });
  }

  late final _$_usuarioAtom =
      Atom(name: 'HomeControllerBase._usuario', context: context);

  Usuario? get usuario {
    _$_usuarioAtom.reportRead();
    return super._usuario;
  }

  @override
  Usuario? get _usuario => usuario;

  @override
  set _usuario(Usuario? value) {
    _$_usuarioAtom.reportWrite(value, super._usuario, () {
      super._usuario = value;
    });
  }

  late final _$_myAddresAtom =
      Atom(name: 'HomeControllerBase._myAddres', context: context);

  Address? get myAddres {
    _$_myAddresAtom.reportRead();
    return super._myAddres;
  }

  @override
  Address? get _myAddres => myAddres;

  @override
  set _myAddres(Address? value) {
    _$_myAddresAtom.reportWrite(value, super._myAddres, () {
      super._myAddres = value;
    });
  }

  late final _$_markersAtom =
      Atom(name: 'HomeControllerBase._markers', context: context);

  Set<Marker> get markers {
    _$_markersAtom.reportRead();
    return super._markers;
  }

  @override
  Set<Marker> get _markers => markers;

  @override
  set _markers(Set<Marker> value) {
    _$_markersAtom.reportWrite(value, super._markers, () {
      super._markers = value;
    });
  }

  late final _$_errorMessageAtom =
      Atom(name: 'HomeControllerBase._errorMessage', context: context);

  String? get errorMessage {
    _$_errorMessageAtom.reportRead();
    return super._errorMessage;
  }

  @override
  String? get _errorMessage => errorMessage;

  @override
  set _errorMessage(String? value) {
    _$_errorMessageAtom.reportWrite(value, super._errorMessage, () {
      super._errorMessage = value;
    });
  }

  late final _$_cameraPositionAtom =
      Atom(name: 'HomeControllerBase._cameraPosition', context: context);

  CameraPosition? get cameraPosition {
    _$_cameraPositionAtom.reportRead();
    return super._cameraPosition;
  }

  @override
  CameraPosition? get _cameraPosition => cameraPosition;

  @override
  set _cameraPosition(CameraPosition? value) {
    _$_cameraPositionAtom.reportWrite(value, super._cameraPosition, () {
      super._cameraPosition = value;
    });
  }

  late final _$_locationPermissionAtom =
      Atom(name: 'HomeControllerBase._locationPermission', context: context);

  LocationPermission? get locationPermission {
    _$_locationPermissionAtom.reportRead();
    return super._locationPermission;
  }

  @override
  LocationPermission? get _locationPermission => locationPermission;

  @override
  set _locationPermission(LocationPermission? value) {
    _$_locationPermissionAtom.reportWrite(value, super._locationPermission, () {
      super._locationPermission = value;
    });
  }

  late final _$_isServiceEnableAtom =
      Atom(name: 'HomeControllerBase._isServiceEnable', context: context);

  bool get isServiceEnable {
    _$_isServiceEnableAtom.reportRead();
    return super._isServiceEnable;
  }

  @override
  bool get _isServiceEnable => isServiceEnable;

  @override
  set _isServiceEnable(bool value) {
    _$_isServiceEnableAtom.reportWrite(value, super._isServiceEnable, () {
      super._isServiceEnable = value;
    });
  }

  late final _$_polynesRouterAtom =
      Atom(name: 'HomeControllerBase._polynesRouter', context: context);

  Set<Polyline> get polynesRouter {
    _$_polynesRouterAtom.reportRead();
    return super._polynesRouter;
  }

  @override
  Set<Polyline> get _polynesRouter => polynesRouter;

  @override
  set _polynesRouter(Set<Polyline> value) {
    _$_polynesRouterAtom.reportWrite(value, super._polynesRouter, () {
      super._polynesRouter = value;
    });
  }

  late final _$_userOnAtom =
      Atom(name: 'HomeControllerBase._userOn', context: context);

  bool get userOn {
    _$_userOnAtom.reportRead();
    return super._userOn;
  }

  @override
  bool get _userOn => userOn;

  @override
  set _userOn(bool value) {
    _$_userOnAtom.reportWrite(value, super._userOn, () {
      super._userOn = value;
    });
  }

  late final _$findRequisitionActiveAsyncAction =
      AsyncAction('HomeControllerBase.findRequisitionActive', context: context);

  @override
  Future<void> findRequisitionActive() {
    return _$findRequisitionActiveAsyncAction
        .run(() => super.findRequisitionActive());
  }

  late final _$getCameraUserLocationPositionAsyncAction = AsyncAction(
      'HomeControllerBase.getCameraUserLocationPosition',
      context: context);

  @override
  Future<void> getCameraUserLocationPosition() {
    return _$getCameraUserLocationPositionAsyncAction
        .run(() => super.getCameraUserLocationPosition());
  }

  late final _$getPermissionLocationAsyncAction =
      AsyncAction('HomeControllerBase.getPermissionLocation', context: context);

  @override
  Future<void> getPermissionLocation() {
    return _$getPermissionLocationAsyncAction
        .run(() => super.getPermissionLocation());
  }

  late final _$getUserLocationAsyncAction =
      AsyncAction('HomeControllerBase.getUserLocation', context: context);

  @override
  Future<void> getUserLocation() {
    return _$getUserLocationAsyncAction.run(() => super.getUserLocation());
  }

  late final _$setNameMyLocalAsyncAction =
      AsyncAction('HomeControllerBase.setNameMyLocal', context: context);

  @override
  Future<void> setNameMyLocal(Address addres) {
    return _$setNameMyLocalAsyncAction.run(() => super.setNameMyLocal(addres));
  }

  late final _$getUserDataAsyncAction =
      AsyncAction('HomeControllerBase.getUserData', context: context);

  @override
  Future<void> getUserData(dynamic idUser) {
    return _$getUserDataAsyncAction.run(() => super.getUserData(idUser));
  }

  late final _$findTripsAsyncAction =
      AsyncAction('HomeControllerBase.findTrips', context: context);

  @override
  Future<void> findTrips() {
    return _$findTripsAsyncAction.run(() => super.findTrips());
  }

  late final _$viewTripInfoAsyncAction =
      AsyncAction('HomeControllerBase.viewTripInfo', context: context);

  @override
  Future<void> viewTripInfo(Requisicao requisicao) {
    return _$viewTripInfoAsyncAction.run(() => super.viewTripInfo(requisicao));
  }

  late final _$showLocationsOnMapAsyncAction =
      AsyncAction('HomeControllerBase.showLocationsOnMap', context: context);

  @override
  Future<void> showLocationsOnMap() {
    return _$showLocationsOnMapAsyncAction
        .run(() => super.showLocationsOnMap());
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
