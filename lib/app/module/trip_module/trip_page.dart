import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_driver/app/module/auth/controller/authentication_controller.dart';
import 'package:uber_clone_driver/app/module/home_module/home_controller.dart';
import 'package:uber_clone_driver/app/module/home_module/home_page.dart';
class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  final Completer<GoogleMapController> _comtroler = Completer();
  final CameraPosition _cameraPositionViagem =
      const CameraPosition(target: LatLng(-13.001478, -38.499390), zoom: 11);

  _onMapCreated(GoogleMapController googleMapController) {
    _comtroler.complete(googleMapController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Corrida em andamento"),
      ),
      body: Container(
          padding: const EdgeInsets.all(2),
          child: Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: _cameraPositionViagem,
                mapType: MapType.normal,
              ),
              Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 60, right: 60),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            textStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            elevation: 5,
                            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16)),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                      auth: context .get<AuthenticationController>(),
                                      homeController: context .get<HomeController>(),
                                    )),
                            (route) => false,
                          );
                        },
                        child: const Text('Finalizar'),
                      )))
            ],
          )),
    );
  }
}
