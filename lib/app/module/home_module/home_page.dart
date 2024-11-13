import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:uber_clone_core/uber_clone_core.dart';
import 'package:uber_clone_driver/app/helper/uber_drive_constants.dart';
import 'package:uber_clone_driver/app/module/auth/controller/authentication_controller.dart';
import 'package:uber_clone_driver/app/module/home_module/home_controller.dart';
import 'package:uber_clone_driver/app/module/home_module/life_cycle/uber_drive_life_cycle.dart';

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
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with DialogLoader {
  var listReactions = <ReactionDisposer>[];
  final UberDriveLifeCycle lifeCycle = UberDriveLifeCycle(onResumed: () {
    //widget._homeController.getUserLocation;
  });

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
      await widget._homeController.getUserData(idUser);
      await widget._homeController.findTrips();
      hideLoader();
    } 
     callMessager();
    final serviceEnableReaction = reaction<bool>(
        (_) => widget._homeController.isServiceEnable, (isServiceEnable) {
      if (!isServiceEnable) {
        callSnackBar("Ativse sua localização");
      }
    });

    final locationPermissionReaction = reaction<LocationPermission?>(
        (_) => widget._homeController.locationPermission, (permission) {
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

    final requisiaoRection = reaction<Requisicao?>(
        (_) => widget._homeController.requisicaoActive, (requisicao) {
           showInfoRequistionDialog(
            requisicao,
            () {
               hideLoader();
               Navigator.of(context).pushNamedAndRemoveUntil(UberDriveConstants.TRIP_PAGE_NAME,arguments: requisicao,(_)=> false);     
            },
            () => widget._homeController.getPermissionLocation(),
            ); 
    });
    listReactions.addAll([locationPermissionReaction, serviceEnableReaction,requisiaoRection]);
  }

  void showInfoRequistionDialog(Requisicao? requisicao,VoidCallback onPositiveButton,VoidCallback onNegativeButton) {
    if (requisicao != null) {
        
       showDialog(context: context, 
       builder:(context) {
           var theme = Theme.of(context);
           return AlertDialog(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Text("Dados da viagem",
                  style:theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 30,),
                 Text("Local : ${requisicao.destino.nomeDestino}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 5,),
                Text("Valor :R\$ ${requisicao.valorCorrida} ",
                 style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 5,),
                 Text("Passageiro :${requisicao.passageiro.nome}",
                 style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
                ),
                
              ],
            ),
            actions: [
              TextButton(onPressed: (){
                 Navigator.of(context).pop();
                 onPositiveButton();
                }, 
              child: const Text(
                "Aceitar Viagem",
                )
              ),
              const SizedBox(width: 10,),
              TextButton(onPressed: (){
               Navigator.of(context).pop();
                 onNegativeButton();
                }, 
              child: const Text(
                "Rejeitar Viagem",
                style: TextStyle(
                  color: Colors.redAccent
                ),
                )
              )
            ],
           );       
       },);
    } 
  }

  void callMessager() {
    final reactionDisposerMessage = reaction<String?>(
        (_) => widget._homeController.errorMessage, (messager) {
      if (messager != null) {
        callSnackBar(messager);
      }
    });

    listReactions.add(reactionDisposerMessage);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(lifeCycle);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initReactions();
    });
    //TODO IMPLEMENTAR CICLO DE VIDA PARA VERIFICAR SE O USUARIO DEU A PERMISSAO AO VOLTAR PAR O APP
  }

  @override
  void dispose() {
    for (var reactions in listReactions) {
      reactions();
    }
    WidgetsBinding.instance.removeObserver(lifeCycle);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Motorista'), actions: [
      
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
                      final requisicao =
                          widget._homeController.requisicoes[index];
                        
                      return CardTripItem(
                        requisicao: requisicao,
                        onTap: () async{
                          await widget._homeController.viewTripInfo(requisicao);
                        },
                      );
                    });
              }),
            ),
          ),
          Observer(builder: (context) {
            return Expanded(
                flex: 1,
                child: Material(
                  borderOnForeground: true,
                  elevation: 10.0,
                  child: GoogleMap(
                    initialCameraPosition:
                        widget._homeController.cameraPosition ??
                            _cameraPositionViagem,
                    myLocationEnabled: true,
                    markers: widget._homeController.markers,
                    onMapCreated: _onMapCreated,
                    polylines: widget._homeController.polynesRouter,
                  ),
                ));
          })
        ],
      ),
    );
  }

  Future bottomShetUber(BuildContext context) {
    return showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (context) {
        return Observer(builder: (context) {
          return Expanded(
              flex: 1,
              child: GoogleMap(
                initialCameraPosition: widget._homeController.cameraPosition ??
                    _cameraPositionViagem,
                myLocationEnabled: true,
                markers: widget._homeController.markers,
                onMapCreated: _onMapCreated,
              ));
        });
      },
    );
  }
}
