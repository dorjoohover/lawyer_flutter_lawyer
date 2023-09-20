// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/modules/emergency/emergency.dart';
import 'package:frontend/modules/lawyer/lawyer.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationView extends StatefulWidget {
  const LocationView({Key? key}) : super(key: key);
  @override
  State<LocationView> createState() => LocationViewState();
}

class LocationViewState extends State<LocationView> {
  // final Completer<GoogleMapController> _controller = Completer();

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
    final controller = Get.put(EmergencyController());
    return MapsWidget(
        step: 0,
        title: 'Байршил сонгох',
        navigator: () async {
          bool res = await controller.sendOrder();
          if (res) {
            Navigator.push(context, createRoute(const EmergencyHomeView()));
          }
        },
        child: Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(
                  top: large, right: origin, left: origin, bottom: origin),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(medium),
                      topRight: Radius.circular(medium))),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: gold,
                        size: 38,
                      ),
                      space16,
                      Flexible(
                          child: Text(
                        'Байршил зөвхөн Улаанбаатар хотод дотор байх ёстойг анхаарна уу',
                        style: Theme.of(context).textTheme.displayMedium,
                      ))
                    ],
                  ),
                  space32,
                  MainButton(
                    width: double.infinity,
                    onPressed: () async {
                      bool res = await controller.sendOrder();
                      if (res) {
                        Navigator.push(
                            context,
                            createRoute(SuccessView(
                              type: 'fulfilledEmergency',
                            )));
                      }
                    },
                    // disabled: !controller.personal.value,
                    text: "Төлбөр төлөх",
                    child: const SizedBox(),
                  )
                ],
              ),
            )),
        onTap: (p0) {
          controller.location.value?.lat = p0.latitude;
          controller.location.value?.lng = p0.longitude;
        });
  }
}
