// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthenticationController on AuthenticationControllerBase, Store {
  late final _$_errorMessageAtom = Atom(
      name: 'AuthenticationControllerBase._errorMessage', context: context);

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

  late final _$_dataStringUserAtom = Atom(
      name: 'AuthenticationControllerBase._dataStringUser', context: context);

  String? get dataStringUser {
    _$_dataStringUserAtom.reportRead();
    return super._dataStringUser;
  }

  @override
  String? get _dataStringUser => dataStringUser;

  @override
  set _dataStringUser(String? value) {
    _$_dataStringUserAtom.reportWrite(value, super._dataStringUser, () {
      super._dataStringUser = value;
    });
  }

  late final _$verifyStateUserLoggedAsyncAction = AsyncAction(
      'AuthenticationControllerBase.verifyStateUserLogged',
      context: context);

  @override
  Future<void> verifyStateUserLogged() {
    return _$verifyStateUserLoggedAsyncAction
        .run(() => super.verifyStateUserLogged());
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
