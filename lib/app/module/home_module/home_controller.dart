import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

part 'home_controller.g.dart';

class HomeController = HomeControllerBase with _$HomeController;

abstract class HomeControllerBase with Store {
  final LocationRepositoryImpl _locationRepositoryImpl;
  final RequisitionRepository _requisitionRepository;

  HomeControllerBase(
      {required LocationRepositoryImpl locationRepository,
      required RequisitionRepository requisitionRepository})
      : _requisitionRepository = requisitionRepository,
        _locationRepositoryImpl = locationRepository;

  @readonly
  var _requisicoes = <Requisicao>[];

  Future<void> teste() async {
      final address =
        await _locationRepositoryImpl.setNameMyLocal(-13.009753, -38.504607);
    print("Teste de controller ${address.nomeDestino}");
  }

  Future<void> findTrips() async{
      try {
        final requisicoes = await _requisitionRepository.findActvitesTrips();
        if (requisicoes.isNotEmpty) {
          _requisicoes = requisicoes;
        }
      } on RequisicaoException catch (e,s ) {
         if (kDebugMode) {
           print(e);
           print(s);
         }
      }
  }
}
