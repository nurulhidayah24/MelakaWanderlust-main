import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:melaka_wanderlust/tiles/place_tile.dart';
import 'package:provider/provider.dart';
import 'package:melaka_wanderlust/models/wishlist.dart';
import 'package:melaka_wanderlust/models/map_marker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/place.dart';

class BeachTab extends StatelessWidget {

  final CustomInfoWindowController customInfoWindowController;

  BeachTab({
    Key? key,
    required this.customInfoWindowController,
  }) : super(key: key);

  // wishlist
  Future<void> addBeachToWishlist(
      BuildContext context, Beach beach) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? username = prefs.getString('username');
      await Provider.of<Wishlist>(
          context, listen: false).addPlaceToUserWishlist(username!,beach);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Successfully added!'),
          content: Text('Check your wishlist'),
        ),
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to add to wishlist: $error'),
        ),
      );
    }
  }

  // markers
  Future<List<PlaceInfo>> fetchData(String type) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(type).get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Print the data for debugging
        print('Data for document ${doc.id}: $data');

        return PlaceInfo(
          data['name'] ?? '',
          data['imagePath'] ?? '',
          (data['minPrice'] as num?)?.toDouble() ?? 0.0,
          (data['maxPrice'] as num?)?.toDouble() ?? 0.0,
          data['briefDesc'] ?? '',
          LatLng(
            (data['latitude'] as num?)?.toDouble() ?? 0.0,
            (data['longitude'] as num?)?.toDouble() ?? 0.0,
          ),
          type,
        );
      }).toList();
    } catch (error) {
      print('Error fetching data: $error');
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.only(top: 12),
            child: Stack(
              children: [
                FutureBuilder<List<PlaceInfo>>(
                  future: fetchData('beaches'), // Fetch data for 'beaches' collection
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No data available.');
                    } else {
                      List<PlaceInfo> beachList = snapshot.data!;
                      return GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(2.24580, 102.25095),
                          zoom: 11,
                        ),
                        markers: Set<Marker>.of(
                          beachList.map((placeInfo) {
                            return Marker(
                              markerId: MarkerId('${placeInfo.type}_${placeInfo.name}'),
                              icon: BitmapDescriptor.defaultMarker,
                              position: placeInfo.latLng,
                              onTap: () {
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
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  placeInfo.minPrice == 0
                                                      ? 'Free Entry'
                                                      : 'Price: RM ${placeInfo.minPrice} - RM ${placeInfo.maxPrice}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.green, // Set the text color to green
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  '${placeInfo.briefDesc}', // Add category here
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
                              },
                            );
                          }),
                        ),
                        onTap: (position) {
                          customInfoWindowController.hideInfoWindow!();
                        },
                        onCameraMove: (position) {
                          customInfoWindowController.onCameraMove!();
                        },
                        onMapCreated: (GoogleMapController controller) {
                          customInfoWindowController.googleMapController = controller;
                        },
                      );
                    }
                  },
                ),
                CustomInfoWindow(
                  controller: customInfoWindowController,
                  height: 250,
                  width: 300,
                  offset: 35,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Consumer<Wishlist>(
            builder: (context, value, child) {
              return FutureBuilder<List<Beach>>(
                future: value.fetchBeachList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No data available.');
                  } else {
                    List<Beach> beachList = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView.builder(
                              itemCount: beachList.length,
                              itemBuilder: (context, index) {
                                Beach beach = beachList[index];
                                // Determine whether the beach is a favorite or not
                                bool isFavorite = value.isPlaceInWishlist(beach);
                                return PlaceTile(
                                    place: beach,
                                    isFavorite: isFavorite);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}


