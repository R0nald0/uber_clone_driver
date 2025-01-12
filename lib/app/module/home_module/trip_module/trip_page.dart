import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:uber_clone_core/uber_clone_core.dart';
import 'package:uber_clone_driver/app/helper/uber_drive_constants.dart';
import 'package:uber_clone_driver/app/module/home_module/trip_module/trip_controller.dart';

class TripPage extends StatefulWidget {
  final TripController _controller;

  const TripPage({super.key, required TripController tripController})
      : _controller = tripController;

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> with DialogLoader {
  var listReactions = <ReactionDisposer>[];

  final CameraPosition _cameraPositionViagem =
      const CameraPosition(target: LatLng(-13.001478, -38.499390), zoom: 11);

  _onMapCreated(GoogleMapController googleMapController) {
    widget._controller.controler.complete(googleMapController);
  }

  initReactions() async {
    final reactionDisposerMessage =
        reaction<String?>((_) => widget._controller.errorMessage, (messager) {
      if (messager != null) {
        callSnackBar(messager);
      }
    });

    final serviceEnableReaction = reaction<bool>(
        (_) => widget._controller.isServiceEnable, (isServiceEnable) {
      if (!isServiceEnable) {
        callSnackBar("Ativse sua localização");
      }
    });

    final locationPermissionReaction = reaction<LocationPermission?>(
        (_) => widget._controller.locationPermission, (permission) {
      if (permission == LocationPermission.denied) {
        dialogLocationPermissionDenied(() {
          widget._controller.getPermissionLocation();
        });
      } else if (permission == LocationPermission.deniedForever) {
        dialogLocationPermissionDeniedForeve(() {
          Geolocator.openAppSettings();
        });
      }
    });

    final requisiaoRection = reaction<Requisicao?>(
        (_) => widget._controller.requisicaoActive, (requisicao) {
      if (requisicao == null || requisicao.id!.isEmpty) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            UberDriveConstants.HOME_PAGE_NAME, (_) => false);
      }

      /*  showInfoRequistionDialog(
            requisicao,
            () {
               hideLoader();
               Navigator.of(context).pushNamedAndRemoveUntil(UberDriveConstants.TRIP_PAGE_NAME,arguments: requisicao,(_)=> false);     
            },
            () => widget._controller.getPermissionLocation(),
            );  */
    });

    listReactions.addAll([
      locationPermissionReaction,
      serviceEnableReaction,
      requisiaoRection,
      reactionDisposerMessage
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final requisicao = ModalRoute.of(context)!.settings.arguments as Requisicao;

    widget._controller.initActivetedRequest(requisicao);

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Corrida em andamento ${requisicao.passageiro.nome}",
        ),
      ),
      body: Container(
          padding: const EdgeInsets.all(2),
          child: Stack(
            children: <Widget>[
              Observer(builder: (context) {
                return GoogleMap(
                  markers: widget._controller.markers,
                  polylines: widget._controller.polynesRouter,
                  initialCameraPosition: widget._controller.cameraPosition ??
                      _cameraPositionViagem,
                  mapType: MapType.normal,
                  onMapCreated: _onMapCreated,
                );
              }),
              Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 60, right: 60),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(12)),
                            textStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            elevation: 5,
                            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16)),
                        onPressed: () {
                            widget._controller.onActionRequest();
                            widget._controller.verifyStatusRequest();
                        },
                        child:Observer(
                           builder:(_) {
                              return   Text(
                                  widget._controller.textButtonExibithion ??'',
                                  style:theme.textTheme.titleLarge ,
                              
                             );
                           }, 
                          ),
                      )))
            ],
          )),
    );
  }
}
