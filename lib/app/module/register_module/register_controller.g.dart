// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RegisterController on RegisterControllerBase, Store {
  late final _$_errorMessangeAtom =
      Atom(name: 'RegisterControllerBase._errorMessange', context: context);

  String? get errorMessange {
    _$_errorMessangeAtom.reportRead();
    return super._errorMessange;
  }

  @override
  String? get _errorMessange => errorMessange;

  @override
  set _errorMessange(String? value) {
    _$_errorMessangeAtom.reportWrite(value, super._errorMessange, () {
      super._errorMessange = value;
    });
  }

  late final _$_isSuccessLoginAtom =
      Atom(name: 'RegisterControllerBase._isSuccessLogin', context: context);

  bool? get isSuccessLogin {
    _$_isSuccessLoginAtom.reportRead();
    return super._isSuccessLogin;
  }

  @override
  bool? get _isSuccessLogin => isSuccessLogin;

  @override
  set _isSuccessLogin(bool? value) {
    _$_isSuccessLoginAtom.reportWrite(value, super._isSuccessLogin, () {
      super._isSuccessLogin = value;
    });
  }

  late final _$loginAsyncAction =
      AsyncAction('RegisterControllerBase.login', context: context);

  @override
  Future<void> login(String email, String password) {
    return _$loginAsyncAction.run(() => super.login(email, password));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
