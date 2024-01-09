// wishlist.dart
import 'package:flutter/cupertino.dart';
import 'package:melaka_wanderlust/models/place.dart'; // Import the common Place class
import 'package:cloud_firestore/cloud_firestore.dart';

class Wishlist extends ChangeNotifier {
  final CollectionReference beachCollection =
  FirebaseFirestore.instance.collection('beaches');
  final CollectionReference historicalCollection =
  FirebaseFirestore.instance.collection('historicals');
  final CollectionReference attractionCollection =
  FirebaseFirestore.instance.collection('attractions');
  final CollectionReference restaurantCollection =
  FirebaseFirestore.instance.collection('restaurants');

  List<Place> beachWishlist = [];
  List<Place> historicalWishlist = [];
  List<Place> attractionWishlist = [];
  List<Place> restaurantWishlist = [];

  Future<void> addPlaceToUserWishlist(String username, Place place) async {
    try {
      await FirebaseFirestore.instance.collection('wishlists').add({
        'username': username,
        'placeName': place.name,
        'imagePath' :place.imagePath,
        'latitude' : place.latitude,
        'longitude' : place.longitude,
      });
      print('Place added to wishlist');
    } catch (e) {
      print('Error adding place to wishlist: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUserWishlist(String username) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance.collection('wishlists')
          .where('username', isEqualTo: username)
          .get();

      print(querySnapshot.docs
          .map((doc) => doc.data())
          .toList());

      return querySnapshot.docs
          .map((doc) => doc.data())
          .toList();

    } catch (e) {
      print('Error fetching user wishlist: $e');
      return [];
    }
  }

  Future<void> removePlaceFromUserWishlist(String username, String placeName) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance.collection('wishlists')
          .where('username', isEqualTo: username)
          .where('placeName', isEqualTo: placeName)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      print('Place removed from wishlist');
    } catch (e) {
      print('Error removing place from wishlist: $e');
    }

    notifyListeners();
  }

  // List<Place> getUserWishlist() {
  //   List<Place> combinedWishlist = List<Place>.from(beachWishlist);
  //   combinedWishlist.addAll(historicalWishlist);
  //   combinedWishlist.addAll(attractionWishlist);
  //   combinedWishlist.addAll(restaurantWishlist);
  //   return combinedWishlist;
  // }
  //
  // void removePlaceFromWishlist(Place place) {
  //   if (beachWishlist.contains(place)) {
  //     beachWishlist.remove(place);
  //   } else if (historicalWishlist.contains(place)) {
  //     historicalWishlist.remove(place);
  //   } else if (attractionWishlist.contains(place)) {
  //     attractionWishlist.remove(place);
  //   } else if (restaurantWishlist.contains(place)) {
  //     restaurantWishlist.remove(place);
  //   }
  //   notifyListeners();
  // }
  //
  // Future<void> addPlaceToWishlist(Place place) async {
  //   if (place is Beach && !beachWishlist.contains(place)) {
  //     beachWishlist.add(place);
  //   } else if (place is Historical && !historicalWishlist.contains(place)) {
  //     historicalWishlist.add(place);
  //   } else if (place is Attraction && !attractionWishlist.contains(place)) {
  //     attractionWishlist.add(place);
  //   } else if (place is Restaurant && !restaurantWishlist.contains(place)) {
  //     restaurantWishlist.add(place);
  //   }
  //   notifyListeners();
  // }
  //
  // Future<void> removePlaceToWishlist(Place place) async {
  //   if (place is Beach) {
  //     beachWishlist.remove(place);
  //   } else if (place is Historical) {
  //     historicalWishlist.remove(place);
  //   } else if (place is Attraction) {
  //     attractionWishlist.remove(place);
  //   } else if (place is Restaurant) {
  //     restaurantWishlist.remove(place);
  //   }
  //   notifyListeners();
  // }

  bool isPlaceInWishlist(Place place) {
    if (place is Beach) {
      return beachWishlist.contains(place);
    } else if (place is Historical) {
      return historicalWishlist.contains(place);
    } else if (place is Attraction) {
      return attractionWishlist.contains(place);
    } else if (place is Restaurant) {
      return restaurantWishlist.contains(place);
    }
    return false; // Return false for unsupported place types
  }

  // filter places by categories
  Future<List<Place>> filterPlacesByCategories(List<String> selectedCategories) async {
    List<Place> filteredPlaces = [];

    // Fetch and filter beaches
    List<Beach> filteredBeaches = await fetchBeachList();
    filteredPlaces.addAll(filteredBeaches.where((beach) => selectedCategories.contains(beach.category)));

    // Fetch and filter historical places
    List<Historical> filteredHistoricals = await fetchHistoricalList();
    filteredPlaces.addAll(filteredHistoricals.where((historical) => selectedCategories.contains(historical.category)));

    // Fetch and filter attractions
    List<Attraction> filteredAttractions = await fetchAttractionList();
    filteredPlaces.addAll(filteredAttractions.where((attraction) => selectedCategories.contains(attraction.category)));

    // Fetch and filter restaurants
    List<Restaurant> filteredRestaurants = await fetchRestaurantList();
    filteredPlaces.addAll(filteredRestaurants.where((restaurant) => selectedCategories.contains(restaurant.category)));

    return filteredPlaces;
  }

  // filter places by budget
  Future<List<Place>> filterPlacesByBudget(double minBudget, double maxBudget, List<String> selectedCategories) async {
    List<Place> allFilteredPlaces = await filterPlacesByCategories(selectedCategories);
    List<Place> budgetFilteredPlaces = allFilteredPlaces.where((place) {
      return place.minPrice >= minBudget && place.maxPrice <= maxBudget;
    }).toList();
    return budgetFilteredPlaces;
  }

  // BEACH
  Future<List<Beach>> fetchBeachList() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await beachCollection.get() as QuerySnapshot<Map<String, dynamic>>;
      List<Beach> beachList = snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        var place = Beach.fromFirestore(doc);
        return place;
      })
          .toList();
      print('Fetched ${beachList.length} beaches: $beachList');
      return beachList;
    } catch (e) {
      print('Error fetching beaches: $e');
      throw e;
    }
  }

  Future<void> insertBeachesIntoFirebase(List<Place> beaches) async {
    for (Place beach in beaches) {
      if (beach is Beach) {
        await beachCollection.add({
          'name': beach.name,
          'description': beach.description,
          'minPrice': beach.minPrice,
          'maxPrice': beach.maxPrice,
          'imagePath': beach.imagePath,
          'category' : beach.category,
          'operatingHour' : beach.operatingHours,
          'website' : beach.website,
          'latitude':beach.latitude,
          'longitude': beach.longitude,
        });
      } else {
        // Handle the case where the place is not a Beach
        print('Error: Attempting to add a non-Beach place to beachCollection');
      }
    }
  }

  // HISTORICAL
  Future<List<Historical>> fetchHistoricalList() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await historicalCollection.get() as QuerySnapshot<Map<String, dynamic>>;
      List<Historical> historicalList = snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        var place = Historical.fromFirestore(doc);
        return place;
      })
          .toList();

      print('Fetched ${historicalList.length} historicals: $historicalList');

      return historicalList;
    } catch (e) {
      print('Error fetching historicals: $e');
      throw e;
    }
  }

  Future<void> insertHistoricalsIntoFirebase(List<Place> historicalPlaces) async {
    for (Place historicalPlace in historicalPlaces) {
      await historicalCollection.add({
        'name': historicalPlace.name,
        'description': historicalPlace.description,
        'imagePath': historicalPlace.imagePath,
        // Add any additional fields specific to historical places
      });
    }
  }

  // ATTRACTION
  Future<List<Attraction>> fetchAttractionList() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await attractionCollection.get() as QuerySnapshot<Map<String, dynamic>>;
      List<Attraction> attractionList = snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        var place = Attraction.fromFirestore(doc);
        return place;
      })
          .toList();

      print('Fetched ${attractionList.length} attractions: $attractionList');

      return attractionList;
    } catch (e) {
      print('Error fetching attractions: $e');
      throw e;
    }
  }

  Future<void> insertAttractionsIntoFirebase(List<Place> attractions) async {
    for (Place attraction in attractions) {
      if (attraction is Attraction) {
        await beachCollection.add({
          'name': attraction.name,
          'description': attraction.description,
          'minPrice': attraction.minPrice,
          'maxPrice': attraction.maxPrice,
          'imagePath': attraction.imagePath,
        });
      } else {
        // Handle the case where the place is not a Attraction
        print('Error: Attempting to add a non-Attraction place to attractionCollection');
      }
    }
  }

  // RESTAURANT
  Future<List<Restaurant>> fetchRestaurantList() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await restaurantCollection.get() as QuerySnapshot<Map<String, dynamic>>;
      List<Restaurant> restaurantList = snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        var place = Restaurant.fromFirestore(doc);
        return place;
      })
          .toList();

      print('Fetched ${restaurantList.length} restaurants: $restaurantList');

      return restaurantList;
    } catch (e) {
      print('Error fetching restaurants: $e');
      throw e;
    }
  }

  Future<void> insertRestaurantsIntoFirebase(List<Place> restaurants) async {
    for (Place restaurant in restaurants) {
      if (restaurant is Restaurant) {
        await beachCollection.add({
          'name': restaurant.name,
          'description': restaurant.description,
          'minPrice': restaurant.minPrice,
          'maxPrice': restaurant.maxPrice,
          'imagePath': restaurant.imagePath,
        });
      } else {
        // Handle the case where the place is not a Attraction
        print('Error: Attempting to add a non-Restaurant place to restaurantCollection');
      }
    }
  }

  // COMBINE
  Future<void> fetchPlaceWishlist() async {
    // Fetch beaches
    QuerySnapshot<Map<String, dynamic>> beachSnapshot =
    await beachCollection.get() as QuerySnapshot<Map<String, dynamic>>;
    beachWishlist = beachSnapshot.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      var place = Place.fromFirestore(doc);
      assert(
      place.type == PlaceType.Beach,
      'Expected a Beach but got ${place.type} for document ID: ${doc.id}',
      );
      return Beach(
        firestoreId: place.firestoreId,
        name: place.name,
        description: place.description,
        minPrice: place.minPrice,
        maxPrice: place.maxPrice,
        imagePath: place.imagePath,
        category: place.category,
        operatingHours: place.operatingHours,
        website: place.website,
        latitude: place.latitude,
        longitude: place.longitude,
      );
    })
        .toList();

    // Fetch historicals
    QuerySnapshot<Map<String, dynamic>> historicalSnapshot =
    await historicalCollection.get() as QuerySnapshot<Map<String, dynamic>>;
    historicalWishlist = historicalSnapshot.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      var place = Place.fromFirestore(doc);
      assert(
      place.type == PlaceType.Historical,
      'Expected a Historical but got ${place.type} for document ID: ${doc.id}',
      );
      return Historical(
        firestoreId: place.firestoreId,
        name: place.name,
        description: place.description,
        minPrice: place.minPrice,
        maxPrice: place.maxPrice,
        imagePath: place.imagePath,
        category: place.category,
        operatingHours: place.operatingHours,
        website: place.website,
        latitude: place.latitude,
        longitude: place.longitude,
      );
    })
        .toList();

    // Fetch attractions
    QuerySnapshot<Map<String, dynamic>> attractionSnapshot =
    await attractionCollection.get() as QuerySnapshot<Map<String, dynamic>>;
    attractionWishlist = attractionSnapshot.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      var place = Place.fromFirestore(doc);
      assert(
      place.type == PlaceType.Attraction,
      'Expected a Attraction but got ${place.type} for document ID: ${doc.id}',
      );
      return Attraction(
        firestoreId: place.firestoreId,
        name: place.name,
        description: place.description,
        minPrice: place.minPrice,
        maxPrice: place.maxPrice,
        imagePath: place.imagePath,
        category: place.category,
        operatingHours: place.operatingHours,
        website: place.website,
        latitude: place.latitude,
        longitude: place.longitude,
      );
    })
        .toList();

    // Fetch restaurants
    QuerySnapshot<Map<String, dynamic>> restaurantSnapshot =
    await restaurantCollection.get() as QuerySnapshot<Map<String, dynamic>>;
    restaurantWishlist = restaurantSnapshot.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      var place = Place.fromFirestore(doc);
      assert(
      place.type == PlaceType.Restaurant,
      'Expected a Attraction but got ${place.type} for document ID: ${doc.id}',
      );
      return Restaurant(
        firestoreId: place.firestoreId,
        name: place.name,
        description: place.description,
        minPrice: place.minPrice,
        maxPrice: place.maxPrice,
        imagePath: place.imagePath,
        category: place.category,
        operatingHours: place.operatingHours,
        website: place.website,
        latitude: place.latitude,
        longitude: place.longitude,
      );
    })
        .toList();

    notifyListeners();
  }
}









