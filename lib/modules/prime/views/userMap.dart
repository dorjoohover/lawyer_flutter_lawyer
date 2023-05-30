import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/home/controllers/controllers.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/providers/api_repository.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class UserOrderMapPageView extends StatefulWidget {
  const UserOrderMapPageView(
      {Key? key, required this.lawyerId, required this.location, this.child})
      : super(key: key);
  final String lawyerId;
  final LocationDto location;
  final Widget? child;
  @override
  State<UserOrderMapPageView> createState() => UserOrderMapPageViewState();
}

class UserOrderMapPageViewState extends State<UserOrderMapPageView> {
  final Completer<GoogleMapController> _controller = Completer();

  LatLng lawyer = LatLng(0.0, 0.0);
  final apiRepository = Get.find<ApiRepository>();
  List<LatLng> polylineCoordinates = [];

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyBfIRFXoIgr-h4EDa-MK0S1rs1BViwMP_Y",
        PointLatLng(widget.location.lat!, widget.location.lng!),
        PointLatLng(widget.location.lat!, widget.location.lng!));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) =>
          polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () async {
      LocationDto res = await apiRepository.getLawyerLocation(widget.lawyerId);

      LatLng newLoc = LatLng(res.lat ?? 0.0, res.lng ?? 0.0);
      setState(() {
        lawyer = newLoc;
      });
      
    });

    return Scaffold(
      appBar: PrimeAppBar(
          onTap: () {
            Navigator.of(context).pop();
          },
          title: 'Байршил харах'),
      body: lawyer.latitude == 0.0
          ? Center(
              child: Text('loading'),
            )
          : Stack(
              children: [
                SizedBox(
                  height: defaultHeight(context) + 84,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: lawyer,
                      zoom: 13.5,
                    ),
                    polylines: {
                      Polyline(
                          polylineId: PolylineId("route"),
                          points: polylineCoordinates,
                          color: primary,
                          width: 6)
                    },
                    markers: {
                      Marker(
                        markerId: MarkerId("currentLocation"),
                        position: lawyer,
                      ),
                      Marker(
                        markerId: MarkerId("source"),
                        position:
                            LatLng(widget.location.lng!, widget.location.lat!),
                      ),
                    },
                    onMapCreated: (mapController) {
                      _controller.complete(mapController);
                    },
                  ),
                ),
                widget.child ??
                    Positioned(
                        bottom: MediaQuery.of(context).padding.bottom,
                        left: origin,
                        right: origin,
                        child: MainButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          // disabled: !controller.personal.value,
                          text: "Буцах",
                          child: const SizedBox(),
                        ))
              ],
            ),
    );
  }
}
