/*import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';

import '../models/map_marker.dart';

class PlaceMap extends StatelessWidget {
  final CustomInfoWindowController customInfoWindowController;
  final List<PlaceInfo> markersData;

  PlaceMap({Key? key, required this.customInfoWindowController, required this.markersData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = markersData.map((placeInfo) {
      return Marker(
        markerId: MarkerId(placeInfo.name),
        icon: BitmapDescriptor.defaultMarker,
        position: placeInfo.latLng,
        onTap: () {
          if (customInfoWindowController.addInfoWindow != null) {
            customInfoWindowController.addInfoWindow!(
              Container(
                height: 700,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 300,
                      height: 130,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(placeInfo.imagePath),
                          fit: BoxFit.fitWidth,
                          filterQuality: FilterQuality.high,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              placeInfo.name,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Price: \$${placeInfo.price.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              placeInfo.latLng,
            );
          } else {
            print('Warning: CustomInfoWindowController or addInfoWindow is null');
          }
        },
      );
    }).toSet();

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(2.200844, 102.240143),
        zoom: 14.4746,
      ),
      markers: Set<Marker>.of(markers),
      onTap: (position) {
        if (customInfoWindowController.hideInfoWindow != null) {
          customInfoWindowController.hideInfoWindow!();
        } else {
          print('Warning: CustomInfoWindowController or hideInfoWindow is null');
        }
      },
      onCameraMove: (position) {
        if (customInfoWindowController.onCameraMove != null) {
          customInfoWindowController.onCameraMove!();
        } else {
          print('Warning: CustomInfoWindowController or onCameraMove is null');
        }
      },
      onMapCreated: (GoogleMapController controller) {
        // You can use the controller if needed
        customInfoWindowController.googleMapController = controller;
        // Set the controller once the map is created
        //customInfoWindowController.mapCreated();
      },
    );
  }
}*/