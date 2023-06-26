import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/home/home.dart';
import 'package:frontend/providers/api_repository.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage(
      {Key? key, required this.isLawyer, required this.location, this.child})
      : super(key: key);
  final bool isLawyer;
  final LocationDto location;
  final Widget? child;
  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng destination = LatLng(37.33429383, -122.06600055);
  final apiRepository = Get.find<ApiRepository>();
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then((location) {
      setState(() {
        currentLocation = location;
      });
    });
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen((newLoc) {
      if (widget.isLawyer) {
        apiRepository.updateLawyerLocation(
            LocationDto(lat: newLoc.latitude, lng: newLoc.longitude));
      }
      setState(() {
        currentLocation = newLoc;
      });
    });
  }

  void moveCurrentLocation() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!), 14));
  }

  void moveOtherLocation() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(widget.location.lat!, widget.location.lng!), 14));
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyBfIRFXoIgr-h4EDa-MK0S1rs1BViwMP_Y",
        PointLatLng(widget.location.lat!, widget.location.lng!),
        PointLatLng(destination.latitude, destination.longitude));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) =>
          polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
    }
  }

  @override
  void initState() {
    getCurrentLocation();
    getPolyPoints();
    addCustomIcon();
    print(widget.location.toJson());
    super.initState();
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/Location_marker.png")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimeAppBar(
          onTap: () {
            Get.to(() => const HomeView(),
                curve: Curves.bounceIn, duration: Duration(milliseconds: 500));
          },
          title: 'Байршил харах'),
      body: currentLocation == null
          ? Center(
              child: Text('Уншиж байна...'),
            )
          : Stack(
              children: [
                SizedBox(
                  height: defaultHeight(context) + 84,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!),
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
                        position: LatLng(currentLocation!.latitude!,
                            currentLocation!.longitude!),
                      ),
                      Marker(
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueGreen),
                        markerId: MarkerId("source"),
                        position:
                            LatLng(widget.location.lat!, widget.location.lng!),
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
                            Get.to(() => const HomeView(),
                                curve: Curves.bounceIn,
                                duration: Duration(milliseconds: 500));
                          },
                          // disabled: !controller.personal.value,
                          text: "Буцах",
                          child: const SizedBox(),
                        )),
                Positioned(
                    bottom: MediaQuery.of(context).padding.bottom + 80,
                    right: origin,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(100)),
                      child: IconButton(
                        onPressed: () {
                          moveCurrentLocation();
                        },
                        icon: const Icon(
                          Icons.my_location,
                          color: Colors.white,
                        ),
                      ),
                    )),
                Positioned(
                    top: 20,
                    left: origin,
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(100)),
                          width: 10,
                          height: 10,
                        ),
                        space8,
                        Text(
                          widget.isLawyer ? "Хэрэглэгч" : 'Хуульч',
                        )
                      ],
                    )),
                Positioned(
                    top: 40,
                    left: origin,
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(100)),
                          width: 10,
                          height: 10,
                        ),
                        space8,
                        Text(
                          !widget.isLawyer ? "Миний" : 'Хуульч',
                        )
                      ],
                    )),
                Positioned(
                    bottom: MediaQuery.of(context).padding.bottom + 140,
                    right: origin,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(100)),
                      child: IconButton(
                        onPressed: () {
                          moveOtherLocation();
                        },
                        icon: const Icon(
                          Icons.location_city,
                          color: Colors.white,
                        ),
                      ),
                    ))
              ],
            ),
    );
  }
}
