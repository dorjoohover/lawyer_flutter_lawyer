import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/shared/index.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationView extends StatefulWidget {
  const LocationView({Key? key}) : super(key: key);
  @override
  State<LocationView> createState() => LocationViewState();
}

class LocationViewState extends State<LocationView> {
  final Completer<GoogleMapController> _controller = Completer();

  LocationData? currentLocation;
  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then((location) {
      setState(() {
        currentLocation = location;
      });
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: currentLocation == null
            ? Center(
                child: Text('loading'),
              )
            : Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    left: origin,
                    right: origin),
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(currentLocation!.latitude!,
                                currentLocation!.longitude!),
                            zoom: 13.5,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId("currentLocation"),
                              position: LatLng(currentLocation!.latitude!,
                                  currentLocation!.longitude!),
                            )
                          },
                          onMapCreated: (mapController) {
                            _controller.complete(mapController);
                          },
                        ),
                      ],
                    ),
                    Positioned(
                        bottom: MediaQuery.of(context).padding.bottom + 50,
                        left: 0,
                        right: 0,
                        child: MainButton(
                          onPressed: () {
                            // controller.sendOrder(context);
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.phone_outlined),
                              space8,
                              Text(
                                'Хуульчтай холбогдох',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ));
  }
}
