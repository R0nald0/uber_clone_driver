// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfileController on ProfileControllerBase, Store {
  late final _$_usuarioAtom =
      Atom(name: 'ProfileControllerBase._usuario', context: context);

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

  late final _$_errorMessageAtom =
      Atom(name: 'ProfileControllerBase._errorMessage', context: context);

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

  late final _$_requestsAtom =
      Atom(name: 'ProfileControllerBase._requests', context: context);

  List<Requisicao>? get requests {
    _$_requestsAtom.reportRead();
    return super._requests;
  }

  @override
  List<Requisicao>? get _requests => requests;

  @override
  set _requests(List<Requisicao>? value) {
    _$_requestsAtom.reportWrite(value, super._requests, () {
      super._requests = value;
    });
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
