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
import 'package:uber_clone_driver/app/module/home_module/widgets/loading_trips_widget.dart';

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
  final UberDriveLifeCycle lifeCycle = UberDriveLifeCycle(onResumed: () {});
  final CameraPosition _cameraPositionViagem =
      const CameraPosition(target: LatLng(-13.001478, -38.499390), zoom: 11);
  _onMapCreated(GoogleMapController googleMapController) {
    widget._homeController.controler.complete(googleMapController);
  }

  List<String> listItens = ["Configurações", "Deslogar"];

  _escolhaItem(String escolha) async {
    switch (escolha) {
      case "Configurações":
        Navigator.pushNamed(context, UberDriveConstants.PROFILE_PAGE_NAME);
        break;
      case "Deslogar":
        await widget._homeController.logout();
        break;
    }
  }

  initReactions() async {
    final idUser = widget._auth.dataStringUser;
    if (idUser != null) {
      showLoaderDialog();
      await widget._homeController.getUserData(idUser);
      hideLoader();
    }
    final reactionUser =
        reaction<bool>((_) => widget._homeController.userOn, (userOn) {
      if (!userOn) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            UberDriveConstants.LOGIN_PAGE_NAME, (_) => false);
      }
    });

    callMessager();
    final serviceEnableReaction = reaction<bool>(
        (_) => widget._homeController.isServiceEnable, (isServiceEnable) {
      if (!isServiceEnable) {
        callInfoSnackBar("Ativse sua localização");
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

    final requisiaoRection = autorun(
      (_) {
        final requestActive = widget._homeController.requisicaoActive;
        if (requestActive != null && requestActive.motorista != null) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              UberDriveConstants.TRIP_PAGE_NAME,
              arguments: requestActive,
              (_) => false);
        }
      },
    );

    final requisiaoRectionInfo = reaction<Requisicao?>(
        (_) => widget._homeController.requisicaoInfo, (requisicaoInfo) {
      showInfoRequistionDialog(
        requisicaoInfo,
        () async {
          if (requisicaoInfo != null) {
            await widget._homeController.acceptedTrip(requisicaoInfo);
          }
        },
        () {
          widget._homeController.rejectTrip();
        },
      );
    });

    listReactions.addAll([
      reactionUser,
      locationPermissionReaction,
      serviceEnableReaction,
      requisiaoRection,
      requisiaoRectionInfo
    ]);
  }

  void showInfoRequistionDialog(Requisicao? requisicao,
      VoidCallback onPositiveButton, VoidCallback onNegativeButton) {
    if (requisicao != null) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          var theme = Theme.of(context);
          return AlertDialog(
            title: Text(
              "Dados da viagem",
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        "Local :${requisicao.destino.nomeDestino}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style:
                            theme.textTheme.titleMedium?.copyWith(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(Icons.attach_money_outlined),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        "Valor :R\$ ${requisicao.valorCorrida} ",
                        style:
                            theme.textTheme.titleMedium?.copyWith(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        "Passageiro :${requisicao.passageiro.nome}",
                        style:
                            theme.textTheme.titleMedium?.copyWith(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onPositiveButton();
                  },
                  child: const Text(
                    "Aceitar Viagem",
                  )),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onNegativeButton();
                  },
                  child: const Text(
                    "Rejeitar Viagem",
                    style: TextStyle(color: Colors.redAccent),
                  ))
            ],
          );
        },
      );
    }
  }

  void callMessager() {
    final reactionDisposerMessage = reaction<String?>(
        (_) => widget._homeController.errorMessage, (messager) {
      if (messager != null) {
        if (messager == UserNotFound.codeExcpetion.toString()) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              UberDriveConstants.LOGIN_PAGE_NAME, (_) => false);
        }
        callSnackBar(messager);
      }
    });

    listReactions.add(reactionDisposerMessage);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(lifeCycle);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initReactions();
    });
    super.initState();
  }

  @override
  void dispose() {
    for (var reactions in listReactions) {
      reactions();
    }
    WidgetsBinding.instance.removeObserver(lifeCycle);
    widget._homeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Motorista'), actions: [
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
              padding: const EdgeInsets.all(16),
              child: Observer(builder: (context) {
                final listRequistions = widget._homeController.requisicoes;
                return listRequistions.isEmpty
                    ? const Center(
                        child: LoadingTripsWidget(),
                      )
                    : ListView.builder(
                        itemCount: listRequistions.length,
                        itemBuilder: (context, index) {
                          final requisicao =
                              widget._homeController.requisicoes[index];

                          return CardTripItem(
                            requisicao: requisicao,
                            onTap: () async {
                              await widget._homeController
                                  .viewTripInfo(requisicao);
                            },
                          );
                        });
              }),
            ),
          ),
          Observer(builder: (context) {
            return Expanded(
                flex: 1,
                child: GoogleMap(
                  
                  initialCameraPosition:
                      widget._homeController.cameraPosition ??
                          _cameraPositionViagem,
                  myLocationEnabled: true,
                  markers: widget._homeController.markers,
                  onMapCreated: _onMapCreated,
                  polylines: widget._homeController.polynesRouter,
                ));
          })
        ],
      ),
    );
  }

  Future bottomShetUber(BuildContext context) {
    return showModalBottomSheet(
      shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(80),
        topRight: Radius.circular(80),
      )),
      context: context,
      builder: (context) {
        return Observer(builder: (context) {
          return Container(
            padding: const EdgeInsets.only(top: 50),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: GoogleMap(
              layoutDirection: TextDirection.ltr,
              initialCameraPosition: widget._homeController.cameraPosition ??
                  _cameraPositionViagem,
              myLocationEnabled: true,
              markers: widget._homeController.markers,
              onMapCreated: _onMapCreated,
            ),
          );
        });
      },
    );
  }
}
