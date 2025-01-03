// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TripController on TripControllerBase, Store {
  late final _$_locationPermissionAtom =
      Atom(name: 'TripControllerBase._locationPermission', context: context);

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
      Atom(name: 'TripControllerBase._isServiceEnable', context: context);

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

  late final _$_requisicaoActiveAtom =
      Atom(name: 'TripControllerBase._requisicaoActive', context: context);

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

  late final _$_polynesRouterAtom =
      Atom(name: 'TripControllerBase._polynesRouter', context: context);

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

  late final _$_markersAtom =
      Atom(name: 'TripControllerBase._markers', context: context);

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
      Atom(name: 'TripControllerBase._errorMessage', context: context);

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
      Atom(name: 'TripControllerBase._cameraPosition', context: context);

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

  late final _$getPermissionLocationAsyncAction =
      AsyncAction('TripControllerBase.getPermissionLocation', context: context);

  @override
  Future<void> getPermissionLocation() {
    return _$getPermissionLocationAsyncAction
        .run(() => super.getPermissionLocation());
  }

  late final _$initActivetedTripAsyncAction =
      AsyncAction('TripControllerBase.initActivetedTrip', context: context);

  @override
  Future<void> initActivetedTrip(Requisicao? request) {
    return _$initActivetedTripAsyncAction
        .run(() => super.initActivetedTrip(request));
  }

  late final _$driverOnTheWayToThePassengerAsyncAction = AsyncAction(
      'TripControllerBase.driverOnTheWayToThePassenger',
      context: context);

  @override
  Future<void> driverOnTheWayToThePassenger() {
    return _$driverOnTheWayToThePassengerAsyncAction
        .run(() => super.driverOnTheWayToThePassenger());
  }

  late final _$showLocationsOnMapAsyncAction =
      AsyncAction('TripControllerBase.showLocationsOnMap', context: context);

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
