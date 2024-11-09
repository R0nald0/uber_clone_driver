import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:uber_clone_core/uber_clone_core.dart';
import 'package:uber_clone_driver/app/helper/uber_drive_constants.dart';
import 'package:uber_clone_driver/app/module/auth/controller/authentication_controller.dart';
import 'package:uber_clone_driver/app/module/home_module/home_controller.dart';

part 'widgets/card_trip_item.dart';

class HomePage extends StatefulWidget {
  final AuthenticationController _auth;
  final HomeController _homeController;

  const HomePage(
      {super.key,
      required AuthenticationController auth,
      required HomeController homeController})
      : _auth = auth,
        _homeController = homeController;

  @override
  State<HomePage> createState()  => _HomePageState()  ;
}



class _HomePageState extends State<HomePage>  with DialogLoader {

  var listReactions = <ReactionDisposer>[];

 
  final CameraPosition _cameraPositionViagem =
      const CameraPosition(target: LatLng(-13.001478, -38.499390), zoom: 11);

  _onMapCreated(GoogleMapController googleMapController) {
    widget._homeController.controler.complete(googleMapController);
  }


  List<String> listItens = ["Configurações", "Deslogar"];
deslogarUsuario() async {
  widget._auth.logout();
}
_escolhaItem(String escolha) {
  switch (escolha) {
    case "Configurações":
      break;
    case "Deslogar":
      deslogarUsuario();
      break;
  }
}  


  initReactions() async {
     final idUser = widget._auth.dataStringUser;
      if (idUser != null) {
          showLoaderDialog();
          await  widget._homeController.getUserData(idUser);
          await  widget._homeController.findTrips();
          hideLoader();
      } else {
         callMessager();
      }

    final serviceEnableReaction =
        reaction<bool>((_) => widget._homeController.isServiceEnable,
            (isServiceEnable) {
      if (!isServiceEnable) {
        callSnackBar("Ativse sua localização");
      }
    });

    final locationPermissionReaction = reaction<LocationPermission?>( (_) => widget._homeController.locationPermission, (permission) {
      if (permission == LocationPermission.denied) {
        dialogLocationPermissionDenied(() {
          widget._homeController.getPermissionLocation();
        });
  
      } else if (permission == LocationPermission.deniedForever) {
        dialogLocationPermissionDeniedForeve(() {
          Geolocator.openAppSettings();
        });
      }
      
    });     
      listReactions.addAll([locationPermissionReaction,serviceEnableReaction]);
  }

  void callMessager() {
  final  reactionDisposerMessage =
        reaction<String?>((_) => widget._homeController.errorMessage, (messager) {
         if (messager != null) {
            callSnackBar(messager);
         }
    });

    listReactions.add(reactionDisposerMessage);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback( (_){
       
       initReactions();
    }); 
    //TODO IMPLEMENTAR CICLO DE VIDA PARA VERIFICAR SE O USUARIO DEU A PERMISSAO AO VOLTAR PAR O APP
  
  }

  @override
  void dispose() {
    for (var reactions in listReactions) {
      reactions();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(title: const Text('Motorista'), actions: [
        IconButton(
                onPressed: () async {
                  await widget._homeController.getPermissionLocation();
                },
                icon: const Icon(Icons.my_location)),
        PopupMenuButton<String>(
            onSelected: _escolhaItem,
          
            itemBuilder: (context) => listItens.map((String item) {
                  return PopupMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList())
      ]),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Observer(builder: (context) {
                return ListView.builder(
                    itemCount: widget._homeController.requisicoes.length,
                    itemBuilder: (context, index) {
                      final requisicao = widget._homeController.requisicoes[index];
                      return CardTripItem(requisicao: requisicao) ;
                    });
              }),
            ),
          ),

          Observer(
            builder: (context) {
              return Expanded( 
                flex: 1,
                child: GoogleMap(
                  initialCameraPosition: widget._homeController.cameraPosition ?? _cameraPositionViagem,
                  myLocationEnabled: true,
                  markers: widget._homeController.markers,
                  onMapCreated: _onMapCreated,
                  )
                );
            }
          )
        ],
      ),
    );
  }


}
