import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/model/place.dart';
import 'package:great_places/utils/db_util.dart';
import 'package:great_places/utils/location_util.dart';

class GreatPlace with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items => [...this._items];

  int get itemsCount => this._items.length;

  Place itemByIndex(int index) {
    return this._items[index];
  }

  Future<void> addPlace(
    String title,
    File image,
    LatLng position,
  ) async {
    final String address = await LocationUtil.getAddressFrom(position);

    final newPlace = Place(
      id: Random().nextDouble().toString(),
      title: title,
      location: PlaceLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      ),
      image: image,
    );

    this._items.add(newPlace);

    DbUtil.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'address': address,
    });

    notifyListeners();
  }

  Future<void> loadItems() async {
    final dataList = await DbUtil.getData('places');

    this._items = dataList
        .map(
          (item) => Place(
            id: item["id"].toString(),
            title: item["title"],
            location: PlaceLocation(
              latitude: item["latitude"],
              longitude: item["longitude"],
              address: item["address"],
            ),
            image: File(item["image"]),
          ),
        )
        .toList();

    notifyListeners();
  }
}
